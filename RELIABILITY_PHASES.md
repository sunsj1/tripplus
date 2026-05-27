# Reliability UX Phases

## Phase 1 (implemented now)

1. **Confidence visibility in community**
   - Show sample size + freshness near rating.
   - Show low-confidence badge when reports are stale or too few.

2. **Silent-failure proofing (actionable states)**
   - Error taxonomy prefixes from repository: `network`, `permission`, `index`, `firestore`, `platform`.
   - Actionable submit feedback:
     - Permission issue -> "Open settings"
     - Network issue -> "Retry now"

3. **Offline-first pulse submit**
   - Local queue using Hive box `community_submit_queue`.
   - On network failure, report is stored locally and retried later.
   - Retry runner executes on controller boot and after successful actions.

4. **Station key fallback hardening**
   - Preserve existing UUID/id behavior.
   - Add normalized fallback for stations with missing ids to reduce key drift.

## Phase 2 (next, on your command)

1. **Report quality scoring** ✅
   - Weighted score by recency + reporter trust.
   - Replace plain average prominence with reliability score.

2. **Conflict-aware status timeline** ✅
   - Detect opposing recent pulses (working vs down).
   - Show compact timeline chips and "mixed status" warning.

3. **Last successful charge signal** ✅
   - Add `chargeSuccessful` boolean to report schema.
   - Highlight latest successful session timestamp.

4. **All pulses page enhancements** ✅
   - Filters: Latest, Reliable users, With photos, With price.
   - Pinned summary: median price + trend + reliability delta.

5. **Route/planning reliability** ✅
   - Risk-aware station cards in route output.
   - Backup stop suggestions + clearer gap mitigation actions.
   - Confidence badges by source (`Official`, `Community-verified`, `Unverified`).

6. **Telemetry** ✅ (lightweight logger hooks)
   - Track submit success/failure reasons, queue retry success, stale-data views, and conflict rate.

