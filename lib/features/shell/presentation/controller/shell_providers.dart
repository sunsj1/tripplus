import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom nav index for [AppShell]: 0 Plan, 1 Trip, 2 Discovery, 3 Profile.
final shellTabIndexProvider = StateProvider<int>((ref) => 0);

void navigateToShellTab(WidgetRef ref, int index) {
  ref.read(shellTabIndexProvider.notifier).state = index;
}
