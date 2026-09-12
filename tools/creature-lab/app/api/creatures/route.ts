import { listRecentCreatures } from '@/lib/recent-creatures';

export const runtime = 'nodejs';

export async function GET() {
  const creatures = listRecentCreatures();
  return Response.json(
    { creatures },
    { headers: { 'Cache-Control': 'no-store' } },
  );
}
