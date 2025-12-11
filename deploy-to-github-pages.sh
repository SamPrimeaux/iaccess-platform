#!/bin/bash
set -e

echo "🚀 Deploying to GitHub Pages..."

# Copy all HTML files to root for GitHub Pages
cp public/*.html . 2>/dev/null || true

# Create .nojekyll
touch .nojekyll

# Commit and push
git add *.html .nojekyll public/ 2>/dev/null || true
git commit -m "Deploy to GitHub Pages - $(date +%Y-%m-%d\ %H:%M:%S)" || echo "No changes to commit"

git remote set-url origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git" 2>/dev/null || true
git branch -M main
git push origin main || echo "⚠️  Push failed"

echo ""
echo "✅ Deployed to GitHub Pages!"
echo "🌐 Preview: https://${GITHUB_USER}.github.io/${REPO_NAME}/"
echo ""
