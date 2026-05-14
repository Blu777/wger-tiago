// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fitness_insight_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stub provider for subjective feedback.
/// Returns an empty list until a real data source is wired in.

@ProviderFor(subjectiveFeedback)
final subjectiveFeedbackProvider = SubjectiveFeedbackProvider._();

/// Stub provider for subjective feedback.
/// Returns an empty list until a real data source is wired in.

final class SubjectiveFeedbackProvider
    extends
        $FunctionalProvider<
          List<SubjectiveFeedback>,
          List<SubjectiveFeedback>,
          List<SubjectiveFeedback>
        >
    with $Provider<List<SubjectiveFeedback>> {
  /// Stub provider for subjective feedback.
  /// Returns an empty list until a real data source is wired in.
  SubjectiveFeedbackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subjectiveFeedbackProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subjectiveFeedbackHash();

  @$internal
  @override
  $ProviderElement<List<SubjectiveFeedback>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<SubjectiveFeedback> create(Ref ref) {
    return subjectiveFeedback(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SubjectiveFeedback> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SubjectiveFeedback>>(value),
    );
  }
}

String _$subjectiveFeedbackHash() =>
    r'5cc831e1aadd9b89d73e9a0386f67a4345c52ee7';
