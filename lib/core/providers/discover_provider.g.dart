// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Discover)
final discoverProvider = DiscoverFamily._();

final class DiscoverProvider
    extends $AsyncNotifierProvider<Discover, List<Profile>> {
  DiscoverProvider._({
    required DiscoverFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'discoverProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$discoverHash();

  @override
  String toString() {
    return r'discoverProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Discover create() => Discover();

  @override
  bool operator ==(Object other) {
    return other is DiscoverProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$discoverHash() => r'860881657ce6fa59495b971e6db3c6e8fbe7b291';

final class DiscoverFamily extends $Family
    with
        $ClassFamilyOverride<
          Discover,
          AsyncValue<List<Profile>>,
          List<Profile>,
          FutureOr<List<Profile>>,
          String
        > {
  DiscoverFamily._()
    : super(
        retry: null,
        name: r'discoverProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiscoverProvider call(String searchstr) =>
      DiscoverProvider._(argument: searchstr, from: this);

  @override
  String toString() => r'discoverProvider';
}

abstract class _$Discover extends $AsyncNotifier<List<Profile>> {
  late final _$args = ref.$arg as String;
  String get searchstr => _$args;

  FutureOr<List<Profile>> build(String searchstr);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Profile>>, List<Profile>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Profile>>, List<Profile>>,
              AsyncValue<List<Profile>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
