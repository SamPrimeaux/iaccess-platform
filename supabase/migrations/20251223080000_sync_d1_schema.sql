-- Add missing columns to r2_buckets
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS organization_id TEXT;
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS public_url TEXT;
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS total_size BIGINT DEFAULT 0;
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS object_count INTEGER DEFAULT 0;
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT FALSE;
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS custom_domain TEXT;
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'active';
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS binding TEXT;
ALTER TABLE r2_buckets ADD COLUMN IF NOT EXISTS creation_date TEXT;

-- Add missing columns to r2_objects
ALTER TABLE r2_objects ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT FALSE;
ALTER TABLE r2_objects ADD COLUMN IF NOT EXISTS public_url TEXT;

-- Add missing columns to cloudflare_projects
ALTER TABLE cloudflare_projects ADD COLUMN IF NOT EXISTS organization_id TEXT;

-- No changes needed for projects - it has all columns
