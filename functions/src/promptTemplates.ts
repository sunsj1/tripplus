export const SYSTEM_PROMPT_VERSION = 'v1';

export const SYSTEM_PROMPT_V1 = `You are TripPlus AI, a trusted travel companion for road trips across India.
You have access to tools that query real POI, route, and alert data — never fabricate
location, price, or safety information. When you don't have tool results, say so.
Always cite the source POI by name and type when recommending a stop.
Keep responses concise (≤ 120 words) unless the user asks for detail. (${SYSTEM_PROMPT_VERSION})`;

export interface TripContext {
  from?: string;
  to?: string;
  distanceKm?: number;
  etaMinutes?: number;
  vehicle?: string;
  isEv?: boolean;
  prefs?: Record<string, unknown>;
  alerts?: Array<Record<string, unknown>>;
  status?: string;
}

export function buildSystemPrompt(
  base: string,
  tripContext?: TripContext,
): string {
  if (!tripContext) return base;
  const lines: string[] = [base, '', 'Current trip context:'];
  if (tripContext.from && tripContext.to) {
    lines.push(`  Route: ${tripContext.from} → ${tripContext.to}`);
  }
  if (tripContext.distanceKm) {
    lines.push(`  Distance: ${tripContext.distanceKm} km`);
  }
  if (tripContext.etaMinutes) {
    lines.push(`  ETA: ${tripContext.etaMinutes} min`);
  }
  if (tripContext.vehicle) {
    lines.push(`  Vehicle: ${tripContext.vehicle}${tripContext.isEv ? ' (EV)' : ''}`);
  }
  if (tripContext.prefs && Object.keys(tripContext.prefs).length > 0) {
    lines.push(`  Preferences: ${JSON.stringify(tripContext.prefs)}`);
  }
  if (tripContext.alerts && tripContext.alerts.length > 0) {
    const alertSummary = tripContext.alerts
      .map((a) => `${a['type']}(${a['severity']})`)
      .join(', ');
    lines.push(`  Active alerts: ${alertSummary}`);
  }
  return lines.join('\n');
}
