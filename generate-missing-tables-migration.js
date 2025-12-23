#!/usr/bin/env node
/**
 * Generate Supabase migration for D1 tables not yet in Supabase
 */

const fs = require('fs');

// Read the tables that need to be migrated
const tablesToMigrate = fs.readFileSync('/tmp/tables_to_migrate.txt', 'utf8')
  .split('\n')
  .filter(t => t.trim())
  .map(t => t.trim());

// Read full D1 schema
const schemaData = JSON.parse(fs.readFileSync('./d1_schema.json', 'utf8'));
const allTables = schemaData.result[0].results;

console.log(`Tables to migrate: ${tablesToMigrate.length}`);

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
  
  // REAL -> DOUBLE PRECISION
  pgSql = pgSql.replace(/\bREAL\b/gi, 'DOUBLE PRECISION');
  
  // JSON -> JSONB
  pgSql = pgSql.replace(/\bJSON\b/gi, 'JSONB');
  
  // SQLite DATETIME -> TIMESTAMPTZ
  pgSql = pgSql.replace(/\bDATETIME\b/gi, 'TIMESTAMPTZ');
  
  // Remove SQLite-specific CHECK constraints that are inline
  pgSql = pgSql.replace(/,\s*_\w+_check\s+TEXT\s*\n\s*CHECK\s*\([^)]+\)/gi, '');
  
  // Clean up trailing commas before closing parenthesis
  pgSql = pgSql.replace(/,(\s*\))/g, '$1');
  
  // Remove FOREIGN KEY constraints for now (we'll add them in a separate migration)
  // This prevents dependency ordering issues
  pgSql = pgSql.replace(/,\s*FOREIGN KEY\s*\([^)]+\)\s*REFERENCES\s*[^)]+\)(\s*ON\s+(DELETE|UPDATE)\s+\w+)*/gi, '');
  
  return pgSql;
}

// Build migration
let migrationSql = `-- Supabase Migration: D1 Tables Not Yet in Supabase
-- Generated: ${new Date().toISOString()}
-- Tables to add: ${tablesToMigrate.length}
-- Note: Foreign keys removed to prevent dependency issues

`;

const converted = [];
const skipped = [];

for (const tableName of tablesToMigrate) {
  const tableData = allTables.find(t => t.name === tableName);
  
  if (!tableData || !tableData.sql) {
    skipped.push(tableName);
    continue;
  }
  
  const pgSql = convertSqliteToPostgres(tableData.sql, tableName);
  
  if (pgSql) {
    migrationSql += `-- Table: ${tableName}\n`;
    migrationSql += `${pgSql};\n\n`;
    converted.push(tableName);
  } else {
    skipped.push(tableName);
  }
}

// Write migration file
const timestamp = new Date().toISOString().replace(/[-:T]/g, '').slice(0, 14);
const migrationPath = `./supabase/migrations/${timestamp}_add_missing_d1_tables.sql`;
fs.writeFileSync(migrationPath, migrationSql);

console.log(`✅ Converted ${converted.length} tables`);
console.log(`📁 Migration saved to: ${migrationPath}`);

if (skipped.length > 0) {
  console.log(`\n⚠️  Skipped ${skipped.length} tables (no SQL found):`);
  skipped.forEach(t => console.log(`   - ${t}`));
}

// Output the path for next step
console.log(`\n📄 Migration file size: ${(fs.statSync(migrationPath).size / 1024).toFixed(1)} KB`);
