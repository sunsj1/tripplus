# Data safety form — JourneyPlus

Answers for **Play Console → Policy → App content → Data safety**.  
Must match hosted privacy policy (`docs/legal/privacy_policy.html`).

---

## Does your app collect or share user data?

**Yes** — collects data. Does **not** sell data.

---

## Data types

### Personal info

| Type | Collected | Shared | Ephemeral | Required | Purpose |
|------|-----------|--------|-----------|----------|---------|
| Email address | Yes | No* | No | Yes (for sign-in) | Account management |
| Name | Yes | No* | No | Yes (for sign-in) | Account management |
| User IDs | Yes | No* | No | Yes | Account management |

\*Processed by Firebase/Google as service providers under your privacy policy; not sold to third parties for advertising.

### Location

| Type | Collected | Shared | Ephemeral | Required | Purpose |
|------|-----------|--------|-----------|----------|---------|
| Precise location | Yes | Yes** | Yes*** | No | App functionality (active trip alerts, maps) |
| Approximate location | Yes | Yes** | Yes*** | No | App functionality |

\*\*Sent to Google Maps Platform during planning/driving sessions per Google terms.  
\*\*\*Not stored on JourneyPlus servers as a location history; used in session.

### Photos and videos

| Type | Collected | Shared | Ephemeral | Required | Purpose |
|------|-----------|--------|-----------|----------|---------|
| Photos | Yes (optional) | No | No | No | User-generated content (community reports) |

### App activity

| Type | Collected | Shared | Ephemeral | Required | Purpose |
|------|-----------|--------|-----------|----------|---------|
| Crash logs | Yes | No* | No | No | Analytics (stability via Crashlytics) |

---

## Security practices

- Data encrypted in transit: **Yes**
- Users can request data deletion: **Yes** (email surajjadhav1065@gmail.com)
- Committed to Play Families Policy: **N/A** (not child-directed)

---

## Foreground service (separate declaration)

**Type:** Location  
**Use case:** Foreground location while user has an **active trip** for predictive highway alerts.  
**User disclosure:** In-app permission rationale + privacy policy.

---

## Permissions declared in app

- `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION`
- `FOREGROUND_SERVICE` / `FOREGROUND_SERVICE_LOCATION`
- `POST_NOTIFICATIONS`
- `CAMERA` (optional community report photo from camera; gallery uses system photo picker)
- `INTERNET`

---

## What we do NOT collect

- GPS movement trails / location history on JourneyPlus servers
- Contacts, SMS, call logs
- Financial or health data
