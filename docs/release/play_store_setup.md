# Play Store setup — JourneyPlus

Step-by-step guide for publishing `com.journeyplus.journeyplus` on Google Play.

**Package / application ID:** `com.journeyplus.journeyplus` (permanent — cannot change)  
**Firebase project:** `tripplus-8aff2`  
**Version:** `1.0.1+5` → versionName `1.0.1`, versionCode `5`

---

## 1. One-time account

1. Register at [Google Play Console](https://play.google.com/console) ($25 one-time).
2. Complete identity verification.
3. Create app → name **JourneyPlus**, language **English (India)**, type **App**, **Free**.

---

## 2. Release signing (repo)

```bash
chmod +x android/scripts/generate_release_keystore.sh
./android/scripts/generate_release_keystore.sh
# Edit android/key.properties with your passwords (see key.properties.example)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**Firebase (required for Google Sign-In in production):**

1. Firebase Console → `tripplus-8aff2` → Project settings → Android app.
2. Add **SHA-1** and **SHA-256** from your **upload keystore** (`keytool -list -v -keystore android/journeyplus-release.keystore`).
3. After first Play upload, also add **App signing certificate** fingerprints from Play Console → Release → App integrity.

**Google Maps API key:** Restrict Android key to package `com.journeyplus.journeyplus` + release SHA-1.

---

## 3. Privacy policy URL

Play Console requires a **public HTTPS** URL.

- **Privacy:** https://www.journeyplus.in/privacy
- **Terms:** https://www.journeyplus.in/terms

The app loads these in a WebView (`LegalWebViewScreen`) — updates on the website reflect in-app without a new release.

---

## 4. Store listing

Copy from [`store_listing.md`](store_listing.md).

| Asset | Spec |
|-------|------|
| App icon | 512×512 PNG |
| Feature graphic | 1024×500 |
| Phone screenshots | Min 2 (recommend 4–8) |
| Category | Travel & Local |
| Contact email | `surajjadhav1065@gmail.com` |
| Privacy policy | https://www.journeyplus.in/privacy |

---

## 5. Policy forms

| Section | JourneyPlus answer |
|---------|-------------------|
| App access | Restricted — Google Sign-In; provide reviewer test account |
| Ads | No |
| Content rating | Utility/travel; UGC yes (community reports); location yes |
| Target audience | 13+ or 18+; not child-directed |
| Data safety | See [`data_safety.md`](data_safety.md) |
| Foreground service | Location — active trip predictive alerts |

---

## 6. Upload & release tracks

1. **Release → Internal testing** → Create release → upload `app-release.aab`.
2. Add testers, install, verify: Google Sign-In, Maps, location, notifications.
3. Check **Pre-launch report**.
4. Promote to **Production** when ready → Submit for review.

---

## 7. In-app updates (included from `1.0.1+5`)

JourneyPlus checks Google Play after the authenticated shell opens. When a
newer version is available to that Play account/track, it shows an Update /
Later dialog and uses Google Play's native update flow.

For every future release:

1. Increase both values in `pubspec.yaml` (for example `1.0.2+6`).
2. Build and upload the signed AAB.
3. Roll out the release to Internal testing or Production.

No Play Store URL or remote flag is required. Google Play matches updates by
`com.journeyplus.journeyplus` and `versionCode`. The dialog intentionally does
not run for debug/sideloaded installs, iOS, or while an active trip is running.

---

## Checklist

```
□ Play Developer account verified
□ android/key.properties + journeyplus-release.keystore (backed up securely)
□ Release SHA-1/256 in Firebase
□ Privacy policy URL in Play Console: https://www.journeyplus.in/privacy
□ Store assets uploaded
□ Data safety + content rating complete
□ Reviewer Google test account documented in App access
□ flutter build appbundle --release succeeds
□ Internal testing passed
□ Production submitted
```

---

## Related files

| File | Purpose |
|------|---------|
| `android/key.properties.example` | Signing config template |
| `android/scripts/generate_release_keystore.sh` | Create upload keystore |
| `docs/legal/privacy_policy.html` | Host for Play Console |
| `docs/release/store_listing.md` | Listing copy |
| `docs/release/data_safety.md` | Data safety form answers |
| `lib/core/constants/app_links.dart` | Support email + policy URL |
