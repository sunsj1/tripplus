# JourneyPlus — Privacy & Location Policy

**Last updated:** June 2026  
**App:** JourneyPlus (`com.journeyplus.journeyplus`)  
**Contact:** surajjadhav1065@gmail.com

---

## Our promise

JourneyPlus is a highway companion — not a location tracker. We help you plan routes and surface predictive stops using intelligence for your current drive. We do not build or sell a history of where you have been.

## Location on your device

When you start a trip, the app may read GPS on your phone to power predictive alerts (fuel gaps, food windows, chargers). That position is used in real time for calculations and Google Maps / Places requests during the session.

We do not upload GPS coordinates or location trails to JourneyPlus servers. Firebase stores your profile, preferences, and community reports — not your movement history.

## Google APIs

Routing, places, and corridor search use Google Maps Platform APIs. When you plan or drive, route queries and nearby-place lookups may send origin/destination or current position to Google under [Google's Privacy Policy](https://policies.google.com/privacy). JourneyPlus does not store those coordinates in our database.

## Trip history (on device)

When you end a trip, a summary is saved locally on your phone: city names (e.g. Mumbai → Pune), distance, duration, vehicle type, and alert counts. No GPS path is kept. Clearing app data removes this history.

## Community reports

If you submit a community pulse at a stop, we store the report on Firebase linked to that place's stable key — not a log of your location over time. Reports are immutable and publicly readable by other app users.

## Account & authentication

Sign-in uses Google Sign-In via Firebase Authentication. We receive your Google account identifier, email, and display name to create and maintain your account. You can sign out at any time from the app.

## Crash diagnostics

We use Firebase Crashlytics to collect crash logs and basic device information to improve app stability. Crash reports may include app version and device model.

## Data we collect (summary)

| Data | Purpose | Stored where |
|------|---------|--------------|
| Email, name (Google Sign-In) | Account | Firebase Auth / Firestore |
| Profile & preferences | Personalization | Firestore |
| Precise location (active trip only) | Predictive alerts, maps | On device + sent to Google APIs during session |
| Optional photos (community reports) | User-generated content | Firestore (inline on report document) |
| Crash logs | Stability | Firebase Crashlytics |

We do not sell your personal data.

## Your controls

- **Deny location permission** — planning still works; live alerts and foreground tracking are limited.
- **End trip anytime** — stops live location use for that session.
- **Sign out** — clears your session; profile data remains in Firebase until you request account deletion.
- **Uninstall** — removes on-device trip history and caches.

## Account deletion

To delete your Firebase account and associated profile data, email **surajjadhav1065@gmail.com** from the address linked to your account. We will process deletion requests within 30 days. Community reports you submitted remain as immutable public contributions (not linked to ongoing account access).

## Children

JourneyPlus is not directed at children under 13. We do not knowingly collect data from children.

## Changes

We may update this policy. The "Last updated" date at the top will change when we do. Continued use of the app after changes constitutes acceptance.

## Contact

Questions about privacy or location use: **surajjadhav1065@gmail.com**
