#!/bin/bash
set -e

ENV=${1:-dev}

echo "🚀 Deploying to Cloudflare ($ENV)..."

if [ -f "package.json" ] && [ ! -d "node_modules" ]; then
  echo "📦 Installing dependencies..."
  npm install
fi

# Regenerate worker with latest HTML files
./update-worker.sh

if [ "$ENV" = "production" ]; then
  wrangler deploy --env production
  echo "✅ Deployed to production"
  echo "🌐 https://$REPO_NAME.meauxbility.workers.dev"
else
  wrangler deploy --env dev
  echo "✅ Deployed to dev"
  echo "🌐 https://$REPO_NAME-dev.meauxbility.workers.dev"
fi
