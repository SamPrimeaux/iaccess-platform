# MCP (Model Context Protocol) Configuration

## Active MCP Servers

### Supabase MCP
- **Type**: HTTP URL
- **URL**: https://mcp.supabase.com/mcp?project_ref=qmpghmthbhuumemnahcz
- **Capabilities**: Database queries, Auth, Storage, Realtime

### Cloudflare MCP
- **Type**: NPX Command
- **Package**: @cloudflare/mcp-server-cloudflare
- **Account ID**: ede6590ac0d2fb7daf155b35653457b2
- **Capabilities**: Workers, D1, R2, KV, Queues, Stream

### GitHub MCP
- **Type**: NPX Command
- **Package**: @modelcontextprotocol/server-github
- **Capabilities**: Repository access, Issues, PRs, Actions

### PostgreSQL MCP
- **Type**: NPX Command
- **Package**: @modelcontextprotocol/server-postgres
- **Connection**: Supabase Pooler (port 6543)
- **Capabilities**: Direct SQL queries

### Filesystem MCP
- **Type**: NPX Command
- **Package**: @modelcontextprotocol/server-filesystem
- **Root**: /workspace
- **Capabilities**: File read/write/list

### Memory MCP
- **Type**: NPX Command
- **Package**: @modelcontextprotocol/server-memory
- **Capabilities**: Persistent context storage

### Fetch MCP
- **Type**: NPX Command
- **Package**: @modelcontextprotocol/server-fetch
- **Capabilities**: HTTP requests, Web scraping

### Google AI MCP
- **Type**: NPX Command
- **Package**: @anthropic/mcp-server-google-ai
- **Capabilities**: Gemini API access
