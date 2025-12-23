// MeauxOS Dashboard Worker - Serves static assets + API

interface Env {
  ASSETS: Fetcher;
  DB: D1Database;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    // CORS headers
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

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
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json'
  };

  try {
    // Analytics overview
    if (path === '/api/analytics/overview') {
      let stats = { projects: 0, teamMembers: 0, assets: 0 };
      
      try {
        const result = await env.DB.prepare(`
          SELECT 
            (SELECT COUNT(*) FROM projects) as projects,
            (SELECT COUNT(*) FROM team_members) as teamMembers,
            (SELECT COUNT(*) FROM assets) as assets
        `).first();
        if (result) stats = result as any;
      } catch (e) {
        // Tables might not exist
      }

      return new Response(JSON.stringify({
        success: true,
        data: stats
      }), { headers: corsHeaders });
    }

    // Tasks
    if (path === '/api/tasks') {
      try {
        const { results } = await env.DB.prepare('SELECT * FROM tasks ORDER BY created_at DESC LIMIT 50').all();
        return new Response(JSON.stringify({ success: true, data: results }), { headers: corsHeaders });
      } catch (e) {
        return new Response(JSON.stringify({ success: true, data: [] }), { headers: corsHeaders });
      }
    }

    // Modules
    if (path === '/api/modules') {
      try {
        const { results } = await env.DB.prepare('SELECT * FROM apps ORDER BY name').all();
        return new Response(JSON.stringify({ success: true, data: results }), { headers: corsHeaders });
      } catch (e) {
        return new Response(JSON.stringify({ success: true, data: [] }), { headers: corsHeaders });
      }
    }

    return new Response(JSON.stringify({ error: 'Not found' }), { status: 404, headers: corsHeaders });
  } catch (error) {
    return new Response(JSON.stringify({ 
      error: 'Database error', 
      message: error instanceof Error ? error.message : 'Unknown error'
    }), { status: 500, headers: corsHeaders });
  }
}
