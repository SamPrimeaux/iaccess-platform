# Meauxbility Platform System Overview

## Infrastructure Components

### Databases
- **D1 (meauxos)**: Primary SQLite database with 191 tables
- **Supabase**: PostgreSQL database synced from D1 with 209 tables
- **Database ID**: d8261777-9384-44f7-924d-c92247d55b46

### Storage (R2 Buckets)
- autorag-meauxbility-chatbot - AutoRAG training data
- allinfrastructure - Infrastructure documentation

### Cloudflare Account
- Account ID: ede6590ac0d2fb7daf155b35653457b2

## AI Agents Configured

1. **Supabase Agent** - Database operations
2. **Cloudflare Agent** - Workers, D1, R2, Stream
3. **AWS Agent** - Bedrock, API Gateway
4. **Google AI Agent** - Gemini, Vision, Speech, Translate
5. **Groq Agent** - Fast LLM inference
6. **Cursor AI Agent** - Code assistance
7. **Meshy AI Agent** - 3D model generation
8. **CloudConvert Agent** - File conversion
9. **Resend Agent** - Transactional email
10. **GitHub Agent** - Repository management
11. **D1 Database Agent** - SQLite operations
12. **R2 Storage Agent** - Object storage

## MCP (Model Context Protocol) Servers

- Supabase (HTTP)
- Cloudflare (Workers API)
- GitHub (Repository access)
- Postgres (Direct DB connection)
- Filesystem (Local file access)
- Memory (Context storage)
- Fetch (HTTP requests)
- Google AI (Gemini)
