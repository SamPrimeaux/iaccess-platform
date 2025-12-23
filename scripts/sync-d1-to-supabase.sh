#!/bin/bash
# D1 to Supabase Sync Script
# Usage: ./sync-d1-to-supabase.sh [table_name]
# If no table specified, syncs all critical tables

CLOUDFLARE_ACCOUNT="ede6590ac0d2fb7daf155b35653457b2"
D1_DATABASE="d8261777-9384-44f7-924d-c92247d55b46"
CLOUDFLARE_API_TOKEN="${CLOUDFLARE_API_TOKEN:-meHW2uHn0LohFAEO6nMPWlfJ8L46cUwPOJuJRPB1}"
SUPABASE_URL="https://qmpghmthbhuumemnahcz.supabase.co"
SUPABASE_KEY="${SUPABASE_SERVICE_KEY:-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtcGdobXRoYmh1dW1lbW5haGN6Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjM0ODQ1MiwiZXhwIjoyMDgxOTI0NDUyfQ.GrGosRjddbb-PbLMmhotxFWG4xIUEjV1iU2Nwk-5xOU}"

CRITICAL_TABLES="organizations projects r2_buckets r2_objects agent_configs kanban_tasks kanban_boards kanban_columns users cloudflare_projects team_members ai_knowledge_base"

sync_table() {
    local table=$1
    echo "📊 Syncing $table..."
    
    # Fetch from D1
    data=$(curl -s "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT/d1/database/$D1_DATABASE/query" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{\"sql\": \"SELECT * FROM $table;\"}" | jq '.result[0].results')
    
    count=$(echo "$data" | jq 'length')
    
    if [ "$count" -gt 0 ]; then
        # Upsert to Supabase
        result=$(curl -s -X POST "$SUPABASE_URL/rest/v1/$table" \
            -H "apikey: $SUPABASE_KEY" \
            -H "Content-Type: application/json" \
            -H "Prefer: resolution=merge-duplicates,return=minimal" \
            -d "$data")
        
        if [ -z "$result" ]; then
            echo "   ✅ Synced $count rows"
        else
            echo "   ⚠️ Error: $result"
        fi
    else
        echo "   ⏭️ No data to sync"
    fi
}

if [ -n "$1" ]; then
    sync_table "$1"
else
    echo "🔄 Syncing all critical tables..."
    for table in $CRITICAL_TABLES; do
        sync_table "$table"
    done
    echo "✅ Sync complete!"
fi
