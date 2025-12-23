#!/bin/bash
# Upload training documents to R2 for AutoRAG
# Usage: ./scripts/upload-to-autorag.sh

# R2 Configuration
BUCKET="autorag-meauxbility-chatbot"
ACCOUNT_ID="ede6590ac0d2fb7daf155b35653457b2"
R2_ENDPOINT="https://${ACCOUNT_ID}.r2.cloudflarestorage.com"

echo "📚 Uploading training documents to R2 AutoRAG bucket..."

# Check for AWS CLI
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Install with: pip install awscli"
    echo ""
    echo "Then configure R2 credentials:"
    echo "  aws configure --profile r2"
    echo ""
    echo "Use your R2 API Token from Cloudflare Dashboard > R2 > Manage R2 API Tokens"
    exit 1
fi

# Upload training documents
cd "$(dirname "$0")/../autorag-training"

for file in *.md *.json; do
    if [ -f "$file" ]; then
        echo "📄 Uploading $file..."
        aws s3 cp "$file" "s3://${BUCKET}/training-docs/$file" \
            --endpoint-url "$R2_ENDPOINT" \
            --profile r2
    fi
done

echo ""
echo "✅ Upload complete!"
echo ""
echo "AutoRAG Bucket Details:"
echo "  Public URL: https://pub-af210afb024f460fac3f40e94c00f1ee.r2.dev"
echo "  S3 Endpoint: ${R2_ENDPOINT}/${BUCKET}"
echo "  Catalog URI: https://catalog.cloudflarestorage.com/${ACCOUNT_ID}/${BUCKET}"
