#!/bin/bash
# D1 Full Backup to R2 Script
# Creates a complete JSON backup of all D1 tables

CLOUDFLARE_ACCOUNT="ede6590ac0d2fb7daf155b35653457b2"
D1_DATABASE="d8261777-9384-44f7-924d-c92247d55b46"
CLOUDFLARE_API_TOKEN="${CLOUDFLARE_API_TOKEN:-meHW2uHn0LohFAEO6nMPWlfJ8L46cUwPOJuJRPB1}"
R2_BUCKET="allinfrastructure"
BACKUP_PREFIX="backups"

echo "🔄 Creating D1 Backup..."
backup_date=$(date -u +"%Y-%m-%d_%H-%M-%S")

# Get all tables
tables=$(curl -s "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT/d1/database/$D1_DATABASE/query" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"sql": "SELECT name FROM sqlite_master WHERE type=\"table\" AND name NOT LIKE \"sqlite_%\" AND name NOT LIKE \"_cf%\";"}' | jq -r '.result[0].results[].name')

# Create backup JSON
backup_file="/tmp/d1-backup-$backup_date.json"
echo "{\"backup_date\": \"$backup_date\", \"tables\": {" > "$backup_file"

first=true
for table in $tables; do
    data=$(curl -s "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT/d1/database/$D1_DATABASE/query" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{\"sql\": \"SELECT * FROM $table;\"}" | jq -c '.result[0].results // []')
    
    if [ "$first" = true ]; then
        first=false
    else
        echo "," >> "$backup_file"
    fi
    echo "\"$table\": $data" >> "$backup_file"
done

echo "}}" >> "$backup_file"

# Upload to R2
echo "📤 Uploading to R2..."
curl -s -X PUT "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT/r2/buckets/$R2_BUCKET/objects/$BACKUP_PREFIX/d1-meauxos-$backup_date.json" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data-binary "@$backup_file" | jq '.success'

echo "✅ Backup saved: $R2_BUCKET/$BACKUP_PREFIX/d1-meauxos-$backup_date.json"

# Cleanup
rm -f "$backup_file"
