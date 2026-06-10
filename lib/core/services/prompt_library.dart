/// P3-003 — Versioned prompt templates.
///
/// Local constants are the source of truth and offline fallback. Remote Config
/// can override [system] and individual intent templates at runtime — wire
/// `firebase_remote_config` here when that package is added.
class PromptLibrary {
  const PromptLibrary._();

  static const String kVersion = 'v1';

  // ── System prompt ──────────────────────────────────────────────────────────

  static const String system = '''
You are TripPlus AI, a trusted travel companion for road trips across India.
You have access to tools that query real POI, route, and alert data — never fabricate
location, price, or safety information. When you don't have tool results, say so.
Always cite the source POI by name and type when recommending a stop.
Keep responses concise (≤ 120 words) unless the user asks for detail. ($kVersion)''';

  // ── Intent-specific templates ──────────────────────────────────────────────

  static String findPoi({
    required String category,
    String? filter,
    double withinKm = 30,
  }) {
    final filterPart = filter != null ? '$filter ' : '';
    final kmStr = withinKm.toStringAsFixed(0);
    final filterArg = filter != null ? ', filter="$filter"' : '';
    return 'Find $filterPart$category stops within $kmStr km on my route. '
        'Use the find_poi tool with category="$category"$filterArg, withinKm=$kmStr.';
  }

  static String compareRoutes({String criteria = 'fastest'}) =>
      'Compare available route alternatives for criteria: $criteria. '
      'Use the compare_routes tool and summarise the trade-offs.';

  static const String narrateTrip =
      'Give me a spoken-style summary of my current trip plan in 3–4 sentences. '
      'Use the narrate_trip tool to get context first.';

  static const String generalQa =
      'Answer the user question using the trip context when relevant. '
      'If you need POI data, use the find_poi tool. Do not invent data.';

  // ── Quick-prompt chips (used by P3-012) ────────────────────────────────────

  static const List<QuickPrompt> quickPrompts = [
    QuickPrompt(
      label: 'Next charger',
      prompt: 'Where is the nearest EV charging station on my route?',
    ),
    QuickPrompt(
      label: 'Pure-veg food',
      prompt: 'Find a pure-vegetarian restaurant within the next 30 km.',
    ),
    QuickPrompt(
      label: 'Women-safe stop',
      prompt: 'Suggest a safe rest stop within 20 km suitable for women travellers.',
    ),
    QuickPrompt(
      label: 'Avoid bad roads',
      prompt: 'Are there any road-quality issues ahead? Suggest a better alternative if so.',
    ),
    QuickPrompt(
      label: 'Scenic point',
      prompt: 'Is there a scenic viewpoint or hidden gem near my current route?',
    ),
  ];
}

class QuickPrompt {
  const QuickPrompt({required this.label, required this.prompt});

  final String label;
  final String prompt;
}
