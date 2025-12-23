// MeauxOS Dashboard Worker - Full SaaS API
// Connected to all D1 databases and R2 buckets

interface Env {
  // Static Assets
  ASSETS: Fetcher;
  
  // R2 Buckets
  R2_INFRASTRUCTURE: R2Bucket;
  R2_IMAGES: R2Bucket;
  R2_APPS: R2Bucket;
  
  // D1 Databases
  DB: D1Database;                    // meauxos
  DASHBOARD_DB: D1Database;          // meauxbility-dashboard-db
  SAAS_DB: D1Database;               // hybridprosaas-db
  MEAUXSTACK_DB: D1Database;         // meauxstack-saas-db
  MEAUXWORK_DB: D1Database;          // meauxwork-db
  MEAUX_WORK_DB: D1Database;         // meaux-work-db
  MEAUXPHOTO_DB: D1Database;         // meauxphoto-db
  MEAUXACCESS_DB: D1Database;        // meauxaccess-db
  MEAUXBILITYORG_DB: D1Database;     // meauxbilityorg
  MEAUXMARKETS_DB: D1Database;       // meauxmarkets_dev
  INNERANIMAL_DB: D1Database;        // inneranimalmedia
  INNERANIMAL_ASSETS_DB: D1Database; // inneranimalmedia-assets
  INNERANIMAL_LIBRARY_DB: D1Database;// inneranimalmedia_app_library
  SOUTHERNPETS_DB: D1Database;       // southernpetsanimalrescue
  
  // Environment Variables
  ENVIRONMENT: string;
  API_VERSION: string;
  DASHBOARD_NAME: string;
}

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    // API routes
    if (path.startsWith('/api/')) {
      return handleAPI(request, env, path);
    }

    // Serve static assets
    return env.ASSETS.fetch(request);
  }
};

async function handleAPI(request: Request, env: Env, path: string): Promise<Response> {
  const headers = { ...corsHeaders, 'Content-Type': 'application/json' };

  try {
    // ═══════════════════════════════════════════════════════════════
    // SYSTEM INFO
    // ═══════════════════════════════════════════════════════════════
    
    if (path === '/api/system/info') {
      return jsonResponse({
        success: true,
        data: {
          name: env.DASHBOARD_NAME,
          version: env.API_VERSION,
          environment: env.ENVIRONMENT,
          databases: 14,
          r2Buckets: 3
        }
      }, headers);
    }

    // ═══════════════════════════════════════════════════════════════
    // ANALYTICS OVERVIEW
    // ═══════════════════════════════════════════════════════════════
    
    if (path === '/api/analytics/overview') {
      const stats = {
        projects: 0,
        teamMembers: 0,
        assets: 0,
        tasks: 0,
        organizations: 5
      };

      try {
        // Count from various databases
        const [projectsRes, teamRes, tasksRes] = await Promise.all([
          safeQuery(env.DB, 'SELECT COUNT(*) as count FROM projects'),
          safeQuery(env.DASHBOARD_DB, 'SELECT COUNT(*) as count FROM team_members'),
          safeQuery(env.MEAUXWORK_DB, 'SELECT COUNT(*) as count FROM tasks')
        ]);

        stats.projects = projectsRes?.count || 0;
        stats.teamMembers = teamRes?.count || 0;
        stats.tasks = tasksRes?.count || 0;
      } catch (e) {
        // Use defaults
      }

      return jsonResponse({ success: true, data: stats }, headers);
    }

    // ═══════════════════════════════════════════════════════════════
    // TEAM MEMBERS
    // ═══════════════════════════════════════════════════════════════
    
    if (path === '/api/team/members') {
      try {
        const { results } = await env.DASHBOARD_DB.prepare(
          'SELECT * FROM team_members ORDER BY created_at DESC'
        ).all();
        return jsonResponse({ success: true, data: results || [] }, headers);
      } catch (e) {
        return jsonResponse({ success: true, data: [] }, headers);
      }
    }

    // ═══════════════════════════════════════════════════════════════
    // TASKS / MEAUXWORK
    // ═══════════════════════════════════════════════════════════════
    
    if (path === '/api/tasks' || path === '/api/meauxwork/tasks') {
      try {
        const { results } = await env.MEAUXWORK_DB.prepare(
          'SELECT * FROM tasks ORDER BY created_at DESC LIMIT 100'
        ).all();
        return jsonResponse({ success: true, data: results || [] }, headers);
      } catch (e) {
        return jsonResponse({ success: true, data: [] }, headers);
      }
    }

    // ═══════════════════════════════════════════════════════════════
    // PROJECTS
    // ═══════════════════════════════════════════════════════════════
    
    if (path === '/api/projects') {
      try {
        const { results } = await env.DB.prepare(
          'SELECT * FROM projects ORDER BY created_at DESC'
        ).all();
        return jsonResponse({ success: true, data: results || [] }, headers);
      } catch (e) {
        return jsonResponse({ success: true, data: [] }, headers);
      }
    }

    // ═══════════════════════════════════════════════════════════════
    // R2 STORAGE - LIST OBJECTS
    // ═══════════════════════════════════════════════════════════════
    
    if (path === '/api/storage/infrastructure') {
      const listed = await env.R2_INFRASTRUCTURE.list({ limit: 100 });
      return jsonResponse({
        success: true,
        data: {
          objects: listed.objects.map(obj => ({
            key: obj.key,
            size: obj.size,
            uploaded: obj.uploaded
          })),
          truncated: listed.truncated
        }
      }, headers);
    }

    if (path === '/api/storage/images') {
      const listed = await env.R2_IMAGES.list({ limit: 100 });
      return jsonResponse({
        success: true,
        data: {
          objects: listed.objects.map(obj => ({
            key: obj.key,
            size: obj.size,
            uploaded: obj.uploaded
          })),
          truncated: listed.truncated,
          count: listed.objects.length
        }
      }, headers);
    }

    if (path === '/api/storage/apps') {
      const listed = await env.R2_APPS.list({ limit: 100 });
      return jsonResponse({
        success: true,
        data: {
          objects: listed.objects.map(obj => ({
            key: obj.key,
            size: obj.size,
            uploaded: obj.uploaded
          })),
          truncated: listed.truncated
        }
      }, headers);
    }

    // ═══════════════════════════════════════════════════════════════
    // R2 BACKUP - SAVE DASHBOARD HTML
    // ═══════════════════════════════════════════════════════════════
    
    if (path === '/api/backup/dashboard' && request.method === 'POST') {
      const body = await request.text();
      const key = `meauxos-dashboard/index-${Date.now()}.html`;
      
      await env.R2_INFRASTRUCTURE.put(key, body, {
        httpMetadata: { contentType: 'text/html' }
      });

      // Also update the main file
      await env.R2_INFRASTRUCTURE.put('meauxos-dashboard/index.html', body, {
        httpMetadata: { contentType: 'text/html' }
      });

      return jsonResponse({
        success: true,
        message: 'Dashboard backed up to R2',
        key
      }, headers);
    }

    // ═══════════════════════════════════════════════════════════════
    // MEAUXPHOTO - IMAGES
    // ═══════════════════════════════════════════════════════════════
    
    if (path === '/api/photos/list') {
      const listed = await env.R2_IMAGES.list({ limit: 200 });
      const images = listed.objects
        .filter(obj => /\.(jpg|jpeg|png|gif|webp|svg)$/i.test(obj.key))
        .map(obj => ({
          key: obj.key,
          size: obj.size,
          uploaded: obj.uploaded,
          url: `/api/photos/image/${encodeURIComponent(obj.key)}`
        }));

      return jsonResponse({
        success: true,
        data: images,
        count: images.length
      }, headers);
    }

    if (path.startsWith('/api/photos/image/')) {
      const key = decodeURIComponent(path.replace('/api/photos/image/', ''));
      const object = await env.R2_IMAGES.get(key);
      
      if (!object) {
        return new Response('Not found', { status: 404 });
      }

      const imgHeaders = new Headers();
      object.writeHttpMetadata(imgHeaders);
      imgHeaders.set('etag', object.httpEtag);
      imgHeaders.set('Cache-Control', 'public, max-age=86400');

      return new Response(object.body, { headers: imgHeaders });
    }

    // ═══════════════════════════════════════════════════════════════
    // SAAS MODULES
    // ═══════════════════════════════════════════════════════════════
    
    if (path === '/api/modules') {
      const modules = [
        { id: 'meauxwork', name: 'MeauxWork', slug: 'mx-wk', category: 'productivity', status: 'live', icon: 'clipboard' },
        { id: 'meauxstats', name: 'MeauxStats', slug: 'mx-st', category: 'productivity', status: 'live', icon: 'chart' },
        { id: 'meauxteam', name: 'MeauxTeam', slug: 'mx-tm', category: 'productivity', status: 'live', icon: 'users' },
        { id: 'meauxdoc', name: 'MeauxDOC', slug: 'mx-dc', category: 'productivity', status: 'live', icon: 'file' },
        { id: 'meauxphoto', name: 'MeauxPHOTO', slug: 'mx-ph', category: 'media', status: 'live', icon: 'image' },
        { id: 'meauxmemories', name: 'MeauxMemories', slug: 'mx-mm', category: 'media', status: 'live', icon: 'grid' },
        { id: 'meauxmedia', name: 'MeauxMedia', slug: 'mx-md', category: 'media', status: 'live', icon: 'video' },
        { id: 'meauxcloud', name: 'MeauxCloud', slug: 'mx-cl', category: 'infrastructure', status: 'live', icon: 'cloud' },
        { id: 'meauxcad', name: 'MeauxCAD', slug: 'mx-cd', category: 'design', status: 'live', icon: 'layers' },
        { id: 'meauxai', name: 'MeauxAI', slug: 'mx-ai', category: 'ai-ml', status: 'live', icon: 'cpu' },
        { id: 'meauxstack', name: 'MeauxStack', slug: 'mx-sk', category: 'dev-tools', status: 'live', icon: 'code' },
        { id: 'meauxmarkets', name: 'MeauxMarkets', slug: 'mx-mk', category: 'business', status: 'live', icon: 'shopping' }
      ];
      
      return jsonResponse({ success: true, data: modules }, headers);
    }

    // ═══════════════════════════════════════════════════════════════
    // DATABASE STATUS
    // ═══════════════════════════════════════════════════════════════
    
    if (path === '/api/databases/status') {
      const databases = [
        { name: 'meauxos', binding: 'DB' },
        { name: 'meauxbility-dashboard-db', binding: 'DASHBOARD_DB' },
        { name: 'hybridprosaas-db', binding: 'SAAS_DB' },
        { name: 'meauxstack-saas-db', binding: 'MEAUXSTACK_DB' },
        { name: 'meauxwork-db', binding: 'MEAUXWORK_DB' },
        { name: 'meaux-work-db', binding: 'MEAUX_WORK_DB' },
        { name: 'meauxphoto-db', binding: 'MEAUXPHOTO_DB' },
        { name: 'meauxaccess-db', binding: 'MEAUXACCESS_DB' },
        { name: 'meauxbilityorg', binding: 'MEAUXBILITYORG_DB' },
        { name: 'meauxmarkets_dev', binding: 'MEAUXMARKETS_DB' },
        { name: 'inneranimalmedia', binding: 'INNERANIMAL_DB' },
        { name: 'inneranimalmedia-assets', binding: 'INNERANIMAL_ASSETS_DB' },
        { name: 'inneranimalmedia_app_library', binding: 'INNERANIMAL_LIBRARY_DB' },
        { name: 'southernpetsanimalrescue', binding: 'SOUTHERNPETS_DB' }
      ];

      return jsonResponse({
        success: true,
        data: {
          databases,
          count: databases.length,
          status: 'connected'
        }
      }, headers);
    }

    // ═══════════════════════════════════════════════════════════════
    // CATCH ALL
    // ═══════════════════════════════════════════════════════════════
    
    return jsonResponse({
      error: 'Not found',
      path,
      availableEndpoints: [
        '/api/system/info',
        '/api/analytics/overview',
        '/api/team/members',
        '/api/tasks',
        '/api/projects',
        '/api/modules',
        '/api/databases/status',
        '/api/storage/infrastructure',
        '/api/storage/images',
        '/api/storage/apps',
        '/api/photos/list',
        '/api/backup/dashboard (POST)'
      ]
    }, headers, 404);

  } catch (error) {
    return jsonResponse({
      error: 'Internal server error',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, headers, 500);
  }
}

// Helper functions
function jsonResponse(data: any, headers: Record<string, string>, status = 200): Response {
  return new Response(JSON.stringify(data, null, 2), {
    status,
    headers
  });
}

async function safeQuery(db: D1Database, sql: string): Promise<any> {
  try {
    return await db.prepare(sql).first();
  } catch {
    return null;
  }
}
