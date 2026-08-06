import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Total number of pages in the onboarding flow.
const int kOnboardingPageCount = 3;

// ── State ─────────────────────────────────────────────────────────────────────

/// Immutable state describing the current position in the onboarding flow.
class OnboardingState {
  final int currentPage;
  final int totalPages;

  const OnboardingState({required this.currentPage, required this.totalPages});

  bool get isFirstPage => currentPage == 0;
  bool get isLastPage => currentPage == totalPages - 1;
  bool get showSkip => !isLastPage;

  OnboardingState copyWith({int? currentPage}) => OnboardingState(
    currentPage: currentPage ?? this.currentPage,
    totalPages: totalPages,
  );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Manages current page position for the onboarding flow.
///
/// Navigation methods are intentionally limited to onboarding-specific
/// concerns — no persistence, no routing, no auth logic.
class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() =>
      const OnboardingState(currentPage: 0, totalPages: kOnboardingPageCount);

  /// Advances to the next page. No-op if already on the last page.
  void nextPage() {
    if (state.isLastPage) return;
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  /// Returns to the previous page. No-op if already on the first page.
  void previousPage() {
    if (state.isFirstPage) return;
    state = state.copyWith(currentPage: state.currentPage - 1);
  }

  /// Jumps directly to the last page (used by the Skip action).
  void skipToLast() {
    state = state.copyWith(currentPage: state.totalPages - 1);
  }

  /// Sets the page to an arbitrary index. Clamps to valid range silently.
  void setPage(int index) {
    final clamped = index.clamp(0, state.totalPages - 1);
    if (clamped == state.currentPage) return;
    state = state.copyWith(currentPage: clamped);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
