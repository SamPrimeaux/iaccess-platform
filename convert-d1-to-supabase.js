#!/usr/bin/env node
/**
 * Convert D1 (SQLite) schema to Supabase (PostgreSQL)
 */

const fs = require('fs');

const schemaData = JSON.parse(fs.readFileSync('./d1_schema.json', 'utf8'));
const tables = schemaData.result[0].results;

console.log(`Found ${tables.length} tables to convert\n`);

function convertSqliteToPostgres(sql, tableName) {
  if (!sql) return null;
  
  let pgSql = sql;
  
  // Handle INTEGER PRIMARY KEY AUTOINCREMENT -> SERIAL PRIMARY KEY
  pgSql = pgSql.replace(/(\w+)\s+INTEGER\s+PRIMARY\s+KEY\s+AUTOINCREMENT/gi, '$1 SERIAL PRIMARY KEY');
  
  // Handle just INTEGER PRIMARY KEY (without AUTOINCREMENT) for id fields
  pgSql = pgSql.replace(/id\s+INTEGER\s+PRIMARY\s+KEY(?!\s+AUTOINCREMENT)/gi, 'id SERIAL PRIMARY KEY');
  
  // SQLite datetime functions to PostgreSQL
  pgSql = pgSql.replace(/strftime\s*\(\s*'%s'\s*,\s*'now'\s*\)/gi, "EXTRACT(EPOCH FROM NOW())::BIGINT");
  pgSql = pgSql.replace(/strftime\s*\(\s*'%Y-%m-%dT%H:%M:%fZ'\s*,\s*'now'\s*\)/gi, "NOW()");
  pgSql = pgSql.replace(/datetime\s*\(\s*'now'\s*\)/gi, "NOW()");
  pgSql = pgSql.replace(/unixepoch\s*\(\s*\)/gi, "EXTRACT(EPOCH FROM NOW())::BIGINT");
  pgSql = pgSql.replace(/CURRENT_TIMESTAMP/gi, "NOW()");
  
  // REAL -> DOUBLE PRECISION (or keep as REAL, PostgreSQL supports both)
  pgSql = pgSql.replace(/\bREAL\b/gi, 'DOUBLE PRECISION');
  
  // JSON -> JSONB (PostgreSQL prefers JSONB)
  pgSql = pgSql.replace(/\bJSON\b/gi, 'JSONB');
  
  // SQLite DATETIME -> TIMESTAMPTZ
  pgSql = pgSql.replace(/\bDATETIME\b/gi, 'TIMESTAMPTZ');
  
  // Remove SQLite-specific CHECK constraints that are inline (these break PostgreSQL)
  // Handle patterns like: , _category_check TEXT\n  CHECK (category IN (...))
  pgSql = pgSql.replace(/,\s*_\w+_check\s+TEXT\s*\n\s*CHECK\s*\([^)]+\)/gi, '');
  
  // Clean up trailing commas before closing parenthesis
  pgSql = pgSql.replace(/,(\s*\))/g, '$1');
  
  // Handle FOREIGN KEY references (PostgreSQL uses same syntax, so this should work)
  
  return pgSql;
}

// Group tables by category
const categories = {
  core: ['organizations', 'users', 'teams', 'team_members', 'user_sessions', 'user_profiles'],
  projects: ['projects', 'project_members', 'tasks', 'board_tasks', 'kanban_boards', 'kanban_columns', 'kanban_tasks', 'billing_projects', 'project_costs', 'project_activity', 'project_assignments', 'project_cost_summary', 'project_deadlines', 'project_milestones', 'project_progress', 'project_registry', 'project_stats', 'project_tasks', 'project_team', 'project_todos'],
  ai_agents: ['agent_sessions', 'agent_telemetry', 'agent_commands', 'agent_configs', 'custom_agents', 'chat_messages', 'chat_conversations', 'ai_conversations', 'ai_messages', 'ai_responses', 'ai_chunks', 'ai_knowledge_base'],
  storage: ['files', 'r2_buckets', 'r2_objects', 'image_meta', 'images_metadata', 'assets', 'asset_metadata', 'extracted_files'],
  analytics: ['analytics', 'token_usage', 'api_usage', 'api_requests', 'workflow_analytics', 'iautodidact_analytics', 'submission_analytics'],
  billing: ['time_entries', 'time_logs', 'time_sessions', 'model_pricing', 'openai_spending', 'openai_budgets', 'openai_model_usage', 'cost_attribution', 'user_time_tracking', 'work_sessions'],
};

// Generate migration SQL
let migrationSql = `-- Supabase Migration: D1 Schema Import
-- Generated: ${new Date().toISOString()}
-- Source: D1 database "meauxos"
-- Total tables: ${tables.length}

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

`;

// Track successful conversions and issues
const converted = [];
const issues = [];

for (const table of tables) {
  const pgSql = convertSqliteToPostgres(table.sql, table.name);
  
  if (pgSql) {
    migrationSql += `-- Table: ${table.name}\n`;
    migrationSql += `${pgSql};\n\n`;
    converted.push(table.name);
  } else {
    issues.push({ name: table.name, reason: 'No SQL found' });
  }
}

// Write migration file
const timestamp = new Date().toISOString().replace(/[-:T]/g, '').slice(0, 14);
const migrationPath = `./supabase/migrations/${timestamp}_import_d1_schema.sql`;
fs.writeFileSync(migrationPath, migrationSql);

console.log(`✅ Converted ${converted.length} tables`);
console.log(`📁 Migration saved to: ${migrationPath}`);

if (issues.length > 0) {
  console.log(`\n⚠️  ${issues.length} tables had issues:`);
  issues.forEach(i => console.log(`   - ${i.name}: ${i.reason}`));
}

// Also write a summary
const summaryPath = './supabase/d1_tables_summary.txt';
fs.writeFileSync(summaryPath, `D1 Tables Summary\n${'='.repeat(50)}\n\n${converted.join('\n')}`);
console.log(`\n📋 Table list saved to: ${summaryPath}`);
