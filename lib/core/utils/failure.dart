import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Canonical error taxonomy for all repositories.
///
/// Every repository write returns `Either<Failure, T>`. UI maps each variant
/// to an actionable CTA:
/// - [network]    → "Retry now"
/// - [permission] → "Open settings"
/// - [index]      → "Try again shortly" (Firestore composite index building)
/// - [firestore]  → "Try again shortly"
/// - [platform]   → "Something went wrong" (native platform exception)
/// - [quota]      → "Limit reached — wait a bit"
@freezed
sealed class Failure with _$Failure {
  const Failure._();

  const factory Failure.network(String message) = NetworkFailure;
  const factory Failure.permission(String message) = PermissionFailure;
  const factory Failure.index(String message) = IndexFailure;
  const factory Failure.firestore(String message) = FirestoreFailure;
  const factory Failure.platform(String message) = PlatformFailure;
  const factory Failure.quota(String message) = QuotaFailure;

  /// Short, user-actionable CTA label per the UI mapping rule.
  String get actionLabel => switch (this) {
        NetworkFailure() => 'Retry now',
        PermissionFailure() => 'Open settings',
        IndexFailure() => 'Try again shortly',
        FirestoreFailure() => 'Try again shortly',
        PlatformFailure() => 'Try again',
        QuotaFailure() => 'Wait a bit',
      };
}
