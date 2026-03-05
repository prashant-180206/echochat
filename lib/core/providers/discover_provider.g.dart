// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(discover)
final discoverProvider = DiscoverFamily._();

final class DiscoverProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Profile>>,
          List<Profile>,
          FutureOr<List<Profile>>
        >
    with $FutureModifier<List<Profile>>, $FutureProvider<List<Profile>> {
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
  $FutureProviderElement<List<Profile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Profile>> create(Ref ref) {
    final argument = this.argument as String;
    return discover(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DiscoverProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$discoverHash() => r'87ef4b35edaf788245211f284facbc44c3ab9408';

final class DiscoverFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Profile>>, String> {
  DiscoverFamily._()
    : super(
        retry: null,
        name: r'discoverProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiscoverProvider call(String searchStr) =>
      DiscoverProvider._(argument: searchStr, from: this);

  @override
  String toString() => r'discoverProvider';
}
