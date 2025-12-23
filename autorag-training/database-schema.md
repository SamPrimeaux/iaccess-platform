# Meauxbility Database Schema Reference

## Core Tables

### Users & Organizations
- `users` - User accounts with auth info
- `organizations` - Multi-tenant organizations
- `teams` - Team groupings within orgs
- `team_members` - Team membership and roles
- `user_sessions` - Active user sessions
- `user_profiles` - Extended user profiles

### Projects & Tasks
- `projects` - Project definitions
- `project_members` - Project team assignments
- `tasks` - Task management
- `kanban_boards` - Kanban board configs
- `kanban_columns` - Board columns
- `kanban_tasks` - Tasks on boards
- `billing_projects` - Billable project tracking
- `project_costs` - Cost tracking per project

### AI & Agents
- `agent_configs` - AI agent configurations
- `agent_commands` - Available agent commands
- `agent_sessions` - Active agent sessions
- `agent_telemetry` - Agent performance metrics
- `custom_agents` - User-defined agents
- `ai_conversations` - AI chat history
- `ai_messages` - Individual AI messages
- `ai_knowledge_base` - RAG knowledge documents
- `ai_chunks` - Vectorized document chunks

### Time & Billing
- `time_entries` - Time tracking records
- `time_logs` - Detailed time logs
- `time_sessions` - Work session tracking
- `token_usage` - AI token consumption
- `model_pricing` - AI model cost rates
- `openai_spending` - OpenAI usage tracking

### Content & Knowledge
- `captains_log` - Activity logging
- `knowledge_base` - Knowledge articles
- `prompt_templates` - AI prompt library
- `documents` - Document storage
- `content_library` - Content assets

### Infrastructure
- `r2_buckets` - R2 bucket registry
- `r2_objects` - R2 object metadata
- `cloudflare_projects` - CF project catalog
- `worker_logs` - Worker execution logs
- `infrastructure_documentation` - Infra docs

### Grants & Applications
- `grant_opportunities` - Grant listings
- `grant_applications` - Submitted applications
- `grant_workflows` - Application workflows
- `grant_templates` - Proposal templates

### Learning (iAutodidact)
- `iautodidact_content` - Learning content
- `iautodidact_lessons` - Individual lessons
- `iautodidact_modules` - Course modules
- `iautodidact_progress` - User progress
- `iautodidact_learning_paths` - Learning paths
