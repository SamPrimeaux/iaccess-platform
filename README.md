# iaccess-platform

Multi-page HTML deployment with Cloudflare Workers + GitHub Pages.

## 🚀 Quick Start

```bash
# Deploy to Cloudflare Workers (dev)
npm run deploy:dev

# Deploy to Cloudflare Workers (production)
npm run deploy:prod

# Deploy to GitHub Pages (preview)
npm run deploy:github

# Local preview
npm run preview
```

## 🌐 Live URLs

### Cloudflare Workers
- **Dev**: https://iaccess-platform-dev.meauxbility.workers.dev
- **Production**: https://iaccess-platform.meauxbility.workers.dev

### GitHub Pages
- **Preview**: https://SamPrimeaux.github.io/iaccess-platform/

## 📁 Pages

- `iaccess-dashboard.html` → `/` (index)
- `iaccess-ai-gateway.html` → `/iaccess-ai-gateway`
- `iaccess-browser-rendering.html` → `/iaccess-browser-rendering`

## 🔄 Workflow

1. **Develop**: Edit HTML files in `public/`
2. **Preview**: `npm run deploy:github` → See on GitHub Pages
3. **Deploy**: `npm run deploy:prod` → Push to production

## 📝 Notes

- HTML files go in `public/` directory
- Worker automatically routes based on filename
- GitHub Pages serves static files from root
- Cloudflare Workers serves via routing logic
