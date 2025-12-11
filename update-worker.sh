#!/bin/bash
node -e "
const fs = require('fs');
const path = require('path');

// Read all HTML files in public/
const publicDir = 'public';
const files = fs.readdirSync(publicDir).filter(f => f.endsWith('.html'));

const htmlFiles = {};
const routes = {};

files.forEach(file => {
  const html = fs.readFileSync(path.join(publicDir, file), 'utf8');
  htmlFiles[file] = JSON.stringify(html);
  
  // Map routes
  if (file === 'index.html') {
    routes['/'] = 'index.html';
  } else {
    const route = '/' + file.replace('.html', '');
    routes[route] = file;
  }
});

// Generate Worker
const worker = '// Multi-page Worker with routing\n' +
  'const ROUTES = ' + JSON.stringify(routes) + ';\n\n' +
  'const HTML_FILES = {\n' +
  Object.entries(htmlFiles).map(([file, content]) => 
    \`  '\${file}': \${content}\`
  ).join(',\n') +
  '};\n\n' +
  'export default {\n' +
  '  async fetch(request: Request): Promise<Response> {\n' +
  '    const url = new URL(request.url);\n' +
  '    let path = url.pathname;\n' +
  '    \n' +
  '    if (path !== \"/\" && path.endsWith(\"/\")) {\n' +
  '      path = path.slice(0, -1);\n' +
  '    }\n' +
  '    \n' +
  '    let htmlFile = ROUTES[path] || ROUTES[\"/\"] || \"index.html\";\n' +
  '    \n' +
  '    if (path.endsWith(\".html\")) {\n' +
  '      htmlFile = path.substring(1);\n' +
  '    }\n' +
  '    \n' +
  '    const html = HTML_FILES[htmlFile];\n' +
  '    \n' +
  '    if (!html) {\n' +
  '      return new Response(\"Page not found\", { status: 404 });\n' +
  '    }\n' +
  '    \n' +
  '    return new Response(html, {\n' +
  '      headers: {\n' +
  '        \"Content-Type\": \"text/html; charset=utf-8\",\n' +
  '        \"Cache-Control\": \"public, max-age=3600\",\n' +
  '      },\n' +
  '    });\n' +
  '  },\n' +
  '};\n';

fs.writeFileSync('src/index.ts', worker);
console.log('✅ Worker updated with', files.length, 'pages');
"
