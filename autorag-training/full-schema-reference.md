# Complete Database Schema

This document contains the full SQL schema for all 191 tables in the Meauxbility D1 database.

## activity_logs
```sql
CREATE TABLE activity_logs (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    metadata TEXT,
    timestamp INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (user_id) REFERENCES team_members(id)
)
```

## adoption_history
```sql
CREATE TABLE adoption_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  animal_id INTEGER NOT NULL,
  adopter_name TEXT,
  adopter_email TEXT,
  adopter_phone TEXT,
  adoption_date DATETIME,
  adoption_status TEXT DEFAULT 'pending', 
  notes TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (animal_id) REFERENCES animals(id)
)
```

## agent_commands
```sql
CREATE TABLE agent_commands (
  id TEXT PRIMARY KEY,
  command TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  template TEXT NOT NULL,
  category TEXT NOT NULL,
  variables TEXT,
  examples TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  created_by TEXT DEFAULT 'system'
)
```

## agent_configs
```sql
CREATE TABLE agent_configs (
  id TEXT PRIMARY KEY,
  agent_name TEXT NOT NULL,
  agent_type TEXT NOT NULL,
  service_provider TEXT NOT NULL,
  api_keys_json TEXT,
  endpoints_json TEXT,
  config_json TEXT,
  status TEXT DEFAULT 'active',
  created_at INTEGER DEFAULT (strftime('%s', 'now')),
  updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## agent_sessions
```sql
CREATE TABLE agent_sessions (
    id TEXT PRIMARY KEY,
    project_name TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'initializing',
    current_feature TEXT,
    features_completed INTEGER DEFAULT 0,
    features_total INTEGER DEFAULT 0,
    app_spec TEXT,
    feature_list TEXT,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## agent_telemetry
```sql
CREATE TABLE agent_telemetry (
    id TEXT PRIMARY KEY,
    message_id TEXT,
    event_type TEXT,
    rating INTEGER,
    feedback TEXT,
    correction TEXT,
    data TEXT,
    timestamp INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## ai_chunks
```sql
CREATE TABLE ai_chunks (
  id TEXT PRIMARY KEY,
  document_id TEXT NOT NULL,
  chunk_index INTEGER NOT NULL,
  text TEXT NOT NULL,
  token_count INTEGER,
  vector_id TEXT UNIQUE,
  embedding_json TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (document_id) REFERENCES ai_knowledge_base(id) ON DELETE CASCADE
)
```

## ai_conversations
```sql
CREATE TABLE ai_conversations (
  id TEXT PRIMARY KEY,
  user_id TEXT DEFAULT 'default',
  title TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
)
```

## ai_knowledge_base
```sql
CREATE TABLE ai_knowledge_base (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT,
  source_file TEXT,
  source_type TEXT DEFAULT 'upload',
  tags TEXT,
  chunk_count INTEGER DEFAULT 0,
  token_count INTEGER DEFAULT 0,
  embedding_model TEXT,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
)
```

## ai_messages
```sql
CREATE TABLE ai_messages (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  role TEXT NOT NULL CHECK(role IN ('user', 'assistant', 'system')),
  content TEXT NOT NULL,
  sources TEXT,
  model_used TEXT,
  latency_ms INTEGER,
  created_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (conversation_id) REFERENCES ai_conversations(id) ON DELETE CASCADE
)
```

## ai_responses
```sql
CREATE TABLE ai_responses (id TEXT PRIMARY KEY, prompt TEXT NOT NULL, response TEXT NOT NULL, model TEXT NOT NULL, gateway TEXT NOT NULL, timestamp TEXT NOT NULL, created_at INTEGER DEFAULT (strftime('%s', 'now')))
```

## analytics
```sql
CREATE TABLE analytics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_type TEXT NOT NULL,
    resource_type TEXT NOT NULL,
    resource_id TEXT NOT NULL,
    event_data TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## animal_photos
```sql
CREATE TABLE animal_photos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  animal_id INTEGER NOT NULL,
  photo_url TEXT NOT NULL,
  cloudflare_image_id TEXT,
  is_primary INTEGER DEFAULT 0,
  display_order INTEGER DEFAULT 0,
  alt_text TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE CASCADE
)
```

## animals
```sql
CREATE TABLE animals (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  species TEXT NOT NULL, 
  breed TEXT,
  age TEXT, 
  gender TEXT, 
  color TEXT,
  markings TEXT,
  status TEXT DEFAULT 'available', 
  description TEXT,
  bio TEXT, 
  medical_info TEXT, 
  special_requirements TEXT, 
  spayed_neutered INTEGER DEFAULT 0,
  vaccines_utd INTEGER DEFAULT 0,
  rabies INTEGER DEFAULT 0,
  heartworm_negative INTEGER DEFAULT 0,
  microchipped INTEGER DEFAULT 0,
  featured_photo_url TEXT,
  featured_photo_id TEXT, 
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  added_by TEXT,
  notes TEXT
)
```

## api_credentials
```sql
CREATE TABLE api_credentials (
  id TEXT PRIMARY KEY,
  service_name TEXT NOT NULL,
  credential_type TEXT NOT NULL,
  key_name TEXT NOT NULL,
  key_value_hash TEXT,
  environment TEXT DEFAULT 'production',
  is_active INTEGER DEFAULT 1,
  created_at INTEGER DEFAULT (strftime('%s', 'now')),
  updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## api_integrations
```sql
CREATE TABLE api_integrations (
  id TEXT PRIMARY KEY,
  service_name TEXT NOT NULL UNIQUE, -- 'google', 'openai', 'github', 'cloudconvert'
  api_key_encrypted TEXT, -- Encrypted API key
  config_json TEXT, -- JSON config for the service
  enabled BOOLEAN DEFAULT 1,
  last_used INTEGER,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
)
```

## api_requests
```sql
CREATE TABLE api_requests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER,
  response_time INTEGER, -- milliseconds
  ip_address TEXT,
  user_agent TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## api_usage
```sql
CREATE TABLE api_usage (
    id TEXT PRIMARY KEY,
    service TEXT NOT NULL,
    metric TEXT NOT NULL,
    value REAL NOT NULL,
    cost_usd REAL DEFAULT 0,
    recorded_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## app_deployments
```sql
CREATE TABLE app_deployments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    deployment_id TEXT NOT NULL UNIQUE,
    app_name TEXT NOT NULL,
    app_type TEXT,
    path TEXT NOT NULL,
    status TEXT DEFAULT 'deployed',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## app_refinements
```sql
CREATE TABLE app_refinements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    refinement_id TEXT NOT NULL UNIQUE,
    app_name TEXT NOT NULL,
    refinements TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## apps
```sql
CREATE TABLE apps (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  tagline TEXT,
  description TEXT,
  long_description TEXT,
  
  -- Metadata
  category TEXT NOT NULL,
  subcategory TEXT,
  developer TEXT NOT NULL,
  developer_url TEXT,
  
  -- Versions
  version TEXT NOT NULL,
  build_number INTEGER,
  release_date TEXT NOT NULL,
  min_os_version TEXT,
  
  -- Assets (R2 keys)
  icon_url TEXT NOT NULL,
  hero_image_url TEXT,
  screenshots TEXT, -- JSON array of screenshot URLs
  video_url TEXT,
  
  -- Metrics
  downloads INTEGER DEFAULT 0,
  rating REAL DEFAULT 0,
  review_count INTEGER DEFAULT 0,
  
  -- Access
  is_public BOOLEAN DEFAULT 1,
  is_featured BOOLEAN DEFAULT 0,
  install_url TEXT NOT NULL,
  documentation_url TEXT,
  
  -- Timestamps
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
, status TEXT, tags TEXT, icon_key TEXT, preview_url TEXT, repo_url TEXT, dashboard_url TEXT, last_update TEXT)
```

## asset_metadata
```sql
CREATE TABLE asset_metadata (
              key TEXT PRIMARY KEY,
              user_id TEXT,
              tags TEXT,
              favorite INTEGER DEFAULT 0,
              source TEXT,
              display_name TEXT,
              created_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
```

## assets
```sql
CREATE TABLE assets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  key TEXT NOT NULL UNIQUE,
  bucket TEXT NOT NULL,
  size INTEGER,
  content_type TEXT,
  metadata TEXT,
  uploaded_at TEXT DEFAULT CURRENT_TIMESTAMP,
  last_accessed_at TEXT
)
```

## backup_jobs
```sql
CREATE TABLE backup_jobs (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    backup_type TEXT NOT NULL,
    status TEXT NOT NULL,
    source_type TEXT NOT NULL,
    source_path TEXT,
    destination_bucket TEXT NOT NULL,
    destination_path TEXT,
    include_node_modules BOOLEAN DEFAULT 0,
    include_env_files BOOLEAN DEFAULT 0,
    compress BOOLEAN DEFAULT 1,
    encryption_enabled BOOLEAN DEFAULT 0,
    total_files INTEGER DEFAULT 0,
    files_processed INTEGER DEFAULT 0,
    bytes_total INTEGER DEFAULT 0,
    bytes_processed INTEGER DEFAULT 0,
    progress_percent REAL DEFAULT 0,
    backup_size_bytes INTEGER,
    backup_path TEXT,
    backup_checksum TEXT,
    error_message TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    started_at TEXT,
    completed_at TEXT,
    scheduled_for TEXT
)
```

## billing_projects
```sql
CREATE TABLE billing_projects (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    client TEXT,
    type TEXT DEFAULT 'webapp',
    status TEXT DEFAULT 'active',
    metadata TEXT,
    hourly_rate REAL DEFAULT 0.0,
    budget REAL DEFAULT 0.0,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## board_tasks
```sql
CREATE TABLE board_tasks (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT,
          status TEXT NOT NULL DEFAULT 'todo',
          project_id TEXT,
          due_date TEXT,
          priority INTEGER DEFAULT 0,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
```

## build_assets
```sql
CREATE TABLE build_assets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id TEXT NOT NULL,
  asset_type TEXT NOT NULL, 
  file_name TEXT NOT NULL,
  file_path TEXT,
  file_size_bytes INTEGER,
  content_hash TEXT,
  r2_backup_path TEXT,
  created_at TEXT DEFAULT (datetime('now'))
)
```

## build_changes
```sql
CREATE TABLE build_changes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id TEXT NOT NULL,
  change_type TEXT NOT NULL, 
  component TEXT NOT NULL, 
  description TEXT,
  file_path TEXT,
  line_count INTEGER,
  created_at TEXT DEFAULT (datetime('now'))
)
```

## build_locks
```sql
CREATE TABLE build_locks (
  id TEXT PRIMARY KEY,
  project TEXT NOT NULL,
  domain TEXT NOT NULL,
  locked_by TEXT NOT NULL,
  locked_at INTEGER NOT NULL,
  expires_at INTEGER NOT NULL,
  created_at INTEGER DEFAULT (unixepoch()),
  UNIQUE(project, domain)
)
```

## build_sessions
```sql
CREATE TABLE build_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id TEXT UNIQUE NOT NULL,
  started_at TEXT NOT NULL,
  ended_at TEXT,
  worker_name TEXT,
  version TEXT,
  build_type TEXT, 
  status TEXT DEFAULT 'in_progress', 
  created_by TEXT DEFAULT 'Claude AI',
  notes TEXT
)
```

## build_storage
```sql
CREATE TABLE build_storage (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    deployment_id TEXT,
    build_version TEXT NOT NULL,
    storage_type TEXT NOT NULL DEFAULT 'r2',
    storage_path TEXT NOT NULL,
    storage_bucket TEXT NOT NULL,
    storage_size_bytes INTEGER NOT NULL,
    storage_checksum TEXT,
    build_type TEXT NOT NULL,
    build_platform TEXT NOT NULL,
    build_config TEXT,
    file_count INTEGER DEFAULT 0,
    directory_structure TEXT,
    compressed BOOLEAN DEFAULT 0,
    compression_type TEXT,
    original_size_bytes INTEGER,
    public_url TEXT,
    expires_at TEXT,
    access_count INTEGER DEFAULT 0,
    last_accessed_at TEXT,
    description TEXT,
    tags TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## calendar_events
```sql
CREATE TABLE calendar_events (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    start_time TEXT NOT NULL,
    end_time TEXT,
    location TEXT,
    attendees TEXT, -- JSON array
    created_by TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## captains_log
```sql
CREATE TABLE captains_log (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    mission_title TEXT NOT NULL,
    entry_content TEXT NOT NULL,
    status TEXT DEFAULT 'active',
    tags TEXT,
    timestamp INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (user_id) REFERENCES user_profiles(id)
)
```

## certificates
```sql
CREATE TABLE certificates (   id TEXT PRIMARY KEY,   userId TEXT NOT NULL,   courseId TEXT NOT NULL,   enrollmentId TEXT NOT NULL,   issuedAt TEXT NOT NULL,   certificateUrl TEXT,   verificationCode TEXT UNIQUE,   FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,   FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE CASCADE,   FOREIGN KEY (enrollmentId) REFERENCES enrollments(id) ON DELETE CASCADE )
```

## channels
```sql
CREATE TABLE channels (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## chat_conversations
```sql
CREATE TABLE chat_conversations (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        conversation_id TEXT NOT NULL,
                        user_message TEXT NOT NULL,
                        assistant_response TEXT NOT NULL,
                        images TEXT,
                        metadata TEXT,
                        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
                    )
```

## chat_messages
```sql
CREATE TABLE chat_messages (
    id TEXT PRIMARY KEY,
    session_id TEXT,
    role TEXT NOT NULL,
    content TEXT NOT NULL,
    timestamp INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (session_id) REFERENCES agent_sessions(id)
)
```

## cloudflare_projects
```sql
CREATE TABLE cloudflare_projects (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      brand TEXT NOT NULL,
      priority INTEGER NOT NULL,
      urls TEXT NOT NULL,
      status TEXT,
      created_at TEXT,
      updated_at TEXT,
      cataloged_at INTEGER DEFAULT (unixepoch())
    )
```

## code_knowledge_base
```sql
CREATE TABLE code_knowledge_base (
    id TEXT PRIMARY KEY,
    language TEXT, -- 'typescript', 'javascript', 'python', 'sql', etc.
    category TEXT, -- 'api', 'database', 'ui', 'auth', 'deployment', etc.
    title TEXT NOT NULL,
    code_snippet TEXT NOT NULL,
    description TEXT,
    use_case TEXT,
    quality_score INTEGER, -- 1-10
    embedding_json TEXT,
    metadata_json TEXT, -- {dependencies, version, tested, etc.}
    created_by TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## command_executions
```sql
CREATE TABLE command_executions (
  id TEXT PRIMARY KEY,
  command TEXT NOT NULL,
  user_id TEXT NOT NULL,
  user_email TEXT NOT NULL,
  user_name TEXT,
  channel TEXT,
  status TEXT NOT NULL, -- 'success', 'error', 'blocked'
  message TEXT,
  data TEXT, -- JSON string for additional data
  executed_at INTEGER DEFAULT (unixepoch()),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
)
```

## contacts
```sql
CREATE TABLE contacts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  company TEXT,
  message TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  status TEXT DEFAULT 'new' CHECK (status IN ('new', 'read', 'replied', 'archived')),
  notes TEXT
)
```

## content_library
```sql
CREATE TABLE content_library (
    id TEXT PRIMARY KEY,
    bucket_name TEXT NOT NULL,
    object_key TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size INTEGER,
    content_type TEXT,
    uploaded_at TEXT,
    tags TEXT, -- JSON array
    description TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## content_metadata
```sql
CREATE TABLE content_metadata (
    key TEXT NOT NULL,
    bucket TEXT NOT NULL,
    fileName TEXT NOT NULL,
    fileSize INTEGER NOT NULL,
    contentType TEXT NOT NULL,
    uploadedAt TEXT NOT NULL,
    uploadedBy TEXT,
    tags TEXT,
    description TEXT,
    cloudflareImageId TEXT,
    PRIMARY KEY (key, bucket)
)
```

## conversation_history
```sql
CREATE TABLE conversation_history (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  source TEXT NOT NULL, -- 'claude', 'chatgpt', 'other'
  external_id TEXT, -- ID from external service
  title TEXT NOT NULL,
  preview TEXT, -- First message or summary
  message_count INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  metadata TEXT, -- JSON string for additional data
  UNIQUE(external_id, source)
)
```

## conversation_messages
```sql
CREATE TABLE conversation_messages (
  id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  conversation_id TEXT NOT NULL,
  role TEXT NOT NULL, -- 'user', 'assistant', 'system'
  content TEXT NOT NULL,
  model TEXT, -- Model used (e.g., 'gpt-4', 'claude-3-opus')
  tokens INTEGER,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  metadata TEXT, -- JSON string for additional data
  FOREIGN KEY (conversation_id) REFERENCES conversation_history(id) ON DELETE CASCADE
)
```

## cost_attribution
```sql
CREATE TABLE cost_attribution (
    id TEXT PRIMARY KEY,
    spending_id TEXT, -- Links to openai_spending.id
    project_id TEXT,
    project_name TEXT,
    task_id TEXT,
    task_description TEXT,
    team_member TEXT,
    api_type TEXT, -- openai, gemini, cloudflare, etc.
    model TEXT,
    prompt_text TEXT, -- The actual prompt used
    prompt_tokens INTEGER,
    completion_tokens INTEGER,
    total_tokens INTEGER,
    cost_usd REAL,
    success BOOLEAN DEFAULT true,
    result_quality_score REAL, -- 0-1 score of result quality
    workflow_improvement_notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## courses
```sql
CREATE TABLE courses (   id TEXT PRIMARY KEY,   tenantId TEXT NOT NULL,   title TEXT NOT NULL,   slug TEXT NOT NULL,   description TEXT,   shortDescription TEXT,   category TEXT,    level TEXT DEFAULT 'beginner',    duration TEXT,    thumbnailUrl TEXT,   iconUrl TEXT,   status TEXT DEFAULT 'draft',    featured INTEGER DEFAULT 0,    orderIndex INTEGER DEFAULT 0,   createdAt TEXT NOT NULL,   updatedAt TEXT NOT NULL,   FOREIGN KEY (tenantId) REFERENCES tenants(id) ON DELETE CASCADE,   UNIQUE(tenantId, slug) )
```

## cross_device_sync
```sql
CREATE TABLE cross_device_sync (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    sync_key TEXT NOT NULL, -- 'dashboard_state', 'current_project', etc.
    sync_data TEXT NOT NULL, -- JSON data
    updated_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_by_device TEXT, -- device_id that made the update
    FOREIGN KEY (user_id) REFERENCES team_members(id)
)
```

## custom_agents
```sql
CREATE TABLE custom_agents (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    name TEXT NOT NULL,
    persona TEXT,
    training_data TEXT,
    project_context TEXT,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (user_id) REFERENCES user_profiles(id)
)
```

## dashboard_sessions
```sql
CREATE TABLE dashboard_sessions (id TEXT PRIMARY KEY, user_id TEXT NOT NULL, token_id TEXT, session_token TEXT UNIQUE NOT NULL, expires_at INTEGER NOT NULL, last_activity INTEGER DEFAULT (strftime('%s', 'now')), ip_address TEXT, user_agent TEXT, created_at INTEGER DEFAULT (strftime('%s', 'now')))
```

## data_sources
```sql
CREATE TABLE data_sources (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            type TEXT,
            record_count INTEGER DEFAULT 0,
            last_sync TEXT,
            created_at TEXT DEFAULT (datetime('now'))
          )
```

## database_schemas
```sql
CREATE TABLE database_schemas (
    id TEXT PRIMARY KEY,
    database_name TEXT NOT NULL,
    database_id TEXT, -- Cloudflare D1 database ID
    schema_version TEXT,
    schema_file_path TEXT, -- Path in allinfrastructure bucket
    schema_content TEXT, -- Full schema SQL or JSON
    tables_count INTEGER,
    indexes_count INTEGER,
    last_updated INTEGER,
    documented_at INTEGER DEFAULT (unixepoch()),
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch())
)
```

## deployment_environments
```sql
CREATE TABLE deployment_environments (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    environment_name TEXT NOT NULL, -- 'fred-dev', 'connor-dev', etc.
    subdomain TEXT NOT NULL, -- 'fred-dev.meauxbility.workers.dev'
    worker_name TEXT,
    pages_name TEXT,
    is_active INTEGER DEFAULT 1,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (user_id) REFERENCES team_members(id),
    UNIQUE(user_id, environment_name)
)
```

## deployment_logs
```sql
CREATE TABLE deployment_logs (
    id TEXT PRIMARY KEY,
    file_name TEXT NOT NULL,
    file_type TEXT NOT NULL,
    original_size INTEGER,
    optimized_size INTEGER,
    optimizations_applied TEXT,
    deployed_url TEXT,
    status TEXT CHECK (status IN ('pending', 'processing', 'success', 'failed')),
    error_message TEXT,
    deployed_by TEXT,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    completed_at INTEGER
)
```

## deployments
```sql
CREATE TABLE deployments (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    platform TEXT NOT NULL,
    status TEXT NOT NULL,
    environment TEXT NOT NULL,
    commit_sha TEXT,
    commit_message TEXT,
    branch TEXT,
    deployer TEXT,
    build_command TEXT,
    output_directory TEXT,
    url TEXT,
    preview_url TEXT,
    build_log_url TEXT,
    build_time_ms INTEGER,
    build_size_bytes INTEGER,
    build_output_size_bytes INTEGER,
    build_stored BOOLEAN DEFAULT 0,
    build_storage_path TEXT,
    build_storage_size_bytes INTEGER,
    error_message TEXT,
    error_stack TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    started_at TEXT,
    completed_at TEXT
)
```

## design_knowledge_base
```sql
CREATE TABLE design_knowledge_base (
    id TEXT PRIMARY KEY,
    design_type TEXT NOT NULL, -- 'logo', 'brand_identity', 'ui_ux', 'graphic', 'icon', 'color_palette', 'typography'
    title TEXT NOT NULL,
    description TEXT,
    quality_level TEXT, -- 'clay_global', 'professional', 'good', 'reference'
    design_principles TEXT, -- Design principles applied
    tools_used TEXT, -- JSON array: ['Spline', 'Figma', 'Illustrator', etc.]
    reference_urls TEXT, -- JSON array of reference URLs
    embedding_json TEXT,
    metadata_json TEXT, -- {colors, fonts, style, inspiration, etc.}
    created_by TEXT DEFAULT 'fred',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## design_templates
```sql
CREATE TABLE design_templates (
    id TEXT PRIMARY KEY,
    template_name TEXT NOT NULL,
    design_type TEXT, -- 'logo', 'brand_identity', 'ui_component', etc.
    quality_standard TEXT, -- 'clay_global', 'professional', etc.
    template_data TEXT, -- JSON or file reference
    usage_instructions TEXT,
    quality_score INTEGER,
    embedding_json TEXT,
    metadata_json TEXT, -- {colors, fonts, dimensions, tools, etc.}
    created_by TEXT DEFAULT 'fred',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## designs
```sql
CREATE TABLE designs (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            category TEXT,
            tags TEXT,
            thumbnail_url TEXT,
            created_at TEXT DEFAULT (datetime('now'))
          )
```

## development_workflows
```sql
CREATE TABLE development_workflows (
    id TEXT PRIMARY KEY,
    workflow_name TEXT NOT NULL,
    description TEXT,
    category TEXT, -- 'setup', 'deployment', 'testing', 'debugging', 'optimization', 'architecture'
    steps_json TEXT, -- JSON array of workflow steps
    code_examples TEXT, -- Code snippets or examples
    time_estimate INTEGER, -- Minutes
    success_rate REAL, -- 0-1
    quality_score INTEGER, -- 1-10
    last_used DATETIME,
    use_count INTEGER DEFAULT 0,
    created_by TEXT,
    embedding_json TEXT, -- For RAG search
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## device_sessions
```sql
CREATE TABLE device_sessions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    device_id TEXT NOT NULL, -- Unique device identifier
    device_name TEXT NOT NULL, -- "Sam's MacBook", "Sam's iPhone", etc.
    device_type TEXT NOT NULL, -- 'desktop', 'mobile', 'tablet'
    user_agent TEXT,
    ip_address TEXT,
    last_activity INTEGER DEFAULT (strftime('%s', 'now')),
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    expires_at INTEGER, -- NULL = never expires
    is_active INTEGER DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES team_members(id),
    UNIQUE(user_id, device_id)
)
```

## documents
```sql
CREATE TABLE documents (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT,
    category TEXT, -- brand-guidelines, handbook, api-docs, etc.
    owner_id TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## donations
```sql
CREATE TABLE donations (
          id TEXT PRIMARY KEY,
          amount INTEGER,
          currency TEXT,
          status TEXT,
          stripe_payment_intent_id TEXT,
          created_at INTEGER
        )
```

## ecosystem_knowledge_base
```sql
CREATE TABLE ecosystem_knowledge_base (
    id TEXT PRIMARY KEY,
    workflow_type TEXT NOT NULL, -- 'development', 'design', 'grant_writing', 'general', 'branding'
    document_type TEXT NOT NULL, -- 'best_practice', 'template', 'example', 'tutorial', 'workflow', 'code_snippet', 'design_asset'
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    embedding_json TEXT, -- JSON array of embedding vectors
    chunk_index INTEGER DEFAULT 0,
    source TEXT, -- 'uploaded', 'ai_generated', 'past_project', 'external'
    metadata_json TEXT, -- JSON: {tags, quality_score, success_rate, time_saved, etc.}
    created_by TEXT, -- 'sam', 'connor', 'fred', 'amber', 'system'
    assigned_to TEXT, -- Team member this is most relevant for
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## ecosystem_rag_queries
```sql
CREATE TABLE ecosystem_rag_queries (
    id TEXT PRIMARY KEY,
    query_text TEXT NOT NULL,
    workflow_type TEXT, -- 'development', 'design', 'grant_writing', 'general'
    team_member TEXT, -- Who asked
    retrieved_docs TEXT, -- JSON array of document IDs
    generated_response TEXT,
    context_type TEXT,
    success_rating INTEGER, -- 1-5 user rating
    time_saved INTEGER, -- Minutes saved
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## email_events
```sql
CREATE TABLE email_events (
                        id TEXT PRIMARY KEY,
                        event_type TEXT NOT NULL,
                        email_id TEXT,
                        recipient TEXT,
                        status TEXT,
                        metadata TEXT,
                        created_at TEXT DEFAULT CURRENT_TIMESTAMP
                    )
```

## email_messages
```sql
CREATE TABLE email_messages (
    id TEXT PRIMARY KEY,
    from_address TEXT NOT NULL,
    to_address TEXT NOT NULL,
    subject TEXT,
    body TEXT,
    received_at TEXT DEFAULT CURRENT_TIMESTAMP,
    read BOOLEAN DEFAULT 0
)
```

## employee_storage
```sql
CREATE TABLE employee_storage (
    id TEXT PRIMARY KEY,
    employee_email TEXT NOT NULL UNIQUE,
    employee_name TEXT NOT NULL,
    r2_bucket_name TEXT NOT NULL,
    storage_quota_gb INTEGER DEFAULT 10,
    storage_used_gb REAL DEFAULT 0,
    folder_path TEXT DEFAULT '', -- Subfolder path in bucket (e.g., 'employees/sam/')
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## enrollments
```sql
CREATE TABLE enrollments (   id TEXT PRIMARY KEY,   userId TEXT NOT NULL,   courseId TEXT NOT NULL,   enrolledAt TEXT NOT NULL,   completedAt TEXT,   progress INTEGER DEFAULT 0,    status TEXT DEFAULT 'active',    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,   FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE CASCADE,   UNIQUE(userId, courseId) )
```

## env_variables
```sql
CREATE TABLE env_variables (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    environment TEXT NOT NULL,
    key TEXT NOT NULL,
    value TEXT NOT NULL,
    encrypted BOOLEAN DEFAULT 1,
    description TEXT,
    is_secret BOOLEAN DEFAULT 1,
    required BOOLEAN DEFAULT 0,
    default_value TEXT,
    synced_to_platform BOOLEAN DEFAULT 0,
    last_synced_at TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(project_id, environment, key)
)
```

## external_integrations
```sql
CREATE TABLE external_integrations (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    service_name TEXT NOT NULL, -- 'openai', 'claude', 'canva', 'instagram', 'capcut', etc.
    service_type TEXT NOT NULL, -- 'ai', 'social', 'design', 'video'
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at INTEGER,
    api_key TEXT, -- For API key-based services
    metadata TEXT, -- JSON with service-specific data
    is_active INTEGER DEFAULT 1,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (user_id) REFERENCES team_members(id),
    UNIQUE(user_id, service_name)
)
```

## extracted_files
```sql
CREATE TABLE extracted_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    project_id TEXT NOT NULL,
    zip_id TEXT NOT NULL,
    zip_key TEXT NOT NULL,
    file_key TEXT NOT NULL,
    file_name TEXT NOT NULL,
    mime_type TEXT,
    size_bytes INTEGER,
    created_at TEXT DEFAULT (datetime('now'))
)
```

## feature_flags
```sql
CREATE TABLE feature_flags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  feature_name TEXT UNIQUE NOT NULL,
  enabled INTEGER DEFAULT 0,
  version_introduced TEXT,
  description TEXT,
  config JSON,
  updated_at TEXT DEFAULT (datetime('now'))
)
```

## files
```sql
CREATE TABLE files (
    id TEXT PRIMARY KEY,
    organization_id TEXT,
    project_id TEXT,
    user_id TEXT NOT NULL,
    name TEXT NOT NULL,
    filename TEXT NOT NULL,
    path TEXT NOT NULL,
    mime_type TEXT,
    size INTEGER,
    storage_type TEXT DEFAULT 'r2',
    storage_bucket TEXT,
    storage_key TEXT,
    cloudflare_image_id TEXT,
    url TEXT,
    thumbnail_url TEXT,
    width INTEGER,
    height INTEGER,
    duration INTEGER,
    metadata JSON,
    is_public INTEGER DEFAULT 0,
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch())
)
```

## github_repos
```sql
CREATE TABLE github_repos (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  full_name TEXT NOT NULL,
  url TEXT,
  default_branch TEXT DEFAULT 'main',
  deploy_key_id TEXT, -- GitHub deploy key ID
  webhook_secret TEXT, -- Webhook secret for auto-deploy
  auto_deploy BOOLEAN DEFAULT 0,
  last_deployed INTEGER,
  created_at INTEGER DEFAULT (unixepoch()),
  updated_at INTEGER DEFAULT (unixepoch())
)
```

## grant_activity_log
```sql
CREATE TABLE grant_activity_log (
    id TEXT PRIMARY KEY,
    entity_type TEXT, -- 'opportunity', 'application', 'campaign'
    entity_id TEXT,
    action TEXT, -- 'created', 'updated', 'submitted', 'approved', etc.
    user_id TEXT,
    details TEXT, -- JSON details
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## grant_applications
```sql
CREATE TABLE grant_applications (
    id TEXT PRIMARY KEY,
    opportunity_id TEXT,
    status TEXT DEFAULT 'draft', -- 'draft', 'submitted', 'under_review', 'approved', 'declined', 'funded'
    submitted_date DATE,
    amount_requested REAL,
    proposal_text TEXT,
    budget_json TEXT, -- JSON budget breakdown
    supporting_docs TEXT, -- JSON array of R2 file paths
    notes TEXT,
    team_notes TEXT, -- Notes from other team members
    created_by TEXT DEFAULT 'amber',
    assigned_to TEXT DEFAULT 'amber', -- Primary grant writer
    reviewed_by TEXT, -- Team member who reviewed
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (opportunity_id) REFERENCES grant_opportunities(id)
)
```

## grant_campaigns
```sql
CREATE TABLE grant_campaigns (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    target_amount REAL,
    deadline DATE,
    status TEXT DEFAULT 'planning', -- 'planning', 'active', 'completed', 'cancelled'
    grants_included TEXT, -- JSON array of opportunity IDs
    team_members TEXT, -- JSON array of team member IDs
    created_by TEXT DEFAULT 'amber',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## grant_knowledge_base
```sql
CREATE TABLE grant_knowledge_base (
    id TEXT PRIMARY KEY,
    document_type TEXT NOT NULL, -- 'proposal', 'success_story', 'best_practice', 'mission_statement', 'impact_data'
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    embedding_json TEXT, -- JSON array of embedding vectors
    chunk_index INTEGER DEFAULT 0, -- For chunked documents
    source TEXT, -- 'uploaded', 'ai_generated', 'past_proposal'
    metadata_json TEXT, -- JSON: {tags, grant_type, amount, date, success_rate, etc.}
    created_by TEXT DEFAULT 'amber',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## grant_opportunities
```sql
CREATE TABLE grant_opportunities (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    organization TEXT,
    amount_min REAL,
    amount_max REAL,
    deadline DATE,
    status TEXT DEFAULT 'open', -- 'open', 'upcoming', 'closed', 'archived'
    eligibility TEXT,
    requirements TEXT,
    application_url TEXT,
    contact_email TEXT,
    contact_phone TEXT,
    relevance_score INTEGER DEFAULT 0, -- 1-10 AI-generated score
    location TEXT, -- State/region focus
    focus_areas TEXT, -- JSON array: ["mobility", "spinal_cord_injury", "accessibility"]
    notes TEXT,
    ai_insights TEXT, -- Gemini-generated analysis
    created_by TEXT DEFAULT 'amber', -- Team member who added it
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## grant_research_notes
```sql
CREATE TABLE grant_research_notes (
    id TEXT PRIMARY KEY,
    opportunity_id TEXT,
    note_text TEXT,
    ai_insights TEXT, -- Gemini-generated insights
    competitive_analysis TEXT, -- Strengths/weaknesses
    created_by TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (opportunity_id) REFERENCES grant_opportunities(id)
)
```

## grant_templates
```sql
CREATE TABLE grant_templates (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    template_text TEXT, -- Template content
    sections TEXT, -- JSON array of section names
    created_by TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## grant_templates_rag
```sql
CREATE TABLE grant_templates_rag (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    grant_type TEXT, -- 'equipment', 'program', 'capital', 'operating'
    sections_json TEXT, -- Template structure
    best_practices TEXT, -- AI-generated best practices
    example_text TEXT, -- Example content
    embedding_json TEXT, -- Template embedding
    success_rate REAL, -- Historical success rate
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## grant_workflows
```sql
CREATE TABLE grant_workflows (
    id TEXT PRIMARY KEY,
    workflow_name TEXT NOT NULL,
    description TEXT,
    steps_json TEXT, -- JSON array of workflow steps
    estimated_time INTEGER, -- Minutes
    required_resources TEXT, -- JSON array
    success_rate REAL,
    last_used DATETIME,
    use_count INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## iautodidact_analytics
```sql
CREATE TABLE iautodidact_analytics (
    id TEXT PRIMARY KEY,
    team_member TEXT,
    module_id TEXT,
    lesson_id TEXT,
    action_type TEXT, -- 'view', 'complete', 'quiz_attempt', 'code_run', 'error'
    action_data TEXT, -- JSON: {details, time_spent, errors, etc.}
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## iautodidact_code_examples
```sql
CREATE TABLE iautodidact_code_examples (
    id TEXT PRIMARY KEY,
    module_id TEXT,
    lesson_id TEXT,
    example_name TEXT NOT NULL,
    language TEXT, -- 'typescript', 'javascript', 'python', 'bash'
    code_snippet TEXT NOT NULL,
    description TEXT,
    use_case TEXT,
    api_type TEXT, -- 'openai', 'cloudflare', 'gemini', 'google_cloud'
    testable BOOLEAN DEFAULT 0, -- Can be run/tested
    test_code TEXT, -- Test cases or validation
    embedding_json TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (module_id) REFERENCES iautodidact_modules(id),
    FOREIGN KEY (lesson_id) REFERENCES iautodidact_lessons(id)
)
```

## iautodidact_content
```sql
CREATE TABLE iautodidact_content (
    id TEXT PRIMARY KEY,
    content_type TEXT, -- 'tutorial', 'example', 'best_practice', 'troubleshooting'
    title TEXT NOT NULL,
    content_text TEXT NOT NULL,
    api_type TEXT, -- 'openai', 'cloudflare', 'gemini', 'google_cloud'
    category TEXT, -- 'prompting', 'functions', 'embeddings', 'fine-tuning', etc.
    source_url TEXT, -- Original cookbook URL if applicable
    embedding_json TEXT,
    metadata_json TEXT, -- {tags, difficulty, related_modules, etc.}
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## iautodidact_learning_paths
```sql
CREATE TABLE iautodidact_learning_paths (
    id TEXT PRIMARY KEY,
    path_name TEXT NOT NULL,
    description TEXT,
    target_audience TEXT, -- 'developers', 'designers', 'all', 'sam', 'connor', etc.
    modules_json TEXT, -- JSON array of module IDs in order
    estimated_total_time INTEGER,
    difficulty_level TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## iautodidact_lessons
```sql
CREATE TABLE iautodidact_lessons (
    id TEXT PRIMARY KEY,
    module_id TEXT NOT NULL,
    lesson_name TEXT NOT NULL,
    lesson_type TEXT, -- 'tutorial', 'example', 'exercise', 'quiz', 'project'
    content_html TEXT, -- Full lesson content (HTML)
    code_examples TEXT, -- JSON array of code examples
    interactive_examples TEXT, -- JSON: {sandbox_url, test_cases, etc.}
    learning_objectives TEXT, -- JSON array
    difficulty_level TEXT,
    order_index INTEGER DEFAULT 0,
    estimated_time INTEGER,
    embedding_json TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (module_id) REFERENCES iautodidact_modules(id)
)
```

## iautodidact_modules
```sql
CREATE TABLE iautodidact_modules (
    id TEXT PRIMARY KEY,
    module_name TEXT NOT NULL,
    category TEXT NOT NULL, -- 'openai', 'cloudflare', 'gemini', 'google_cloud', 'general'
    description TEXT,
    difficulty_level TEXT, -- 'beginner', 'intermediate', 'advanced'
    estimated_time INTEGER, -- Minutes
    order_index INTEGER DEFAULT 0,
    content_json TEXT, -- JSON: {lessons, exercises, examples, code_snippets}
    prerequisites TEXT, -- JSON array of module IDs
    completion_criteria TEXT,
    embedding_json TEXT, -- For RAG search
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## iautodidact_progress
```sql
CREATE TABLE iautodidact_progress (
    id TEXT PRIMARY KEY,
    team_member TEXT NOT NULL, -- 'sam', 'connor', 'fred', 'amber'
    module_id TEXT,
    lesson_id TEXT,
    status TEXT, -- 'not_started', 'in_progress', 'completed', 'skipped'
    progress_percentage INTEGER DEFAULT 0,
    time_spent INTEGER DEFAULT 0, -- Minutes
    last_accessed DATETIME,
    completed_at DATETIME,
    notes TEXT,
    quiz_scores TEXT, -- JSON: {quiz_id: score}
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (module_id) REFERENCES iautodidact_modules(id),
    FOREIGN KEY (lesson_id) REFERENCES iautodidact_lessons(id)
)
```

## image_meta
```sql
CREATE TABLE image_meta (
    key TEXT PRIMARY KEY,
    title TEXT,
    alt TEXT,
    tags TEXT,
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## images_metadata
```sql
CREATE TABLE images_metadata (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  image_id TEXT NOT NULL UNIQUE, -- Cloudflare Images ID
  filename TEXT,
  description TEXT,
  tags TEXT, -- JSON array as text
  category TEXT,
  sensitive INTEGER DEFAULT 0, -- 0 = false, 1 = true
  variants TEXT, -- JSON array as text
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## infrastructure_directories
```sql
CREATE TABLE infrastructure_directories (
    id TEXT PRIMARY KEY,
    bucket_name TEXT NOT NULL DEFAULT 'allinfrastructure',
    path TEXT NOT NULL UNIQUE, -- e.g., 'database-schemas/', 'database/'
    parent_path TEXT, -- Parent directory path
    object_count INTEGER DEFAULT 0,
    total_size_bytes INTEGER DEFAULT 0,
    last_synced_at INTEGER,
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch())
)
```

## infrastructure_documentation
```sql
CREATE TABLE infrastructure_documentation (
    id TEXT PRIMARY KEY,
    bucket_name TEXT NOT NULL DEFAULT 'allinfrastructure',
    r2_key TEXT NOT NULL UNIQUE, -- Full path in R2 (e.g., 'ANALYTICS_SETUP.md')
    title TEXT NOT NULL,
    file_type TEXT, -- 'markdown', 'json', 'image', etc.
    category TEXT, -- 'analytics', 'r2-setup', 'database', 'onboarding', etc.
    size_bytes INTEGER,
    content_preview TEXT, -- First 500 chars for quick reference
    r2_object_id TEXT, -- Reference to r2_objects table
    tags TEXT, -- JSON array of tags
    last_synced_at INTEGER,
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch()),
    FOREIGN KEY (r2_object_id) REFERENCES r2_objects(id) ON DELETE SET NULL
)
```

## infrastructure_metadata
```sql
CREATE TABLE infrastructure_metadata (
    id TEXT PRIMARY KEY,
    metadata_type TEXT NOT NULL, -- 'infrastructure-map', 'team-directory', 'config', etc.
    bucket_name TEXT NOT NULL DEFAULT 'allinfrastructure',
    r2_key TEXT NOT NULL UNIQUE,
    metadata_json TEXT NOT NULL, -- Full JSON content
    version TEXT,
    last_synced_at INTEGER,
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch())
)
```

## journey_applications
```sql
CREATE TABLE journey_applications (
  id TEXT PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  injury_type TEXT,
  injury_date TEXT,
  current_situation TEXT,
  goals TEXT,
  support_needed TEXT,
  how_heard TEXT,
  additional_info TEXT,
  status TEXT NOT NULL DEFAULT 'new', -- 'new', 'reviewed', 'contacted', 'approved', 'declined'
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
)
```

## kanban_boards
```sql
CREATE TABLE kanban_boards (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    owner_id TEXT,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## kanban_columns
```sql
CREATE TABLE kanban_columns (
    id TEXT PRIMARY KEY,
    board_id TEXT NOT NULL,
    name TEXT NOT NULL,
    position INTEGER NOT NULL,
    color TEXT DEFAULT '#4AECDC',
    FOREIGN KEY (board_id) REFERENCES kanban_boards(id)
)
```

## kanban_tasks
```sql
CREATE TABLE kanban_tasks (
    id TEXT PRIMARY KEY,
    board_id TEXT NOT NULL,
    column_id TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    category TEXT CHECK (category IN ('html', 'worker', 'content', 'client', 'system')),
    priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    assignee_id TEXT,
    client_name TEXT,
    project_url TEXT,
    bindings TEXT,
    due_date INTEGER,
    position INTEGER NOT NULL,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now')),
    completed_at INTEGER,
    FOREIGN KEY (board_id) REFERENCES kanban_boards(id),
    FOREIGN KEY (column_id) REFERENCES kanban_columns(id),
    FOREIGN KEY (assignee_id) REFERENCES team_members(id)
)
```

## knowledge_base
```sql
CREATE TABLE knowledge_base (
  id TEXT PRIMARY KEY,
  category TEXT NOT NULL,
  title TEXT NOT NULL,
  content_summary TEXT,
  tags TEXT,
  r2_path TEXT NOT NULL,
  file_size INTEGER,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  indexed_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## lessons
```sql
CREATE TABLE lessons (   id TEXT PRIMARY KEY,   courseId TEXT NOT NULL,   title TEXT NOT NULL,   slug TEXT NOT NULL,   description TEXT,   content TEXT,    videoUrl TEXT,   duration INTEGER,    orderIndex INTEGER NOT NULL,   isPublished INTEGER DEFAULT 0,    createdAt TEXT NOT NULL,   updatedAt TEXT NOT NULL,   FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE CASCADE,   UNIQUE(courseId, slug) )
```

## library_builds
```sql
CREATE TABLE library_builds (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL,
    status TEXT DEFAULT 'working',
    size INTEGER DEFAULT 0,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    source_path TEXT,
    preview_url TEXT,
    thumbnail_path TEXT,
    deployed_url TEXT,
    repo_url TEXT
)
```

## mail_received
```sql
CREATE TABLE mail_received (
            id TEXT PRIMARY KEY,
            resend_id TEXT,
            from_addr TEXT NOT NULL,
            subject TEXT,
            received_at TEXT NOT NULL,
            snippet TEXT,
            body TEXT,
            created_at TEXT DEFAULT (datetime('now'))
          )
```

## main.analytics_snapshots
```sql
CREATE TABLE "main.analytics_snapshots"(
  "sam_primeaux" TEXT
)
```

## meauxaccess_commands
```sql
CREATE TABLE meauxaccess_commands (id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT UNIQUE NOT NULL, name TEXT NOT NULL, description TEXT, category TEXT, created_at DATETIME DEFAULT CURRENT_TIMESTAMP)
```

## meauxaccess_executions
```sql
CREATE TABLE meauxaccess_executions (id INTEGER PRIMARY KEY AUTOINCREMENT, command_code TEXT NOT NULL, user_id TEXT, status TEXT NOT NULL, message TEXT, executed_at DATETIME DEFAULT CURRENT_TIMESTAMP)
```

## meauxauto_ingestions
```sql
CREATE TABLE meauxauto_ingestions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id TEXT NOT NULL UNIQUE,
    source TEXT NOT NULL,
    source_path TEXT,
    status TEXT DEFAULT 'processing',
    documents INTEGER DEFAULT 0,
    tokens INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    completed_at TEXT
)
```

## meauxauto_queries
```sql
CREATE TABLE meauxauto_queries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conversation_id TEXT,
    query TEXT NOT NULL,
    response TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## meauxauto_training
```sql
CREATE TABLE meauxauto_training (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    training_id TEXT NOT NULL UNIQUE,
    status TEXT DEFAULT 'processing',
    model_version TEXT,
    accuracy REAL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    completed_at TEXT
)
```

## meauxbility_context
```sql
CREATE TABLE meauxbility_context (
    id TEXT PRIMARY KEY,
    context_type TEXT NOT NULL, -- 'mission', 'impact_story', 'statistic', 'program_description'
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    data_json TEXT, -- Structured data (numbers, dates, etc.)
    embedding_json TEXT,
    priority INTEGER DEFAULT 5, -- 1-10, higher = more important to include
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## meeting_notes
```sql
CREATE TABLE meeting_notes (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    stream_id TEXT, -- Cloudflare Stream ID
    meeting_type TEXT DEFAULT 'general', -- 'nonprofit', 'team', 'client', etc.
    meeting_name TEXT,
    transcript TEXT, -- Full transcript if available
    notes TEXT, -- AI-generated notes
    todos TEXT, -- JSON array of to-do items
    summary TEXT, -- AI-generated summary
    key_points TEXT, -- JSON array of key discussion points
    participants TEXT, -- JSON array of participant names/IDs
    duration INTEGER, -- Meeting duration in seconds
    recording_url TEXT, -- Link to recording if available
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## messages
```sql
CREATE TABLE messages (
    id TEXT PRIMARY KEY,
    channel_id TEXT,
    user_id TEXT NOT NULL,
    user_name TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## missions
```sql
CREATE TABLE missions (
  id TEXT PRIMARY KEY,
  vision_id TEXT,
  title TEXT NOT NULL,
  description TEXT,
  target_date TEXT,
  status TEXT DEFAULT 'active' CHECK(status IN ('active', 'completed', 'paused')),
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (vision_id) REFERENCES visions(id)
)
```

## model_pricing
```sql
CREATE TABLE model_pricing (
    model TEXT PRIMARY KEY,
    provider TEXT NOT NULL,
    input_price_per_1m REAL NOT NULL,
    output_price_per_1m REAL NOT NULL,
    context_window INTEGER,
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## newsletter_subscribers
```sql
CREATE TABLE newsletter_subscribers (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        email TEXT UNIQUE NOT NULL,
                        source TEXT,
                        subscribed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        status TEXT DEFAULT 'active',
                        metadata TEXT
                    )
```

## north_star_metric
```sql
CREATE TABLE north_star_metric (
  id TEXT PRIMARY KEY,
  metric_name TEXT NOT NULL,
  description TEXT,
  current_value REAL,
  target_value REAL,
  unit TEXT,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## openai_budgets
```sql
CREATE TABLE openai_budgets (
    id TEXT PRIMARY KEY,
    month_year TEXT NOT NULL, -- '2025-12'
    budget_amount REAL NOT NULL, -- $20.00
    current_spend REAL DEFAULT 0.0,
    alert_threshold REAL DEFAULT 0.8, -- 80%
    alert_email TEXT, -- meauxbility@gmail.com
    reset_date DATE, -- When budget resets
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## openai_model_usage
```sql
CREATE TABLE openai_model_usage (
    id TEXT PRIMARY KEY,
    model TEXT NOT NULL,
    date DATE NOT NULL,
    request_count INTEGER DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    cost_usd REAL DEFAULT 0.0,
    avg_tokens_per_request REAL DEFAULT 0.0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(model, date)
)
```

## openai_spending
```sql
CREATE TABLE openai_spending (
    id TEXT PRIMARY KEY,
    date DATE NOT NULL,
    hour INTEGER, -- 0-23, NULL for daily totals
    model TEXT, -- Model used (gpt-4o, gpt-4o-mini, etc.)
    usage_type TEXT, -- 'completion', 'embedding', 'image', 'audio', etc.
    input_tokens INTEGER DEFAULT 0,
    output_tokens INTEGER DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    cost_usd REAL DEFAULT 0.0,
    request_count INTEGER DEFAULT 0,
    metadata_json TEXT, -- JSON: {project_id, user_id, endpoint, etc.}
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## openai_spending_alerts
```sql
CREATE TABLE openai_spending_alerts (
    id TEXT PRIMARY KEY,
    budget_id TEXT,
    alert_type TEXT, -- 'threshold', 'budget_exceeded', 'daily_limit'
    threshold_percentage REAL, -- 80%
    current_spend REAL,
    budget_amount REAL,
    message TEXT,
    sent_at DATETIME,
    email_sent BOOLEAN DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (budget_id) REFERENCES openai_budgets(id)
)
```

## optimize_jobs
```sql
CREATE TABLE optimize_jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_id INTEGER NOT NULL,
    project_id TEXT NOT NULL,
    zip_id TEXT NOT NULL,
    file_key TEXT NOT NULL,
    mode TEXT NOT NULL,
    cloudconvert_job_id TEXT,
    status TEXT NOT NULL DEFAULT 'requested',
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
)
```

## org_settings
```sql
CREATE TABLE org_settings (
  id            TEXT PRIMARY KEY,
  org_id        TEXT NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  key           TEXT NOT NULL,
  value         TEXT,
  UNIQUE(org_id, key)
)
```

## organizations
```sql
CREATE TABLE organizations (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    domain TEXT,
    logo_url TEXT,
    website TEXT,
    industry TEXT,
    size TEXT,
    plan TEXT DEFAULT 'free',
    status TEXT DEFAULT 'active',
    settings JSON,
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch())
)
```

## payouts
```sql
CREATE TABLE payouts (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    employee_id TEXT,
    volunteer_id TEXT,
    amount REAL NOT NULL,
    currency TEXT DEFAULT 'usd',
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled')),
    payment_method TEXT,
    payment_reference TEXT,
    description TEXT,
    period_start TEXT,
    period_end TEXT,
    hours_worked REAL,
    hourly_rate REAL,
    project_ids TEXT,
    notes TEXT,
    paid_at TEXT,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## pillars
```sql
CREATE TABLE pillars (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## progress
```sql
CREATE TABLE progress (   id TEXT PRIMARY KEY,   userId TEXT NOT NULL,   lessonId TEXT NOT NULL,   courseId TEXT NOT NULL,   completed INTEGER DEFAULT 0,    completedAt TEXT,   timeSpent INTEGER DEFAULT 0,    lastAccessedAt TEXT,   FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,   FOREIGN KEY (lessonId) REFERENCES lessons(id) ON DELETE CASCADE,   FOREIGN KEY (courseId) REFERENCES courses(id) ON DELETE CASCADE,   UNIQUE(userId, lessonId) )
```

## project_activity
```sql
CREATE TABLE project_activity (
          id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
          project_id TEXT,
          team_member_id TEXT,
          action_type TEXT NOT NULL,
          action_description TEXT NOT NULL,
          metadata TEXT,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
```

## project_assignments
```sql
CREATE TABLE project_assignments (
          id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
          project_id TEXT NOT NULL,
          team_member_id TEXT NOT NULL,
          role TEXT DEFAULT 'contributor',
          assigned_at TEXT DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(project_id, team_member_id)
        )
```

## project_cost_summary
```sql
CREATE TABLE project_cost_summary (
    project_id TEXT PRIMARY KEY,
    project_name TEXT NOT NULL,
    total_cost REAL DEFAULT 0,
    openai_cost REAL DEFAULT 0,
    gemini_cost REAL DEFAULT 0,
    cloudflare_cost REAL DEFAULT 0,
    other_cost REAL DEFAULT 0,
    total_time_hours REAL DEFAULT 0,
    total_api_calls INTEGER DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    avg_cost_per_hour REAL,
    cost_efficiency_score REAL, -- Calculated metric
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## project_costs
```sql
CREATE TABLE project_costs (
    project_id TEXT PRIMARY KEY,
    total_time_seconds INTEGER DEFAULT 0,
    total_time_cost REAL DEFAULT 0.0,
    total_ai_tokens INTEGER DEFAULT 0,
    total_ai_cost REAL DEFAULT 0.0,
    total_cost REAL DEFAULT 0.0,
    last_updated INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## project_deadlines
```sql
CREATE TABLE project_deadlines (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    project_id TEXT NOT NULL,
    deadline_date TEXT NOT NULL,
    deadline_type TEXT DEFAULT 'milestone' CHECK (deadline_type IN ('milestone', 'delivery', 'review', 'launch', 'other')),
    title TEXT NOT NULL,
    description TEXT,
    assigned_to TEXT,
    status TEXT DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'in_progress', 'completed', 'overdue', 'cancelled')),
    priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    completed_at TEXT,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## project_members
```sql
CREATE TABLE project_members (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    role TEXT DEFAULT 'member',
    permissions JSON,
    joined_at INTEGER DEFAULT (unixepoch()),
    UNIQUE(project_id, user_id)
)
```

## project_milestones
```sql
CREATE TABLE project_milestones (
          id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
          project_id TEXT NOT NULL,
          name TEXT NOT NULL,
          description TEXT,
          status TEXT DEFAULT 'pending',
          due_date TEXT,
          completed_at TEXT,
          progress_percent INTEGER DEFAULT 0,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
```

## project_progress
```sql
CREATE TABLE project_progress (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    project_name TEXT NOT NULL,
    team_member TEXT,
    status TEXT DEFAULT 'in_progress', -- not_started, in_progress, completed, blocked
    progress_percentage INTEGER DEFAULT 0,
    milestones TEXT, -- JSON array of milestones
    completed_milestones TEXT, -- JSON array of completed milestone IDs
    estimated_hours REAL,
    actual_hours REAL,
    estimated_cost REAL,
    actual_cost REAL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## project_registry
```sql
CREATE TABLE project_registry (
    id TEXT PRIMARY KEY,
    worker_name TEXT NOT NULL UNIQUE,
    worker_url TEXT NOT NULL,
    client_name TEXT NOT NULL,
    client_type TEXT CHECK (client_type IN ('internal', 'external')),
    project_type TEXT,
    description TEXT,
    bindings TEXT,
    routes TEXT,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'paused', 'archived')),
    monthly_budget REAL,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## project_stats
```sql
CREATE TABLE project_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    project_id TEXT NOT NULL UNIQUE,
    project_name TEXT NOT NULL,
    url TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'deployed',
    type TEXT NOT NULL DEFAULT 'Pages',
    category TEXT,
    last_deployed_at TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## project_tasks
```sql
CREATE TABLE project_tasks (
          id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
          project_id TEXT NOT NULL,
          milestone_id TEXT,
          assigned_to TEXT,
          title TEXT NOT NULL,
          description TEXT,
          status TEXT DEFAULT 'todo',
          priority TEXT DEFAULT 'medium',
          estimated_hours REAL,
          actual_hours REAL,
          due_date TEXT,
          completed_at TEXT,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
```

## project_team
```sql
CREATE TABLE project_team (
  project_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  role TEXT DEFAULT 'member' CHECK(role IN ('owner', 'admin', 'member', 'viewer')),
  PRIMARY KEY (project_id, user_id),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
)
```

## project_todos
```sql
CREATE TABLE project_todos (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    content TEXT NOT NULL,
    completed INTEGER DEFAULT 0,
    priority TEXT DEFAULT 'medium',
    assignee_id TEXT,
    due_date INTEGER,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (project_id) REFERENCES project_registry(id)
)
```

## projects
```sql
CREATE TABLE projects (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL,
    team_id TEXT,
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'active',
    priority TEXT DEFAULT 'medium',
    color TEXT,
    icon TEXT,
    cover_image_url TEXT,
    start_date INTEGER,
    due_date INTEGER,
    completed_at INTEGER,
    settings JSON,
    created_by TEXT,
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch()),
    UNIQUE(organization_id, slug)
)
```

## prompt_templates
```sql
CREATE TABLE prompt_templates (id INTEGER PRIMARY KEY AUTOINCREMENT, slug TEXT UNIQUE NOT NULL, title TEXT NOT NULL, description TEXT NOT NULL, tags TEXT NOT NULL, meta TEXT NOT NULL, body TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')), updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')))
```

## public_dev_users
```sql
CREATE TABLE public_dev_users (
  user_id TEXT,
  external_id TEXT PRIMARY KEY,
  email TEXT,
  role TEXT,
  joined_at TEXT
)
```

## quick_stats
```sql
CREATE TABLE quick_stats (
    stat_key TEXT PRIMARY KEY,
    stat_value TEXT NOT NULL,
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## r2_buckets
```sql
CREATE TABLE r2_buckets (
    id TEXT PRIMARY KEY,
    organization_id TEXT,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    category TEXT, -- core, employee, client, iam, meauxbility, work_stack, development
    location TEXT, -- e.g., 'Western North America (WNAM)'
    public_url TEXT,
    s3_endpoint TEXT,
    catalog_uri TEXT,
    warehouse_name TEXT,
    total_size INTEGER DEFAULT 0, -- bytes
    object_count INTEGER DEFAULT 0,
    is_public INTEGER DEFAULT 0,
    custom_domain TEXT,
    status TEXT DEFAULT 'active', -- active, archived, deleted
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch()), binding TEXT, creation_date TEXT, _category_check TEXT
  CHECK (category IN ('core','employee','client','iam','meauxbility','work_stack','development')), _status_check TEXT
  CHECK (status IN ('active','pending','archived','deleted')), cf_bucket_uid TEXT, source_of_truth TEXT DEFAULT 'manual',
    FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE
)
```

## r2_objects
```sql
CREATE TABLE r2_objects (
    id TEXT PRIMARY KEY,
    bucket_id TEXT NOT NULL,
    key TEXT NOT NULL,
    size INTEGER,
    mime_type TEXT,
    etag TEXT,
    uploaded_at INTEGER,
    last_modified INTEGER,
    metadata JSON,
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch()),
    FOREIGN KEY (bucket_id) REFERENCES r2_buckets(id) ON DELETE CASCADE,
    UNIQUE(bucket_id, key)
)
```

## rag_queries
```sql
CREATE TABLE rag_queries (
  id TEXT PRIMARY KEY,
  query TEXT NOT NULL,
  query_embedding_json TEXT,
  response TEXT,
  sources TEXT,
  model_used TEXT,
  latency_ms INTEGER,
  cache_hit BOOLEAN DEFAULT 0,
  created_at INTEGER DEFAULT (unixepoch())
)
```

## rag_query_history
```sql
CREATE TABLE rag_query_history (
    id TEXT PRIMARY KEY,
    query_text TEXT NOT NULL,
    retrieved_docs TEXT, -- JSON array of document IDs
    generated_response TEXT,
    user_id TEXT,
    context_type TEXT, -- 'grant_writing', 'proposal_review', 'opportunity_research'
    success_rating INTEGER, -- 1-5 user rating
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## resource_access_log
```sql
CREATE TABLE resource_access_log (id TEXT PRIMARY KEY, user_id TEXT NOT NULL, token_id TEXT, resource_type TEXT NOT NULL, resource_name TEXT, action TEXT NOT NULL, status TEXT DEFAULT 'success', metadata TEXT, ip_address TEXT, user_agent TEXT, timestamp INTEGER DEFAULT (strftime('%s', 'now')))
```

## scene_configs
```sql
CREATE TABLE scene_configs (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT NOT NULL UNIQUE,
                        scene_type TEXT NOT NULL,
                        config_json TEXT NOT NULL,
                        description TEXT,
                        is_active INTEGER DEFAULT 0,
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
                    )
```

## scheduled_streams
```sql
CREATE TABLE scheduled_streams (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
    stream_id TEXT,
    title TEXT NOT NULL,
    description TEXT,
    scheduled_time TEXT NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    organizer_id TEXT NOT NULL,
    attendees TEXT,
    stream_url TEXT,
    rtmp_url TEXT,
    stream_key TEXT,
    status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'live', 'completed', 'cancelled')),
    recording_url TEXT,
    meeting_notes_id TEXT,
    email_sent BOOLEAN DEFAULT 0,
    email_sent_at TEXT,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## secret_access_log
```sql
CREATE TABLE secret_access_log (
    id TEXT PRIMARY KEY,
    secret_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    action TEXT NOT NULL, -- 'view', 'update', 'delete', 'use'
    ip_address TEXT,
    user_agent TEXT,
    timestamp INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (secret_id) REFERENCES user_secrets(id),
    FOREIGN KEY (user_id) REFERENCES team_members(id)
)
```

## secret_fingerprints
```sql
CREATE TABLE secret_fingerprints (
  id TEXT PRIMARY KEY,
  service TEXT NOT NULL,
  fingerprint TEXT NOT NULL,
  env_var_names TEXT NOT NULL DEFAULT '[]',
  notes TEXT,
  created_at INTEGER NOT NULL DEFAULT (unixepoch()),
  updated_at INTEGER NOT NULL DEFAULT (unixepoch())
)
```

## secure_vault
```sql
CREATE TABLE secure_vault (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT, -- api_key, password, token, etc.
    encrypted_value TEXT NOT NULL,
    owner_id TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## security_events
```sql
CREATE TABLE security_events (
    id TEXT PRIMARY KEY,
    event_type TEXT NOT NULL CHECK (event_type IN (
        'access_denied',
        'suspicious_access',
        'failed_auth',
        'unusual_activity',
        'deploy_attempt',
        'secret_access',
        'r2_access',
        'vault_access'
    )),
    severity TEXT NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    user_id TEXT,
    ip_address TEXT,
    user_agent TEXT,
    resource TEXT,
    action TEXT,
    details TEXT, -- JSON string
    timestamp INTEGER NOT NULL,
    created_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## seo_metadata
```sql
CREATE TABLE seo_metadata (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  page_path TEXT NOT NULL,
  title TEXT,
  description TEXT,
  keywords TEXT,
  og_title TEXT,
  og_description TEXT,
  og_image TEXT,
  twitter_card TEXT,
  canonical_url TEXT,
  version TEXT,
  updated_at TEXT DEFAULT (datetime('now'))
)
```

## sessions
```sql
CREATE TABLE sessions (
  id TEXT PRIMARY KEY, -- Session token
  user_id INTEGER NOT NULL,
  expires_at TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
)
```

## settings
```sql
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  description TEXT,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## storage_usage
```sql
CREATE TABLE storage_usage (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    project_id TEXT NOT NULL,
    storage_type TEXT NOT NULL,
    bucket_name TEXT,
    total_size_bytes INTEGER NOT NULL DEFAULT 0,
    file_count INTEGER NOT NULL DEFAULT 0,
    object_count INTEGER NOT NULL DEFAULT 0,
    builds_size_bytes INTEGER DEFAULT 0,
    assets_size_bytes INTEGER DEFAULT 0,
    backups_size_bytes INTEGER DEFAULT 0,
    other_size_bytes INTEGER DEFAULT 0,
    limit_bytes INTEGER,
    limit_reached BOOLEAN DEFAULT 0,
    cost_usd REAL DEFAULT 0,
    measured_at TEXT DEFAULT CURRENT_TIMESTAMP,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## stripe_donations
```sql
CREATE TABLE stripe_donations (
    id TEXT PRIMARY KEY,
    stripe_payment_intent_id TEXT UNIQUE,
    amount REAL NOT NULL,
    currency TEXT DEFAULT 'usd',
    donor_name TEXT,
    donor_email TEXT,
    campaign TEXT, -- Campaign or grant fund
    status TEXT DEFAULT 'pending', -- 'pending', 'succeeded', 'failed', 'refunded'
    grant_application_id TEXT, -- Link to grant if applicable
    metadata TEXT, -- JSON metadata
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (grant_application_id) REFERENCES grant_applications(id)
)
```

## submission_analytics
```sql
CREATE TABLE submission_analytics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  request_id INTEGER,
  form_type TEXT DEFAULT 'tnr-request',
  submission_status TEXT DEFAULT 'success',
  submission_error TEXT,
  admin_email_sent INTEGER DEFAULT 0,
  admin_email_id TEXT,
  admin_email_error TEXT,
  user_email_sent INTEGER DEFAULT 0,
  user_email_id TEXT,
  user_email_error TEXT,
  admin_responded INTEGER DEFAULT 0,
  admin_response_method TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (request_id) REFERENCES tnr_requests(id)
)
```

## successful_proposals
```sql
CREATE TABLE successful_proposals (
    id TEXT PRIMARY KEY,
    grant_opportunity_id TEXT,
    proposal_text TEXT NOT NULL,
    sections_json TEXT, -- JSON: {executive_summary, need_statement, methodology, budget, etc.}
    amount_awarded REAL,
    success_factors TEXT, -- AI-analyzed reasons for success
    embedding_json TEXT, -- Full proposal embedding for RAG
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (grant_opportunity_id) REFERENCES grant_opportunities(id)
)
```

## sync_jobs
```sql
CREATE TABLE sync_jobs (
    id TEXT PRIMARY KEY,
    workstation_id TEXT NOT NULL,
    project_id TEXT NOT NULL,
    sync_type TEXT NOT NULL,
    status TEXT NOT NULL,
    source_path TEXT NOT NULL,
    destination_path TEXT NOT NULL,
    destination_bucket TEXT,
    total_files INTEGER DEFAULT 0,
    files_processed INTEGER DEFAULT 0,
    bytes_total INTEGER DEFAULT 0,
    bytes_processed INTEGER DEFAULT 0,
    progress_percent REAL DEFAULT 0,
    files_synced INTEGER DEFAULT 0,
    files_skipped INTEGER DEFAULT 0,
    files_failed INTEGER DEFAULT 0,
    error_message TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    started_at TEXT,
    completed_at TEXT
)
```

## task_comments
```sql
CREATE TABLE task_comments (
    id TEXT PRIMARY KEY,
    task_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (task_id) REFERENCES kanban_tasks(id),
    FOREIGN KEY (user_id) REFERENCES team_members(id)
)
```

## task_todos
```sql
CREATE TABLE task_todos (
    id TEXT PRIMARY KEY,
    task_id TEXT NOT NULL,
    content TEXT NOT NULL,
    completed INTEGER DEFAULT 0,
    position INTEGER NOT NULL,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    FOREIGN KEY (task_id) REFERENCES kanban_tasks(id)
)
```

## tasks
```sql
CREATE TABLE tasks (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    parent_task_id TEXT,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'todo',
    priority TEXT DEFAULT 'medium',
    assignee_id TEXT,
    reporter_id TEXT,
    due_date INTEGER,
    completed_at INTEGER,
    estimated_hours REAL,
    actual_hours REAL,
    tags TEXT,
    position INTEGER DEFAULT 0,
    metadata JSON,
    created_by TEXT,
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch())
)
```

## team_members
```sql
CREATE TABLE team_members (
    id TEXT PRIMARY KEY,
    team_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    role TEXT DEFAULT 'member',
    permissions JSON,
    joined_at INTEGER DEFAULT (unixepoch()),
    UNIQUE(team_id, user_id)
)
```

## team_tokens
```sql
CREATE TABLE team_tokens (id TEXT PRIMARY KEY, user_id TEXT NOT NULL, token_hash TEXT NOT NULL, token_prefix TEXT NOT NULL, name TEXT NOT NULL, permissions TEXT NOT NULL, scopes TEXT, expires_at INTEGER, last_used_at INTEGER, created_at INTEGER DEFAULT (strftime('%s', 'now')))
```

## team_workflows
```sql
CREATE TABLE team_workflows (
    id TEXT PRIMARY KEY,
    workflow_name TEXT NOT NULL,
    team_member TEXT NOT NULL, -- 'sam', 'connor', 'fred', 'amber'
    workflow_type TEXT, -- 'development', 'design', 'grant_writing', 'general'
    description TEXT,
    steps_json TEXT,
    estimated_time INTEGER,
    success_rate REAL,
    quality_score INTEGER,
    last_used DATETIME,
    use_count INTEGER DEFAULT 0,
    prevents_redundancy BOOLEAN DEFAULT 1, -- Does this prevent redundant work?
    embedding_json TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## teams
```sql
CREATE TABLE teams (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL,
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,
    avatar_url TEXT,
    color TEXT,
    is_private INTEGER DEFAULT 0,
    settings JSON,
    created_by TEXT,
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch()),
    UNIQUE(organization_id, slug)
)
```

## tenants
```sql
CREATE TABLE tenants (   id TEXT PRIMARY KEY,   name TEXT NOT NULL,   slug TEXT UNIQUE NOT NULL,   domain TEXT,   settings TEXT,    createdAt TEXT NOT NULL,   updatedAt TEXT NOT NULL )
```

## theme_configs
```sql
CREATE TABLE theme_configs (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT NOT NULL UNIQUE,
                        theme_type TEXT NOT NULL,
                        config_json TEXT NOT NULL,
                        description TEXT,
                        is_active INTEGER DEFAULT 0,
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
                    )
```

## time_entries
```sql
CREATE TABLE time_entries (
    id TEXT PRIMARY KEY,
    started_at INTEGER NOT NULL,
    ended_at INTEGER,
    seconds INTEGER,
    cost_usd REAL,
    note TEXT
)
```

## time_logs
```sql
CREATE TABLE time_logs (
          id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
          team_member_id TEXT NOT NULL,
          project_id TEXT,
          task_description TEXT NOT NULL,
          start_time TEXT NOT NULL,
          end_time TEXT,
          duration_minutes INTEGER,
          billable BOOLEAN DEFAULT 0,
          category TEXT,
          notes TEXT,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
```

## time_sessions
```sql
CREATE TABLE time_sessions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    project_id TEXT,
    started_at INTEGER NOT NULL,
    ended_at INTEGER,
    duration_seconds INTEGER,
    auto_clocked INTEGER DEFAULT 1,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES team_members(id)
)
```

## tnr_requests
```sql
CREATE TABLE tnr_requests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  requester_name TEXT NOT NULL,
  requester_email TEXT NOT NULL,
  requester_phone TEXT NOT NULL,
  street_address TEXT,
  city TEXT DEFAULT 'Acadia Parish',
  state TEXT DEFAULT 'LA',
  zip_code TEXT,
  estimated_cat_count INTEGER DEFAULT 1,
  colony_location_description TEXT,
  feeding_schedule TEXT,
  cats_friendly INTEGER DEFAULT 0,
  cats_have_shelter INTEGER DEFAULT 0,
  previous_tnr INTEGER DEFAULT 0,
  special_circumstances TEXT,
  preferred_contact_method TEXT DEFAULT 'email',
  preferred_appointment_time TEXT,
  status TEXT DEFAULT 'pending',
  assigned_to TEXT,
  notes TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## token_usage
```sql
CREATE TABLE token_usage (
    id TEXT PRIMARY KEY,
    project_id TEXT,
    session_id TEXT,
    user_id TEXT,
    agent_type TEXT,
    model TEXT NOT NULL,
    provider TEXT NOT NULL,
    prompt_tokens INTEGER DEFAULT 0,
    completion_tokens INTEGER DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    estimated_cost REAL DEFAULT 0.0,
    request_type TEXT,
    timestamp INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## user_preferences
```sql
CREATE TABLE user_preferences (
  userId TEXT PRIMARY KEY,
  theme TEXT DEFAULT 'light', -- 'light', 'dark', 'auto'
  notifications INTEGER DEFAULT 1,
  emailNotifications INTEGER DEFAULT 1,
  preferences TEXT, -- JSON for additional preferences
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
)
```

## user_profiles
```sql
CREATE TABLE user_profiles (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE,
    full_name TEXT,
    consent_tracking INTEGER DEFAULT 0,
    consent_cookies INTEGER DEFAULT 0,
    master_key_hash TEXT,
    created_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## user_secrets
```sql
CREATE TABLE user_secrets (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    secret_name TEXT NOT NULL, -- Friendly name (e.g., "OpenAI API Key", "GitHub Token")
    secret_type TEXT NOT NULL, -- 'api_key', 'password', 'token', 'oauth', 'other'
    encrypted_value TEXT NOT NULL, -- Encrypted secret value
    service_name TEXT, -- Service this secret is for (e.g., 'openai', 'github', 'stripe')
    metadata TEXT, -- JSON with additional info (expires_at, permissions, etc.)
    is_active INTEGER DEFAULT 1,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now')),
    last_used_at INTEGER,
    FOREIGN KEY (user_id) REFERENCES team_members(id),
    UNIQUE(user_id, secret_name)
)
```

## user_sessions
```sql
CREATE TABLE user_sessions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    token TEXT UNIQUE NOT NULL,
    ip_address TEXT,
    user_agent TEXT,
    expires_at INTEGER NOT NULL,
    created_at INTEGER DEFAULT (unixepoch())
)
```

## user_time_tracking
```sql
CREATE TABLE user_time_tracking (
    id TEXT PRIMARY KEY,
    team_member TEXT NOT NULL,
    project_id TEXT,
    project_name TEXT,
    task_description TEXT,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    duration_minutes INTEGER,
    status TEXT DEFAULT 'active', -- active, completed, paused
    category TEXT, -- development, design, grant-writing, research, etc.
    tags TEXT, -- JSON array of tags
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## users
```sql
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    organization_id TEXT,
    email TEXT NOT NULL UNIQUE,
    username TEXT UNIQUE,
    password_hash TEXT,
    name TEXT NOT NULL,
    first_name TEXT,
    last_name TEXT,
    avatar_url TEXT,
    phone TEXT,
    role TEXT DEFAULT 'member',
    department TEXT,
    title TEXT,
    bio TEXT,
    timezone TEXT DEFAULT 'UTC',
    locale TEXT DEFAULT 'en-US',
    status TEXT DEFAULT 'active',
    email_verified INTEGER DEFAULT 0,
    last_login_at INTEGER,
    github_id TEXT,
    github_username TEXT,
    google_id TEXT,
    slack_id TEXT,
    metadata JSON,
    created_at INTEGER DEFAULT (unixepoch()),
    updated_at INTEGER DEFAULT (unixepoch())
, company_email TEXT, inneranimal_email TEXT, iautodidact_app_email TEXT, iautodidact_org_email TEXT, innerautodidact_email TEXT, meauxxx_email TEXT)
```

## visions
```sql
CREATE TABLE visions (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  success_criteria TEXT,
  target_date TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## wallet_transactions
```sql
CREATE TABLE wallet_transactions (
    id TEXT PRIMARY KEY,
    type TEXT NOT NULL, -- income, expense
    amount REAL NOT NULL,
    description TEXT,
    category TEXT,
    date TEXT DEFAULT CURRENT_TIMESTAMP,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## weekly_spend_reports
```sql
CREATE TABLE weekly_spend_reports (
    id TEXT PRIMARY KEY,
    week_start TEXT NOT NULL,
    week_end TEXT NOT NULL,
    total_cost REAL NOT NULL,
    breakdown TEXT NOT NULL,
    optimization_tips TEXT,
    sent_at INTEGER,
    created_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## work_sessions
```sql
CREATE TABLE work_sessions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    project_id TEXT, -- Links to projects table
    worker_name TEXT, -- Cloudflare Worker name
    time_minutes INTEGER NOT NULL DEFAULT 0,
    spend REAL DEFAULT 0, -- Cost/spend in dollars
    notes TEXT,
    created_at INTEGER DEFAULT (strftime('%s', 'now')),
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))
)
```

## worker_logs
```sql
CREATE TABLE worker_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  worker_name TEXT NOT NULL,
  level TEXT NOT NULL CHECK (level IN ('info', 'warning', 'error', 'debug')),
  message TEXT NOT NULL,
  data TEXT, -- JSON object as text
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## worker_stats
```sql
CREATE TABLE worker_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    worker_id TEXT NOT NULL UNIQUE,
    worker_name TEXT NOT NULL,
    url TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'active',
    category TEXT,
    total_requests INTEGER DEFAULT 0,
    last_request_at TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## workflow_analytics
```sql
CREATE TABLE workflow_analytics (
    id TEXT PRIMARY KEY,
    project_id TEXT,
    task_type TEXT, -- code-generation, grant-writing, research, etc.
    prompt_template TEXT, -- Template or pattern used
    prompt_variant TEXT, -- Variant identifier
    total_uses INTEGER DEFAULT 0,
    total_cost REAL DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    avg_cost_per_use REAL,
    avg_tokens_per_use REAL,
    success_rate REAL, -- 0-1
    avg_quality_score REAL, -- 0-1
    best_result_id TEXT, -- ID of best result
    worst_result_id TEXT, -- ID of worst result
    improvement_suggestions TEXT, -- JSON array
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## workflow_optimizations
```sql
CREATE TABLE workflow_optimizations (
    id TEXT PRIMARY KEY,
    workflow_id TEXT,
    workflow_type TEXT,
    original_workflow TEXT, -- Original workflow description
    optimized_workflow TEXT, -- AI-optimized version
    improvements_json TEXT, -- JSON: {time_saved, quality_improvement, steps_removed, etc.}
    quality_score_before INTEGER,
    quality_score_after INTEGER,
    optimized_by TEXT, -- 'rag_system', 'sam', 'connor', etc.
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## workstations
```sql
CREATE TABLE workstations (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    hostname TEXT,
    platform TEXT NOT NULL,
    location TEXT,
    last_synced_at TEXT,
    sync_enabled BOOLEAN DEFAULT 1,
    sync_frequency TEXT DEFAULT 'hourly',
    projects_tracked TEXT,
    local_storage_path TEXT,
    local_storage_size_bytes INTEGER DEFAULT 0,
    description TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
)
```

