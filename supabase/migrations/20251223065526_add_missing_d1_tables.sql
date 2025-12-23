-- Supabase Migration: D1 Tables Not Yet in Supabase
-- Generated: 2025-12-23T06:55:26.944Z
-- Tables to add: 173
-- Note: Foreign keys removed to prevent dependency issues

-- Table: activity_logs
CREATE TABLE activity_logs (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    action TEXT NOT NULL,
    resource_type TEXT,
    resource_id TEXT,
    metadata TEXT,
    timestamp INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: adoption_history
CREATE TABLE adoption_history (
  id SERIAL PRIMARY KEY,
  animal_id INTEGER NOT NULL,
  adopter_name TEXT,
  adopter_email TEXT,
  adopter_phone TEXT,
  adoption_date TIMESTAMPTZ,
  adoption_status TEXT DEFAULT 'pending', 
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: agent_commands
CREATE TABLE agent_commands (
  id TEXT PRIMARY KEY,
  command TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  template TEXT NOT NULL,
  category TEXT NOT NULL,
  variables TEXT,
  examples TEXT,
  created_at TEXT DEFAULT NOW(),
  updated_at TEXT DEFAULT NOW(),
  created_by TEXT DEFAULT 'system'
);

-- Table: agent_configs
CREATE TABLE agent_configs (
  id TEXT PRIMARY KEY,
  agent_name TEXT NOT NULL,
  agent_type TEXT NOT NULL,
  service_provider TEXT NOT NULL,
  api_keys_json TEXT,
  endpoints_json TEXT,
  config_json TEXT,
  status TEXT DEFAULT 'active',
  created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
  updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: agent_telemetry
CREATE TABLE agent_telemetry (
    id TEXT PRIMARY KEY,
    message_id TEXT,
    event_type TEXT,
    rating INTEGER,
    feedback TEXT,
    correction TEXT,
    data TEXT,
    timestamp INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: ai_chunks
CREATE TABLE ai_chunks (
  id TEXT PRIMARY KEY,
  document_id TEXT NOT NULL,
  chunk_index INTEGER NOT NULL,
  text TEXT NOT NULL,
  token_count INTEGER,
  vector_id TEXT UNIQUE,
  embedding_json TEXT,
  created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: ai_conversations
CREATE TABLE ai_conversations (
  id TEXT PRIMARY KEY,
  user_id TEXT DEFAULT 'default',
  title TEXT,
  created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
  updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: ai_messages
CREATE TABLE ai_messages (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  role TEXT NOT NULL CHECK(role IN ('user', 'assistant', 'system')),
  content TEXT NOT NULL,
  sources TEXT,
  model_used TEXT,
  latency_ms INTEGER,
  created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: ai_responses
CREATE TABLE ai_responses (id TEXT PRIMARY KEY, prompt TEXT NOT NULL, response TEXT NOT NULL, model TEXT NOT NULL, gateway TEXT NOT NULL, timestamp TEXT NOT NULL, created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT));

-- Table: analytics
CREATE TABLE analytics (
    id SERIAL PRIMARY KEY,
    event_type TEXT NOT NULL,
    resource_type TEXT NOT NULL,
    resource_id TEXT NOT NULL,
    event_data TEXT,
    created_at TEXT DEFAULT NOW()
);

-- Table: animal_photos
CREATE TABLE animal_photos (
  id SERIAL PRIMARY KEY,
  animal_id INTEGER NOT NULL,
  photo_url TEXT NOT NULL,
  cloudflare_image_id TEXT,
  is_primary INTEGER DEFAULT 0,
  display_order INTEGER DEFAULT 0,
  alt_text TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: animals
CREATE TABLE animals (
  id SERIAL PRIMARY KEY,
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
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  added_by TEXT,
  notes TEXT
);

-- Table: api_credentials
CREATE TABLE api_credentials (
  id TEXT PRIMARY KEY,
  service_name TEXT NOT NULL,
  credential_type TEXT NOT NULL,
  key_name TEXT NOT NULL,
  key_value_hash TEXT,
  environment TEXT DEFAULT 'production',
  is_active INTEGER DEFAULT 1,
  created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
  updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: api_integrations
CREATE TABLE api_integrations (
  id TEXT PRIMARY KEY,
  service_name TEXT NOT NULL UNIQUE, -- 'google', 'openai', 'github', 'cloudconvert'
  api_key_encrypted TEXT, -- Encrypted API key
  config_json TEXT, -- JSONB config for the service
  enabled BOOLEAN DEFAULT TRUE,
  last_used INTEGER,
  created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
  updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: api_requests
CREATE TABLE api_requests (
  id SERIAL PRIMARY KEY,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER,
  response_time INTEGER, -- milliseconds
  ip_address TEXT,
  user_agent TEXT,
  created_at TEXT DEFAULT NOW()
);

-- Table: api_usage
CREATE TABLE api_usage (
    id TEXT PRIMARY KEY,
    service TEXT NOT NULL,
    metric TEXT NOT NULL,
    value DOUBLE PRECISION NOT NULL,
    cost_usd DOUBLE PRECISION DEFAULT 0,
    recorded_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: app_deployments
CREATE TABLE app_deployments (
    id SERIAL PRIMARY KEY,
    deployment_id TEXT NOT NULL UNIQUE,
    app_name TEXT NOT NULL,
    app_type TEXT,
    path TEXT NOT NULL,
    status TEXT DEFAULT 'deployed',
    created_at TEXT DEFAULT NOW()
);

-- Table: app_refinements
CREATE TABLE app_refinements (
    id SERIAL PRIMARY KEY,
    refinement_id TEXT NOT NULL UNIQUE,
    app_name TEXT NOT NULL,
    refinements TEXT NOT NULL,
    created_at TEXT DEFAULT NOW()
);

-- Table: apps
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
  screenshots TEXT, -- JSONB array of screenshot URLs
  video_url TEXT,
  
  -- Metrics
  downloads INTEGER DEFAULT 0,
  rating DOUBLE PRECISION DEFAULT 0,
  review_count INTEGER DEFAULT 0,
  
  -- Access
  is_public BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  install_url TEXT NOT NULL,
  documentation_url TEXT,
  
  -- Timestamps
  created_at TEXT DEFAULT NOW(),
  updated_at TEXT DEFAULT NOW()
, status TEXT, tags TEXT, icon_key TEXT, preview_url TEXT, repo_url TEXT, dashboard_url TEXT, last_update TEXT);

-- Table: asset_metadata
CREATE TABLE asset_metadata (
              key TEXT PRIMARY KEY,
              user_id TEXT,
              tags TEXT,
              favorite INTEGER DEFAULT 0,
              source TEXT,
              display_name TEXT,
              created_at TEXT DEFAULT NOW()
            );

-- Table: assets
CREATE TABLE assets (
  id SERIAL PRIMARY KEY,
  key TEXT NOT NULL UNIQUE,
  bucket TEXT NOT NULL,
  size INTEGER,
  content_type TEXT,
  metadata TEXT,
  uploaded_at TEXT DEFAULT NOW(),
  last_accessed_at TEXT
);

-- Table: backup_jobs
CREATE TABLE backup_jobs (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    backup_type TEXT NOT NULL,
    status TEXT NOT NULL,
    source_type TEXT NOT NULL,
    source_path TEXT,
    destination_bucket TEXT NOT NULL,
    destination_path TEXT,
    include_node_modules BOOLEAN DEFAULT FALSE,
    include_env_files BOOLEAN DEFAULT FALSE,
    compress BOOLEAN DEFAULT TRUE,
    encryption_enabled BOOLEAN DEFAULT FALSE,
    total_files INTEGER DEFAULT 0,
    files_processed INTEGER DEFAULT 0,
    bytes_total INTEGER DEFAULT 0,
    bytes_processed INTEGER DEFAULT 0,
    progress_percent DOUBLE PRECISION DEFAULT 0,
    backup_size_bytes INTEGER,
    backup_path TEXT,
    backup_checksum TEXT,
    error_message TEXT,
    created_at TEXT DEFAULT NOW(),
    started_at TEXT,
    completed_at TEXT,
    scheduled_for TEXT
);

-- Table: billing_projects
CREATE TABLE billing_projects (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    client TEXT,
    type TEXT DEFAULT 'webapp',
    status TEXT DEFAULT 'active',
    metadata TEXT,
    hourly_rate DOUBLE PRECISION DEFAULT 0.0,
    budget DOUBLE PRECISION DEFAULT 0.0,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: board_tasks
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
        );

-- Table: build_assets
CREATE TABLE build_assets (
  id SERIAL PRIMARY KEY,
  session_id TEXT NOT NULL,
  asset_type TEXT NOT NULL, 
  file_name TEXT NOT NULL,
  file_path TEXT,
  file_size_bytes INTEGER,
  content_hash TEXT,
  r2_backup_path TEXT,
  created_at TEXT DEFAULT (NOW())
);

-- Table: build_changes
CREATE TABLE build_changes (
  id SERIAL PRIMARY KEY,
  session_id TEXT NOT NULL,
  change_type TEXT NOT NULL, 
  component TEXT NOT NULL, 
  description TEXT,
  file_path TEXT,
  line_count INTEGER,
  created_at TEXT DEFAULT (NOW())
);

-- Table: build_locks
CREATE TABLE build_locks (
  id TEXT PRIMARY KEY,
  project TEXT NOT NULL,
  domain TEXT NOT NULL,
  locked_by TEXT NOT NULL,
  locked_at INTEGER NOT NULL,
  expires_at INTEGER NOT NULL,
  created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
  UNIQUE(project, domain)
);

-- Table: build_sessions
CREATE TABLE build_sessions (
  id SERIAL PRIMARY KEY,
  session_id TEXT UNIQUE NOT NULL,
  started_at TEXT NOT NULL,
  ended_at TEXT,
  worker_name TEXT,
  version TEXT,
  build_type TEXT, 
  status TEXT DEFAULT 'in_progress', 
  created_by TEXT DEFAULT 'Claude AI',
  notes TEXT
);

-- Table: calendar_events
CREATE TABLE calendar_events (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    start_time TEXT NOT NULL,
    end_time TEXT,
    location TEXT,
    attendees TEXT, -- JSONB array
    created_by TEXT,
    created_at TEXT DEFAULT NOW(),
    updated_at TEXT DEFAULT NOW()
);

-- Table: captains_log
CREATE TABLE captains_log (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    mission_title TEXT NOT NULL,
    entry_content TEXT NOT NULL,
    status TEXT DEFAULT 'active',
    tags TEXT,
    timestamp INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: certificates
CREATE TABLE certificates (   id TEXT PRIMARY KEY,   userId TEXT NOT NULL,   courseId TEXT NOT NULL,   enrollmentId TEXT NOT NULL,   issuedAt TEXT NOT NULL,   certificateUrl TEXT,   verificationCode TEXT UNIQUE );

-- Table: channels
CREATE TABLE channels (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    created_at TEXT DEFAULT NOW()
);

-- Table: chat_conversations
CREATE TABLE chat_conversations (
                        id SERIAL PRIMARY KEY,
                        conversation_id TEXT NOT NULL,
                        user_message TEXT NOT NULL,
                        assistant_response TEXT NOT NULL,
                        images TEXT,
                        metadata TEXT,
                        created_at TEXT DEFAULT NOW(),
                        updated_at TEXT DEFAULT NOW()
                    );

-- Table: chat_messages
CREATE TABLE chat_messages (
    id TEXT PRIMARY KEY,
    session_id TEXT,
    role TEXT NOT NULL,
    content TEXT NOT NULL,
    timestamp INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: code_knowledge_base
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
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: command_executions
CREATE TABLE command_executions (
  id TEXT PRIMARY KEY,
  command TEXT NOT NULL,
  user_id TEXT NOT NULL,
  user_email TEXT NOT NULL,
  user_name TEXT,
  channel TEXT,
  status TEXT NOT NULL, -- 'success', 'error', 'blocked'
  message TEXT,
  data TEXT, -- JSONB string for additional data
  executed_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT) NULL
);

-- Table: contacts
CREATE TABLE contacts (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  company TEXT,
  message TEXT NOT NULL,
  created_at TEXT DEFAULT NOW(),
  status TEXT DEFAULT 'new' CHECK (status IN ('new', 'read', 'replied', 'archived')),
  notes TEXT
);

-- Table: content_library
CREATE TABLE content_library (
    id TEXT PRIMARY KEY,
    bucket_name TEXT NOT NULL,
    object_key TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size INTEGER,
    content_type TEXT,
    uploaded_at TEXT,
    tags TEXT, -- JSONB array
    description TEXT,
    created_at TEXT DEFAULT NOW()
);

-- Table: content_metadata
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
);

-- Table: conversation_history
CREATE TABLE conversation_history (
  id TEXT PRIMARY KEY DEFAULT (gen_random_uuid()::text),
  source TEXT NOT NULL, -- 'claude', 'chatgpt', 'other'
  external_id TEXT, -- ID from external service
  title TEXT NOT NULL,
  preview TEXT, -- First message or summary
  message_count INTEGER DEFAULT 0,
  created_at TEXT DEFAULT NOW(),
  updated_at TEXT DEFAULT NOW(),
  metadata TEXT, -- JSONB string for additional data
  UNIQUE(external_id, source)
);

-- Table: conversation_messages
CREATE TABLE conversation_messages (
  id TEXT PRIMARY KEY DEFAULT (gen_random_uuid()::text),
  conversation_id TEXT NOT NULL,
  role TEXT NOT NULL, -- 'user', 'assistant', 'system'
  content TEXT NOT NULL,
  model TEXT, -- Model used (e.g., 'gpt-4', 'claude-3-opus')
  tokens INTEGER,
  created_at TEXT DEFAULT NOW(),
  metadata TEXT -- JSONB string for additional data
);

-- Table: cost_attribution
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
    cost_usd DOUBLE PRECISION,
    success BOOLEAN DEFAULT true,
    result_quality_score DOUBLE PRECISION, -- 0-1 score of result quality
    workflow_improvement_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: courses
CREATE TABLE courses (   id TEXT PRIMARY KEY,   tenantId TEXT NOT NULL,   title TEXT NOT NULL,   slug TEXT NOT NULL,   description TEXT,   shortDescription TEXT,   category TEXT,    level TEXT DEFAULT 'beginner',    duration TEXT,    thumbnailUrl TEXT,   iconUrl TEXT,   status TEXT DEFAULT 'draft',    featured INTEGER DEFAULT 0,    orderIndex INTEGER DEFAULT 0,   createdAt TEXT NOT NULL,   updatedAt TEXT NOT NULL,   UNIQUE(tenantId, slug) );

-- Table: cross_device_sync
CREATE TABLE cross_device_sync (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    sync_key TEXT NOT NULL, -- 'dashboard_state', 'current_project', etc.
    sync_data TEXT NOT NULL, -- JSONB data
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_by_device TEXT -- device_id that made the update
);

-- Table: custom_agents
CREATE TABLE custom_agents (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    name TEXT NOT NULL,
    persona TEXT,
    training_data TEXT,
    project_context TEXT,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: dashboard_sessions
CREATE TABLE dashboard_sessions (id TEXT PRIMARY KEY, user_id TEXT NOT NULL, token_id TEXT, session_token TEXT UNIQUE NOT NULL, expires_at INTEGER NOT NULL, last_activity INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT), ip_address TEXT, user_agent TEXT, created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT));

-- Table: database_schemas
CREATE TABLE database_schemas (
    id TEXT PRIMARY KEY,
    database_name TEXT NOT NULL,
    database_id TEXT, -- Cloudflare D1 database ID
    schema_version TEXT,
    schema_file_path TEXT, -- Path in allinfrastructure bucket
    schema_content TEXT, -- Full schema SQL or JSONB
    tables_count INTEGER,
    indexes_count INTEGER,
    last_updated INTEGER,
    documented_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: data_sources
CREATE TABLE data_sources (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            type TEXT,
            record_count INTEGER DEFAULT 0,
            last_sync TEXT,
            created_at TEXT DEFAULT (NOW())
          );

-- Table: deployment_environments
CREATE TABLE deployment_environments (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    environment_name TEXT NOT NULL, -- 'fred-dev', 'connor-dev', etc.
    subdomain TEXT NOT NULL, -- 'fred-dev.meauxbility.workers.dev'
    worker_name TEXT,
    pages_name TEXT,
    is_active INTEGER DEFAULT 1,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    UNIQUE(user_id, environment_name)
);

-- Table: deployment_logs
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
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    completed_at INTEGER
);

-- Table: design_knowledge_base
CREATE TABLE design_knowledge_base (
    id TEXT PRIMARY KEY,
    design_type TEXT NOT NULL, -- 'logo', 'brand_identity', 'ui_ux', 'graphic', 'icon', 'color_palette', 'typography'
    title TEXT NOT NULL,
    description TEXT,
    quality_level TEXT, -- 'clay_global', 'professional', 'good', 'reference'
    design_principles TEXT, -- Design principles applied
    tools_used TEXT, -- JSONB array: ['Spline', 'Figma', 'Illustrator', etc.]
    reference_urls TEXT, -- JSONB array of reference URLs
    embedding_json TEXT,
    metadata_json TEXT, -- {colors, fonts, style, inspiration, etc.}
    created_by TEXT DEFAULT 'fred',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: designs
CREATE TABLE designs (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            category TEXT,
            tags TEXT,
            thumbnail_url TEXT,
            created_at TEXT DEFAULT (NOW())
          );

-- Table: design_templates
CREATE TABLE design_templates (
    id TEXT PRIMARY KEY,
    template_name TEXT NOT NULL,
    design_type TEXT, -- 'logo', 'brand_identity', 'ui_component', etc.
    quality_standard TEXT, -- 'clay_global', 'professional', etc.
    template_data TEXT, -- JSONB or file reference
    usage_instructions TEXT,
    quality_score INTEGER,
    embedding_json TEXT,
    metadata_json TEXT, -- {colors, fonts, dimensions, tools, etc.}
    created_by TEXT DEFAULT 'fred',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: development_workflows
CREATE TABLE development_workflows (
    id TEXT PRIMARY KEY,
    workflow_name TEXT NOT NULL,
    description TEXT,
    category TEXT, -- 'setup', 'deployment', 'testing', 'debugging', 'optimization', 'architecture'
    steps_json TEXT, -- JSONB array of workflow steps
    code_examples TEXT, -- Code snippets or examples
    time_estimate INTEGER, -- Minutes
    success_rate DOUBLE PRECISION, -- 0-1
    quality_score INTEGER, -- 1-10
    last_used TIMESTAMPTZ,
    use_count INTEGER DEFAULT 0,
    created_by TEXT,
    embedding_json TEXT, -- For RAG search
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: device_sessions
CREATE TABLE device_sessions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    device_id TEXT NOT NULL, -- Unique device identifier
    device_name TEXT NOT NULL, -- "Sam's MacBook", "Sam's iPhone", etc.
    device_type TEXT NOT NULL, -- 'desktop', 'mobile', 'tablet'
    user_agent TEXT,
    ip_address TEXT,
    last_activity INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    expires_at INTEGER, -- NULL = never expires
    is_active INTEGER DEFAULT 1,
    UNIQUE(user_id, device_id)
);

-- Table: documents
CREATE TABLE documents (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT,
    category TEXT, -- brand-guidelines, handbook, api-docs, etc.
    owner_id TEXT,
    created_at TEXT DEFAULT NOW(),
    updated_at TEXT DEFAULT NOW()
);

-- Table: donations
CREATE TABLE donations (
          id TEXT PRIMARY KEY,
          amount INTEGER,
          currency TEXT,
          status TEXT,
          stripe_payment_intent_id TEXT,
          created_at INTEGER
        );

-- Table: ecosystem_knowledge_base
CREATE TABLE ecosystem_knowledge_base (
    id TEXT PRIMARY KEY,
    workflow_type TEXT NOT NULL, -- 'development', 'design', 'grant_writing', 'general', 'branding'
    document_type TEXT NOT NULL, -- 'best_practice', 'template', 'example', 'tutorial', 'workflow', 'code_snippet', 'design_asset'
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    embedding_json TEXT, -- JSONB array of embedding vectors
    chunk_index INTEGER DEFAULT 0,
    source TEXT, -- 'uploaded', 'ai_generated', 'past_project', 'external'
    metadata_json TEXT, -- JSONB: {tags, quality_score, success_rate, time_saved, etc.}
    created_by TEXT, -- 'sam', 'connor', 'fred', 'amber', 'system'
    assigned_to TEXT, -- Team member this is most relevant for
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: ecosystem_rag_queries
CREATE TABLE ecosystem_rag_queries (
    id TEXT PRIMARY KEY,
    query_text TEXT NOT NULL,
    workflow_type TEXT, -- 'development', 'design', 'grant_writing', 'general'
    team_member TEXT, -- Who asked
    retrieved_docs TEXT, -- JSONB array of document IDs
    generated_response TEXT,
    context_type TEXT,
    success_rating INTEGER, -- 1-5 user rating
    time_saved INTEGER, -- Minutes saved
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: email_events
CREATE TABLE email_events (
                        id TEXT PRIMARY KEY,
                        event_type TEXT NOT NULL,
                        email_id TEXT,
                        recipient TEXT,
                        status TEXT,
                        metadata TEXT,
                        created_at TEXT DEFAULT NOW()
                    );

-- Table: email_messages
CREATE TABLE email_messages (
    id TEXT PRIMARY KEY,
    from_address TEXT NOT NULL,
    to_address TEXT NOT NULL,
    subject TEXT,
    body TEXT,
    received_at TEXT DEFAULT NOW(),
    read BOOLEAN DEFAULT FALSE
);

-- Table: employee_storage
CREATE TABLE employee_storage (
    id TEXT PRIMARY KEY,
    employee_email TEXT NOT NULL UNIQUE,
    employee_name TEXT NOT NULL,
    r2_bucket_name TEXT NOT NULL,
    storage_quota_gb INTEGER DEFAULT 10,
    storage_used_gb DOUBLE PRECISION DEFAULT 0,
    folder_path TEXT DEFAULT '', -- Subfolder path in bucket (e.g., 'employees/sam/')
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: enrollments
CREATE TABLE enrollments (   id TEXT PRIMARY KEY,   userId TEXT NOT NULL,   courseId TEXT NOT NULL,   enrolledAt TEXT NOT NULL,   completedAt TEXT,   progress INTEGER DEFAULT 0,    status TEXT DEFAULT 'active',   UNIQUE(userId, courseId) );

-- Table: env_variables
CREATE TABLE env_variables (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    environment TEXT NOT NULL,
    key TEXT NOT NULL,
    value TEXT NOT NULL,
    encrypted BOOLEAN DEFAULT TRUE,
    description TEXT,
    is_secret BOOLEAN DEFAULT TRUE,
    required BOOLEAN DEFAULT FALSE,
    default_value TEXT,
    synced_to_platform BOOLEAN DEFAULT FALSE,
    last_synced_at TEXT,
    created_by TEXT,
    updated_by TEXT,
    created_at TEXT DEFAULT NOW(),
    updated_at TEXT DEFAULT NOW(),
    UNIQUE(project_id, environment, key)
);

-- Table: external_integrations
CREATE TABLE external_integrations (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    service_name TEXT NOT NULL, -- 'openai', 'claude', 'canva', 'instagram', 'capcut', etc.
    service_type TEXT NOT NULL, -- 'ai', 'social', 'design', 'video'
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at INTEGER,
    api_key TEXT, -- For API key-based services
    metadata TEXT, -- JSONB with service-specific data
    is_active INTEGER DEFAULT 1,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    UNIQUE(user_id, service_name)
);

-- Table: extracted_files
CREATE TABLE extracted_files (
    id SERIAL PRIMARY KEY,
    project_id TEXT NOT NULL,
    zip_id TEXT NOT NULL,
    zip_key TEXT NOT NULL,
    file_key TEXT NOT NULL,
    file_name TEXT NOT NULL,
    mime_type TEXT,
    size_bytes INTEGER,
    created_at TEXT DEFAULT (NOW())
);

-- Table: feature_flags
CREATE TABLE feature_flags (
  id SERIAL PRIMARY KEY,
  feature_name TEXT UNIQUE NOT NULL,
  enabled INTEGER DEFAULT 0,
  version_introduced TEXT,
  description TEXT,
  config JSONB,
  updated_at TEXT DEFAULT (NOW())
);

-- Table: grant_activity_log
CREATE TABLE grant_activity_log (
    id TEXT PRIMARY KEY,
    entity_type TEXT, -- 'opportunity', 'application', 'campaign'
    entity_id TEXT,
    action TEXT, -- 'created', 'updated', 'submitted', 'approved', etc.
    user_id TEXT,
    details TEXT, -- JSONB details
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: grant_applications
CREATE TABLE grant_applications (
    id TEXT PRIMARY KEY,
    opportunity_id TEXT,
    status TEXT DEFAULT 'draft', -- 'draft', 'submitted', 'under_review', 'approved', 'declined', 'funded'
    submitted_date DATE,
    amount_requested DOUBLE PRECISION,
    proposal_text TEXT,
    budget_json TEXT, -- JSONB budget breakdown
    supporting_docs TEXT, -- JSONB array of R2 file paths
    notes TEXT,
    team_notes TEXT, -- Notes from other team members
    created_by TEXT DEFAULT 'amber',
    assigned_to TEXT DEFAULT 'amber', -- Primary grant writer
    reviewed_by TEXT, -- Team member who reviewed
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: grant_campaigns
CREATE TABLE grant_campaigns (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    target_amount DOUBLE PRECISION,
    deadline DATE,
    status TEXT DEFAULT 'planning', -- 'planning', 'active', 'completed', 'cancelled'
    grants_included TEXT, -- JSONB array of opportunity IDs
    team_members TEXT, -- JSONB array of team member IDs
    created_by TEXT DEFAULT 'amber',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: grant_knowledge_base
CREATE TABLE grant_knowledge_base (
    id TEXT PRIMARY KEY,
    document_type TEXT NOT NULL, -- 'proposal', 'success_story', 'best_practice', 'mission_statement', 'impact_data'
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    embedding_json TEXT, -- JSONB array of embedding vectors
    chunk_index INTEGER DEFAULT 0, -- For chunked documents
    source TEXT, -- 'uploaded', 'ai_generated', 'past_proposal'
    metadata_json TEXT, -- JSONB: {tags, grant_type, amount, date, success_rate, etc.}
    created_by TEXT DEFAULT 'amber',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: grant_opportunities
CREATE TABLE grant_opportunities (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    organization TEXT,
    amount_min DOUBLE PRECISION,
    amount_max DOUBLE PRECISION,
    deadline DATE,
    status TEXT DEFAULT 'open', -- 'open', 'upcoming', 'closed', 'archived'
    eligibility TEXT,
    requirements TEXT,
    application_url TEXT,
    contact_email TEXT,
    contact_phone TEXT,
    relevance_score INTEGER DEFAULT 0, -- 1-10 AI-generated score
    location TEXT, -- State/region focus
    focus_areas TEXT, -- JSONB array: ["mobility", "spinal_cord_injury", "accessibility"]
    notes TEXT,
    ai_insights TEXT, -- Gemini-generated analysis
    created_by TEXT DEFAULT 'amber', -- Team member who added it
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: grant_research_notes
CREATE TABLE grant_research_notes (
    id TEXT PRIMARY KEY,
    opportunity_id TEXT,
    note_text TEXT,
    ai_insights TEXT, -- Gemini-generated insights
    competitive_analysis TEXT, -- Strengths/weaknesses
    created_by TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: grant_templates
CREATE TABLE grant_templates (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    template_text TEXT, -- Template content
    sections TEXT, -- JSONB array of section names
    created_by TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: grant_templates_rag
CREATE TABLE grant_templates_rag (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    grant_type TEXT, -- 'equipment', 'program', 'capital', 'operating'
    sections_json TEXT, -- Template structure
    best_practices TEXT, -- AI-generated best practices
    example_text TEXT, -- Example content
    embedding_json TEXT, -- Template embedding
    success_rate DOUBLE PRECISION, -- Historical success rate
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: grant_workflows
CREATE TABLE grant_workflows (
    id TEXT PRIMARY KEY,
    workflow_name TEXT NOT NULL,
    description TEXT,
    steps_json TEXT, -- JSONB array of workflow steps
    estimated_time INTEGER, -- Minutes
    required_resources TEXT, -- JSONB array
    success_rate DOUBLE PRECISION,
    last_used TIMESTAMPTZ,
    use_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: iautodidact_analytics
CREATE TABLE iautodidact_analytics (
    id TEXT PRIMARY KEY,
    team_member TEXT,
    module_id TEXT,
    lesson_id TEXT,
    action_type TEXT, -- 'view', 'complete', 'quiz_attempt', 'code_run', 'error'
    action_data TEXT, -- JSONB: {details, time_spent, errors, etc.}
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: iautodidact_code_examples
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
    testable BOOLEAN DEFAULT FALSE, -- Can be run/tested
    test_code TEXT, -- Test cases or validation
    embedding_json TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: iautodidact_content
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
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: iautodidact_learning_paths
CREATE TABLE iautodidact_learning_paths (
    id TEXT PRIMARY KEY,
    path_name TEXT NOT NULL,
    description TEXT,
    target_audience TEXT, -- 'developers', 'designers', 'all', 'sam', 'connor', etc.
    modules_json TEXT, -- JSONB array of module IDs in order
    estimated_total_time INTEGER,
    difficulty_level TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: iautodidact_lessons
CREATE TABLE iautodidact_lessons (
    id TEXT PRIMARY KEY,
    module_id TEXT NOT NULL,
    lesson_name TEXT NOT NULL,
    lesson_type TEXT, -- 'tutorial', 'example', 'exercise', 'quiz', 'project'
    content_html TEXT, -- Full lesson content (HTML)
    code_examples TEXT, -- JSONB array of code examples
    interactive_examples TEXT, -- JSONB: {sandbox_url, test_cases, etc.}
    learning_objectives TEXT, -- JSONB array
    difficulty_level TEXT,
    order_index INTEGER DEFAULT 0,
    estimated_time INTEGER,
    embedding_json TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: iautodidact_modules
CREATE TABLE iautodidact_modules (
    id TEXT PRIMARY KEY,
    module_name TEXT NOT NULL,
    category TEXT NOT NULL, -- 'openai', 'cloudflare', 'gemini', 'google_cloud', 'general'
    description TEXT,
    difficulty_level TEXT, -- 'beginner', 'intermediate', 'advanced'
    estimated_time INTEGER, -- Minutes
    order_index INTEGER DEFAULT 0,
    content_json TEXT, -- JSONB: {lessons, exercises, examples, code_snippets}
    prerequisites TEXT, -- JSONB array of module IDs
    completion_criteria TEXT,
    embedding_json TEXT, -- For RAG search
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: iautodidact_progress
CREATE TABLE iautodidact_progress (
    id TEXT PRIMARY KEY,
    team_member TEXT NOT NULL, -- 'sam', 'connor', 'fred', 'amber'
    module_id TEXT,
    lesson_id TEXT,
    status TEXT, -- 'not_started', 'in_progress', 'completed', 'skipped'
    progress_percentage INTEGER DEFAULT 0,
    time_spent INTEGER DEFAULT 0, -- Minutes
    last_accessed TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    notes TEXT,
    quiz_scores TEXT, -- JSONB: {quiz_id: score}
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: image_meta
CREATE TABLE image_meta (
    key TEXT PRIMARY KEY,
    title TEXT,
    alt TEXT,
    tags TEXT,
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: images_metadata
CREATE TABLE images_metadata (
  id SERIAL PRIMARY KEY,
  image_id TEXT NOT NULL UNIQUE, -- Cloudflare Images ID
  filename TEXT,
  description TEXT,
  tags TEXT, -- JSONB array as text
  category TEXT,
  sensitive INTEGER DEFAULT 0, -- 0 = false, 1 = true
  variants TEXT, -- JSONB array as text
  created_at TEXT DEFAULT NOW(),
  updated_at TEXT DEFAULT NOW()
);

-- Table: infrastructure_documentation
CREATE TABLE infrastructure_documentation (
    id TEXT PRIMARY KEY,
    bucket_name TEXT NOT NULL DEFAULT 'allinfrastructure',
    r2_key TEXT NOT NULL UNIQUE, -- Full path in R2 (e.g., 'ANALYTICS_SETUP.md')
    title TEXT NOT NULL,
    file_type TEXT, -- 'markdown', 'JSONB', 'image', etc.
    category TEXT, -- 'analytics', 'r2-setup', 'database', 'onboarding', etc.
    size_bytes INTEGER,
    content_preview TEXT, -- First 500 chars for quick reference
    r2_object_id TEXT, -- Reference to r2_objects table
    tags TEXT, -- JSONB array of tags
    last_synced_at INTEGER,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT) NULL
);

-- Table: infrastructure_metadata
CREATE TABLE infrastructure_metadata (
    id TEXT PRIMARY KEY,
    metadata_type TEXT NOT NULL, -- 'infrastructure-map', 'team-directory', 'config', etc.
    bucket_name TEXT NOT NULL DEFAULT 'allinfrastructure',
    r2_key TEXT NOT NULL UNIQUE,
    metadata_json TEXT NOT NULL, -- Full JSONB content
    version TEXT,
    last_synced_at INTEGER,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: journey_applications
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
  created_at TEXT NOT NULL DEFAULT (NOW()),
  updated_at TEXT NOT NULL DEFAULT (NOW())
);

-- Table: kanban_boards
CREATE TABLE kanban_boards (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    owner_id TEXT,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: kanban_columns
CREATE TABLE kanban_columns (
    id TEXT PRIMARY KEY,
    board_id TEXT NOT NULL,
    name TEXT NOT NULL,
    position INTEGER NOT NULL,
    color TEXT DEFAULT '#4AECDC'
);

-- Table: kanban_tasks
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
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    completed_at INTEGER
);

-- Table: knowledge_base
CREATE TABLE knowledge_base (
  id TEXT PRIMARY KEY,
  category TEXT NOT NULL,
  title TEXT NOT NULL,
  content_summary TEXT,
  tags TEXT,
  r2_path TEXT NOT NULL,
  file_size INTEGER,
  created_at TEXT DEFAULT NOW(),
  updated_at TEXT DEFAULT NOW(),
  indexed_at TEXT DEFAULT NOW()
);

-- Table: lessons
CREATE TABLE lessons (   id TEXT PRIMARY KEY,   courseId TEXT NOT NULL,   title TEXT NOT NULL,   slug TEXT NOT NULL,   description TEXT,   content TEXT,    videoUrl TEXT,   duration INTEGER,    orderIndex INTEGER NOT NULL,   isPublished INTEGER DEFAULT 0,    createdAt TEXT NOT NULL,   updatedAt TEXT NOT NULL,   UNIQUE(courseId, slug) );

-- Table: library_builds
CREATE TABLE library_builds (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL,
    status TEXT DEFAULT 'working',
    size INTEGER DEFAULT 0,
    uploaded_at TIMESTAMPTZ DEFAULT NOW(),
    source_path TEXT,
    preview_url TEXT,
    thumbnail_path TEXT,
    deployed_url TEXT,
    repo_url TEXT
);

-- Table: mail_received
CREATE TABLE mail_received (
            id TEXT PRIMARY KEY,
            resend_id TEXT,
            from_addr TEXT NOT NULL,
            subject TEXT,
            received_at TEXT NOT NULL,
            snippet TEXT,
            body TEXT,
            created_at TEXT DEFAULT (NOW())
          );

-- Table: main.analytics_snapshots
CREATE TABLE "main.analytics_snapshots"(
  "sam_primeaux" TEXT
);

-- Table: meauxaccess_executions
CREATE TABLE meauxaccess_executions (id SERIAL PRIMARY KEY, command_code TEXT NOT NULL, user_id TEXT, status TEXT NOT NULL, message TEXT, executed_at TIMESTAMPTZ DEFAULT NOW());

-- Table: meauxauto_ingestions
CREATE TABLE meauxauto_ingestions (
    id SERIAL PRIMARY KEY,
    job_id TEXT NOT NULL UNIQUE,
    source TEXT NOT NULL,
    source_path TEXT,
    status TEXT DEFAULT 'processing',
    documents INTEGER DEFAULT 0,
    tokens INTEGER DEFAULT 0,
    created_at TEXT DEFAULT NOW(),
    completed_at TEXT
);

-- Table: meauxauto_queries
CREATE TABLE meauxauto_queries (
    id SERIAL PRIMARY KEY,
    conversation_id TEXT,
    query TEXT NOT NULL,
    response TEXT NOT NULL,
    created_at TEXT DEFAULT NOW()
);

-- Table: meauxauto_training
CREATE TABLE meauxauto_training (
    id SERIAL PRIMARY KEY,
    training_id TEXT NOT NULL UNIQUE,
    status TEXT DEFAULT 'processing',
    model_version TEXT,
    accuracy DOUBLE PRECISION,
    created_at TEXT DEFAULT NOW(),
    completed_at TEXT
);

-- Table: meauxbility_context
CREATE TABLE meauxbility_context (
    id TEXT PRIMARY KEY,
    context_type TEXT NOT NULL, -- 'mission', 'impact_story', 'statistic', 'program_description'
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    data_json TEXT, -- Structured data (numbers, dates, etc.)
    embedding_json TEXT,
    priority INTEGER DEFAULT 5, -- 1-10, higher = more important to include
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: meeting_notes
CREATE TABLE meeting_notes (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    stream_id TEXT, -- Cloudflare Stream ID
    meeting_type TEXT DEFAULT 'general', -- 'nonprofit', 'team', 'client', etc.
    meeting_name TEXT,
    transcript TEXT, -- Full transcript if available
    notes TEXT, -- AI-generated notes
    todos TEXT, -- JSONB array of to-do items
    summary TEXT, -- AI-generated summary
    key_points TEXT, -- JSONB array of key discussion points
    participants TEXT, -- JSONB array of participant names/IDs
    duration INTEGER, -- Meeting duration in seconds
    recording_url TEXT, -- Link to recording if available
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: messages
CREATE TABLE messages (
    id TEXT PRIMARY KEY,
    channel_id TEXT,
    user_id TEXT NOT NULL,
    user_name TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TEXT DEFAULT NOW()
);

-- Table: missions
CREATE TABLE missions (
  id TEXT PRIMARY KEY,
  vision_id TEXT,
  title TEXT NOT NULL,
  description TEXT,
  target_date TEXT,
  status TEXT DEFAULT 'active' CHECK(status IN ('active', 'completed', 'paused')),
  created_at TEXT DEFAULT NOW(),
  updated_at TEXT DEFAULT NOW()
);

-- Table: model_pricing
CREATE TABLE model_pricing (
    model TEXT PRIMARY KEY,
    provider TEXT NOT NULL,
    input_price_per_1m DOUBLE PRECISION NOT NULL,
    output_price_per_1m DOUBLE PRECISION NOT NULL,
    context_window INTEGER,
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: newsletter_subscribers
CREATE TABLE newsletter_subscribers (
                        id SERIAL PRIMARY KEY,
                        email TEXT UNIQUE NOT NULL,
                        source TEXT,
                        subscribed_at TIMESTAMPTZ DEFAULT NOW(),
                        status TEXT DEFAULT 'active',
                        metadata TEXT
                    );

-- Table: north_star_metric
CREATE TABLE north_star_metric (
  id TEXT PRIMARY KEY,
  metric_name TEXT NOT NULL,
  description TEXT,
  current_value DOUBLE PRECISION,
  target_value DOUBLE PRECISION,
  unit TEXT,
  updated_at TEXT DEFAULT NOW()
);

-- Table: openai_budgets
CREATE TABLE openai_budgets (
    id TEXT PRIMARY KEY,
    month_year TEXT NOT NULL, -- '2025-12'
    budget_amount DOUBLE PRECISION NOT NULL, -- $20.00
    current_spend DOUBLE PRECISION DEFAULT 0.0,
    alert_threshold DOUBLE PRECISION DEFAULT 0.8, -- 80%
    alert_email TEXT, -- meauxbility@gmail.com
    reset_date DATE, -- When budget resets
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: openai_model_usage
CREATE TABLE openai_model_usage (
    id TEXT PRIMARY KEY,
    model TEXT NOT NULL,
    date DATE NOT NULL,
    request_count INTEGER DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    cost_usd DOUBLE PRECISION DEFAULT 0.0,
    avg_tokens_per_request DOUBLE PRECISION DEFAULT 0.0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(model, date)
);

-- Table: openai_spending
CREATE TABLE openai_spending (
    id TEXT PRIMARY KEY,
    date DATE NOT NULL,
    hour INTEGER, -- 0-23, NULL for daily totals
    model TEXT, -- Model used (gpt-4o, gpt-4o-mini, etc.)
    usage_type TEXT, -- 'completion', 'embedding', 'image', 'audio', etc.
    input_tokens INTEGER DEFAULT 0,
    output_tokens INTEGER DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    cost_usd DOUBLE PRECISION DEFAULT 0.0,
    request_count INTEGER DEFAULT 0,
    metadata_json TEXT, -- JSONB: {project_id, user_id, endpoint, etc.}
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: openai_spending_alerts
CREATE TABLE openai_spending_alerts (
    id TEXT PRIMARY KEY,
    budget_id TEXT,
    alert_type TEXT, -- 'threshold', 'budget_exceeded', 'daily_limit'
    threshold_percentage DOUBLE PRECISION, -- 80%
    current_spend DOUBLE PRECISION,
    budget_amount DOUBLE PRECISION,
    message TEXT,
    sent_at TIMESTAMPTZ,
    email_sent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: optimize_jobs
CREATE TABLE optimize_jobs (
    id SERIAL PRIMARY KEY,
    file_id INTEGER NOT NULL,
    project_id TEXT NOT NULL,
    zip_id TEXT NOT NULL,
    file_key TEXT NOT NULL,
    mode TEXT NOT NULL,
    cloudconvert_job_id TEXT,
    status TEXT NOT NULL DEFAULT 'requested',
    created_at TEXT DEFAULT (NOW()),
    updated_at TEXT DEFAULT (NOW())
);

-- Table: organizations
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
    settings JSONB,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: org_settings
CREATE TABLE org_settings (
  id            TEXT PRIMARY KEY,
  org_id        TEXT NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  key           TEXT NOT NULL,
  value         TEXT,
  UNIQUE(org_id, key)
);

-- Table: payouts
CREATE TABLE payouts (
    id TEXT PRIMARY KEY DEFAULT (gen_random_uuid()::text),
    employee_id TEXT,
    volunteer_id TEXT,
    amount DOUBLE PRECISION NOT NULL,
    currency TEXT DEFAULT 'usd',
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled')),
    payment_method TEXT,
    payment_reference TEXT,
    description TEXT,
    period_start TEXT,
    period_end TEXT,
    hours_worked DOUBLE PRECISION,
    hourly_rate DOUBLE PRECISION,
    project_ids TEXT,
    notes TEXT,
    paid_at TEXT,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: pillars
CREATE TABLE pillars (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TEXT DEFAULT NOW(),
  updated_at TEXT DEFAULT NOW()
);

-- Table: progress
CREATE TABLE progress (   id TEXT PRIMARY KEY,   userId TEXT NOT NULL,   lessonId TEXT NOT NULL,   courseId TEXT NOT NULL,   completed INTEGER DEFAULT 0,    completedAt TEXT,   timeSpent INTEGER DEFAULT 0,    lastAccessedAt TEXT,   UNIQUE(userId, lessonId) );

-- Table: project_activity
CREATE TABLE project_activity (
          id TEXT PRIMARY KEY DEFAULT (gen_random_uuid()::text),
          project_id TEXT,
          team_member_id TEXT,
          action_type TEXT NOT NULL,
          action_description TEXT NOT NULL,
          metadata TEXT,
          created_at TEXT DEFAULT NOW()
        );

-- Table: project_assignments
CREATE TABLE project_assignments (
          id TEXT PRIMARY KEY DEFAULT (gen_random_uuid()::text),
          project_id TEXT NOT NULL,
          team_member_id TEXT NOT NULL,
          role TEXT DEFAULT 'contributor',
          assigned_at TEXT DEFAULT NOW(),
          UNIQUE(project_id, team_member_id)
        );

-- Table: project_costs
CREATE TABLE project_costs (
    project_id TEXT PRIMARY KEY,
    total_time_seconds INTEGER DEFAULT 0,
    total_time_cost DOUBLE PRECISION DEFAULT 0.0,
    total_ai_tokens INTEGER DEFAULT 0,
    total_ai_cost DOUBLE PRECISION DEFAULT 0.0,
    total_cost DOUBLE PRECISION DEFAULT 0.0,
    last_updated INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: project_cost_summary
CREATE TABLE project_cost_summary (
    project_id TEXT PRIMARY KEY,
    project_name TEXT NOT NULL,
    total_cost DOUBLE PRECISION DEFAULT 0,
    openai_cost DOUBLE PRECISION DEFAULT 0,
    gemini_cost DOUBLE PRECISION DEFAULT 0,
    cloudflare_cost DOUBLE PRECISION DEFAULT 0,
    other_cost DOUBLE PRECISION DEFAULT 0,
    total_time_hours DOUBLE PRECISION DEFAULT 0,
    total_api_calls INTEGER DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    avg_cost_per_hour DOUBLE PRECISION,
    cost_efficiency_score DOUBLE PRECISION, -- Calculated metric
    last_updated TIMESTAMPTZ DEFAULT NOW()
);

-- Table: project_deadlines
CREATE TABLE project_deadlines (
    id TEXT PRIMARY KEY DEFAULT (gen_random_uuid()::text),
    project_id TEXT NOT NULL,
    deadline_date TEXT NOT NULL,
    deadline_type TEXT DEFAULT 'milestone' CHECK (deadline_type IN ('milestone', 'delivery', 'review', 'launch', 'other')),
    title TEXT NOT NULL,
    description TEXT,
    assigned_to TEXT,
    status TEXT DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'in_progress', 'completed', 'overdue', 'cancelled')),
    priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    completed_at TEXT,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: project_milestones
CREATE TABLE project_milestones (
          id TEXT PRIMARY KEY DEFAULT (gen_random_uuid()::text),
          project_id TEXT NOT NULL,
          name TEXT NOT NULL,
          description TEXT,
          status TEXT DEFAULT 'pending',
          due_date TEXT,
          completed_at TEXT,
          progress_percent INTEGER DEFAULT 0,
          created_at TEXT DEFAULT NOW(),
          updated_at TEXT DEFAULT NOW()
        );

-- Table: project_progress
CREATE TABLE project_progress (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    project_name TEXT NOT NULL,
    team_member TEXT,
    status TEXT DEFAULT 'in_progress', -- not_started, in_progress, completed, blocked
    progress_percentage INTEGER DEFAULT 0,
    milestones TEXT, -- JSONB array of milestones
    completed_milestones TEXT, -- JSONB array of completed milestone IDs
    estimated_hours DOUBLE PRECISION,
    actual_hours DOUBLE PRECISION,
    estimated_cost DOUBLE PRECISION,
    actual_cost DOUBLE PRECISION,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: project_registry
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
    monthly_budget DOUBLE PRECISION,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: project_stats
CREATE TABLE project_stats (
    id SERIAL PRIMARY KEY,
    project_id TEXT NOT NULL UNIQUE,
    project_name TEXT NOT NULL,
    url TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'deployed',
    type TEXT NOT NULL DEFAULT 'Pages',
    category TEXT,
    last_deployed_at TEXT,
    created_at TEXT DEFAULT NOW(),
    updated_at TEXT DEFAULT NOW()
);

-- Table: project_tasks
CREATE TABLE project_tasks (
          id TEXT PRIMARY KEY DEFAULT (gen_random_uuid()::text),
          project_id TEXT NOT NULL,
          milestone_id TEXT,
          assigned_to TEXT,
          title TEXT NOT NULL,
          description TEXT,
          status TEXT DEFAULT 'todo',
          priority TEXT DEFAULT 'medium',
          estimated_hours DOUBLE PRECISION,
          actual_hours DOUBLE PRECISION,
          due_date TEXT,
          completed_at TEXT,
          created_at TEXT DEFAULT NOW(),
          updated_at TEXT DEFAULT NOW()
        );

-- Table: project_team
CREATE TABLE project_team (
  project_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  role TEXT DEFAULT 'member' CHECK(role IN ('owner', 'admin', 'member', 'viewer')),
  PRIMARY KEY (project_id, user_id)
);

-- Table: project_todos
CREATE TABLE project_todos (
    id TEXT PRIMARY KEY,
    project_id TEXT NOT NULL,
    content TEXT NOT NULL,
    completed INTEGER DEFAULT 0,
    priority TEXT DEFAULT 'medium',
    assignee_id TEXT,
    due_date INTEGER,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: prompt_templates
CREATE TABLE prompt_templates (id SERIAL PRIMARY KEY, slug TEXT UNIQUE NOT NULL, title TEXT NOT NULL, description TEXT NOT NULL, tags TEXT NOT NULL, meta TEXT NOT NULL, body TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT (NOW()), updated_at TEXT NOT NULL DEFAULT (NOW()));

-- Table: public_dev_users
CREATE TABLE public_dev_users (
  user_id TEXT,
  external_id TEXT PRIMARY KEY,
  email TEXT,
  role TEXT,
  joined_at TEXT
);

-- Table: quick_stats
CREATE TABLE quick_stats (
    stat_key TEXT PRIMARY KEY,
    stat_value TEXT NOT NULL,
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: rag_queries
CREATE TABLE rag_queries (
  id TEXT PRIMARY KEY,
  query TEXT NOT NULL,
  query_embedding_json TEXT,
  response TEXT,
  sources TEXT,
  model_used TEXT,
  latency_ms INTEGER,
  cache_hit BOOLEAN DEFAULT FALSE,
  created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: rag_query_history
CREATE TABLE rag_query_history (
    id TEXT PRIMARY KEY,
    query_text TEXT NOT NULL,
    retrieved_docs TEXT, -- JSONB array of document IDs
    generated_response TEXT,
    user_id TEXT,
    context_type TEXT, -- 'grant_writing', 'proposal_review', 'opportunity_research'
    success_rating INTEGER, -- 1-5 user rating
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: resource_access_log
CREATE TABLE resource_access_log (id TEXT PRIMARY KEY, user_id TEXT NOT NULL, token_id TEXT, resource_type TEXT NOT NULL, resource_name TEXT, action TEXT NOT NULL, status TEXT DEFAULT 'success', metadata TEXT, ip_address TEXT, user_agent TEXT, timestamp INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT));

-- Table: scene_configs
CREATE TABLE scene_configs (
                        id SERIAL PRIMARY KEY,
                        name TEXT NOT NULL UNIQUE,
                        scene_type TEXT NOT NULL,
                        config_json TEXT NOT NULL,
                        description TEXT,
                        is_active INTEGER DEFAULT 0,
                        created_at TIMESTAMPTZ DEFAULT NOW(),
                        updated_at TIMESTAMPTZ DEFAULT NOW()
                    );

-- Table: scheduled_streams
CREATE TABLE scheduled_streams (
    id TEXT PRIMARY KEY DEFAULT (gen_random_uuid()::text),
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
    email_sent BOOLEAN DEFAULT FALSE,
    email_sent_at TEXT,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: secret_access_log
CREATE TABLE secret_access_log (
    id TEXT PRIMARY KEY,
    secret_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    action TEXT NOT NULL, -- 'view', 'update', 'delete', 'use'
    ip_address TEXT,
    user_agent TEXT,
    timestamp INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: secret_fingerprints
CREATE TABLE secret_fingerprints (
  id TEXT PRIMARY KEY,
  service TEXT NOT NULL,
  fingerprint TEXT NOT NULL,
  env_var_names TEXT NOT NULL DEFAULT '[]',
  notes TEXT,
  created_at INTEGER NOT NULL DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
  updated_at INTEGER NOT NULL DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: secure_vault
CREATE TABLE secure_vault (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT, -- api_key, password, token, etc.
    encrypted_value TEXT NOT NULL,
    owner_id TEXT,
    created_at TEXT DEFAULT NOW(),
    updated_at TEXT DEFAULT NOW()
);

-- Table: security_events
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
    details TEXT, -- JSONB string
    timestamp INTEGER NOT NULL,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: seo_metadata
CREATE TABLE seo_metadata (
  id SERIAL PRIMARY KEY,
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
  updated_at TEXT DEFAULT (NOW())
);

-- Table: sessions
CREATE TABLE sessions (
  id TEXT PRIMARY KEY, -- Session token
  user_id INTEGER NOT NULL,
  expires_at TEXT NOT NULL,
  created_at TEXT DEFAULT NOW()
);

-- Table: settings
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  description TEXT,
  updated_at TEXT DEFAULT NOW()
);

-- Table: storage_usage
CREATE TABLE storage_usage (
    id SERIAL PRIMARY KEY,
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
    limit_reached BOOLEAN DEFAULT FALSE,
    cost_usd DOUBLE PRECISION DEFAULT 0,
    measured_at TEXT DEFAULT NOW(),
    created_at TEXT DEFAULT NOW()
);

-- Table: stripe_donations
CREATE TABLE stripe_donations (
    id TEXT PRIMARY KEY,
    stripe_payment_intent_id TEXT UNIQUE,
    amount DOUBLE PRECISION NOT NULL,
    currency TEXT DEFAULT 'usd',
    donor_name TEXT,
    donor_email TEXT,
    campaign TEXT, -- Campaign or grant fund
    status TEXT DEFAULT 'pending', -- 'pending', 'succeeded', 'failed', 'refunded'
    grant_application_id TEXT, -- Link to grant if applicable
    metadata TEXT, -- JSONB metadata
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: submission_analytics
CREATE TABLE submission_analytics (
  id SERIAL PRIMARY KEY,
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
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: successful_proposals
CREATE TABLE successful_proposals (
    id TEXT PRIMARY KEY,
    grant_opportunity_id TEXT,
    proposal_text TEXT NOT NULL,
    sections_json TEXT, -- JSONB: {executive_summary, need_statement, methodology, budget, etc.}
    amount_awarded DOUBLE PRECISION,
    success_factors TEXT, -- AI-analyzed reasons for success
    embedding_json TEXT, -- Full proposal embedding for RAG
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: sync_jobs
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
    progress_percent DOUBLE PRECISION DEFAULT 0,
    files_synced INTEGER DEFAULT 0,
    files_skipped INTEGER DEFAULT 0,
    files_failed INTEGER DEFAULT 0,
    error_message TEXT,
    created_at TEXT DEFAULT NOW(),
    started_at TEXT,
    completed_at TEXT
);

-- Table: task_comments
CREATE TABLE task_comments (
    id TEXT PRIMARY KEY,
    task_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: task_todos
CREATE TABLE task_todos (
    id TEXT PRIMARY KEY,
    task_id TEXT NOT NULL,
    content TEXT NOT NULL,
    completed INTEGER DEFAULT 0,
    position INTEGER NOT NULL,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: teams
CREATE TABLE teams (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL,
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,
    avatar_url TEXT,
    color TEXT,
    is_private INTEGER DEFAULT 0,
    settings JSONB,
    created_by TEXT,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    UNIQUE(organization_id, slug)
);

-- Table: team_tokens
CREATE TABLE team_tokens (id TEXT PRIMARY KEY, user_id TEXT NOT NULL, token_hash TEXT NOT NULL, token_prefix TEXT NOT NULL, name TEXT NOT NULL, permissions TEXT NOT NULL, scopes TEXT, expires_at INTEGER, last_used_at INTEGER, created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT));

-- Table: team_workflows
CREATE TABLE team_workflows (
    id TEXT PRIMARY KEY,
    workflow_name TEXT NOT NULL,
    team_member TEXT NOT NULL, -- 'sam', 'connor', 'fred', 'amber'
    workflow_type TEXT, -- 'development', 'design', 'grant_writing', 'general'
    description TEXT,
    steps_json TEXT,
    estimated_time INTEGER,
    success_rate DOUBLE PRECISION,
    quality_score INTEGER,
    last_used TIMESTAMPTZ,
    use_count INTEGER DEFAULT 0,
    prevents_redundancy BOOLEAN DEFAULT TRUE, -- Does this prevent redundant work?
    embedding_json TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: theme_configs
CREATE TABLE theme_configs (
                        id SERIAL PRIMARY KEY,
                        name TEXT NOT NULL UNIQUE,
                        theme_type TEXT NOT NULL,
                        config_json TEXT NOT NULL,
                        description TEXT,
                        is_active INTEGER DEFAULT 0,
                        created_at TIMESTAMPTZ DEFAULT NOW(),
                        updated_at TIMESTAMPTZ DEFAULT NOW()
                    );

-- Table: time_entries
CREATE TABLE time_entries (
    id TEXT PRIMARY KEY,
    started_at INTEGER NOT NULL,
    ended_at INTEGER,
    seconds INTEGER,
    cost_usd DOUBLE PRECISION,
    note TEXT
);

-- Table: time_logs
CREATE TABLE time_logs (
          id TEXT PRIMARY KEY DEFAULT (gen_random_uuid()::text),
          team_member_id TEXT NOT NULL,
          project_id TEXT,
          task_description TEXT NOT NULL,
          start_time TEXT NOT NULL,
          end_time TEXT,
          duration_minutes INTEGER,
          billable BOOLEAN DEFAULT FALSE,
          category TEXT,
          notes TEXT,
          created_at TEXT DEFAULT NOW(),
          updated_at TEXT DEFAULT NOW()
        );

-- Table: time_sessions
CREATE TABLE time_sessions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    project_id TEXT,
    started_at INTEGER NOT NULL,
    ended_at INTEGER,
    duration_seconds INTEGER,
    auto_clocked INTEGER DEFAULT 1,
    notes TEXT
);

-- Table: tnr_requests
CREATE TABLE tnr_requests (
  id SERIAL PRIMARY KEY,
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
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: token_usage
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
    estimated_cost DOUBLE PRECISION DEFAULT 0.0,
    request_type TEXT,
    timestamp INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: user_preferences
CREATE TABLE user_preferences (
  userId TEXT PRIMARY KEY,
  theme TEXT DEFAULT 'light', -- 'light', 'dark', 'auto'
  notifications INTEGER DEFAULT 1,
  emailNotifications INTEGER DEFAULT 1,
  preferences TEXT -- JSONB for additional preferences
);

-- Table: users
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
    metadata JSONB,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
, company_email TEXT, inneranimal_email TEXT, iautodidact_app_email TEXT, iautodidact_org_email TEXT, innerautodidact_email TEXT, meauxxx_email TEXT);

-- Table: user_sessions
CREATE TABLE user_sessions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    token TEXT UNIQUE NOT NULL,
    ip_address TEXT,
    user_agent TEXT,
    expires_at INTEGER NOT NULL,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: user_time_tracking
CREATE TABLE user_time_tracking (
    id TEXT PRIMARY KEY,
    team_member TEXT NOT NULL,
    project_id TEXT,
    project_name TEXT,
    task_description TEXT,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    duration_minutes INTEGER,
    status TEXT DEFAULT 'active', -- active, completed, paused
    category TEXT, -- development, design, grant-writing, research, etc.
    tags TEXT, -- JSONB array of tags
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: visions
CREATE TABLE visions (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  success_criteria TEXT,
  target_date TEXT,
  created_at TEXT DEFAULT NOW(),
  updated_at TEXT DEFAULT NOW()
);

-- Table: wallet_transactions
CREATE TABLE wallet_transactions (
    id TEXT PRIMARY KEY,
    type TEXT NOT NULL, -- income, expense
    amount DOUBLE PRECISION NOT NULL,
    description TEXT,
    category TEXT,
    date TEXT DEFAULT NOW(),
    created_at TEXT DEFAULT NOW()
);

-- Table: weekly_spend_reports
CREATE TABLE weekly_spend_reports (
    id TEXT PRIMARY KEY,
    week_start TEXT NOT NULL,
    week_end TEXT NOT NULL,
    total_cost DOUBLE PRECISION NOT NULL,
    breakdown TEXT NOT NULL,
    optimization_tips TEXT,
    sent_at INTEGER,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: worker_logs
CREATE TABLE worker_logs (
  id SERIAL PRIMARY KEY,
  worker_name TEXT NOT NULL,
  level TEXT NOT NULL CHECK (level IN ('info', 'warning', 'error', 'debug')),
  message TEXT NOT NULL,
  data TEXT, -- JSONB object as text
  created_at TEXT DEFAULT NOW()
);

-- Table: worker_stats
CREATE TABLE worker_stats (
    id SERIAL PRIMARY KEY,
    worker_id TEXT NOT NULL UNIQUE,
    worker_name TEXT NOT NULL,
    url TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'active',
    category TEXT,
    total_requests INTEGER DEFAULT 0,
    last_request_at TEXT,
    created_at TEXT DEFAULT NOW(),
    updated_at TEXT DEFAULT NOW()
);

-- Table: workflow_analytics
CREATE TABLE workflow_analytics (
    id TEXT PRIMARY KEY,
    project_id TEXT,
    task_type TEXT, -- code-generation, grant-writing, research, etc.
    prompt_template TEXT, -- Template or pattern used
    prompt_variant TEXT, -- Variant identifier
    total_uses INTEGER DEFAULT 0,
    total_cost DOUBLE PRECISION DEFAULT 0,
    total_tokens INTEGER DEFAULT 0,
    avg_cost_per_use DOUBLE PRECISION,
    avg_tokens_per_use DOUBLE PRECISION,
    success_rate DOUBLE PRECISION, -- 0-1
    avg_quality_score DOUBLE PRECISION, -- 0-1
    best_result_id TEXT, -- ID of best result
    worst_result_id TEXT, -- ID of worst result
    improvement_suggestions TEXT, -- JSONB array
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: workflow_optimizations
CREATE TABLE workflow_optimizations (
    id TEXT PRIMARY KEY,
    workflow_id TEXT,
    workflow_type TEXT,
    original_workflow TEXT, -- Original workflow description
    optimized_workflow TEXT, -- AI-optimized version
    improvements_json TEXT, -- JSONB: {time_saved, quality_improvement, steps_removed, etc.}
    quality_score_before INTEGER,
    quality_score_after INTEGER,
    optimized_by TEXT, -- 'rag_system', 'sam', 'connor', etc.
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table: work_sessions
CREATE TABLE work_sessions (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    project_id TEXT, -- Links to projects table
    worker_name TEXT, -- Cloudflare Worker name
    time_minutes INTEGER NOT NULL DEFAULT 0,
    spend DOUBLE PRECISION DEFAULT 0, -- Cost/spend in dollars
    notes TEXT,
    created_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT),
    updated_at INTEGER DEFAULT (EXTRACT(EPOCH FROM NOW())::BIGINT)
);

-- Table: workstations
CREATE TABLE workstations (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    hostname TEXT,
    platform TEXT NOT NULL,
    location TEXT,
    last_synced_at TEXT,
    sync_enabled BOOLEAN DEFAULT TRUE,
    sync_frequency TEXT DEFAULT 'hourly',
    projects_tracked TEXT,
    local_storage_path TEXT,
    local_storage_size_bytes INTEGER DEFAULT 0,
    description TEXT,
    created_at TEXT DEFAULT NOW(),
    updated_at TEXT DEFAULT NOW()
);

