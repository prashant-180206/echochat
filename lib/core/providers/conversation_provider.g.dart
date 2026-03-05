// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// REALTIME conversations (last 10 minutes)

@ProviderFor(dynamicConversations)
final dynamicConversationsProvider = DynamicConversationsProvider._();

/// REALTIME conversations (last 10 minutes)

final class DynamicConversationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ConversationListView>>,
          List<ConversationListView>,
          Stream<List<ConversationListView>>
        >
    with
        $FutureModifier<List<ConversationListView>>,
        $StreamProvider<List<ConversationListView>> {
  /// REALTIME conversations (last 10 minutes)
  DynamicConversationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dynamicConversationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dynamicConversationsHash();

  @$internal
  @override
  $StreamProviderElement<List<ConversationListView>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ConversationListView>> create(Ref ref) {
    return dynamicConversations(ref);
  }
}

String _$dynamicConversationsHash() =>
    r'1525a35906a58b1859de90ce87b69ec5e2816da7';

/// STATIC conversations (older than 10 minutes) with pagination

@ProviderFor(StaticConversations)
final staticConversationsProvider = StaticConversationsProvider._();

/// STATIC conversations (older than 10 minutes) with pagination
final class StaticConversationsProvider
    extends
        $AsyncNotifierProvider<
          StaticConversations,
          List<ConversationListView>
        > {
  /// STATIC conversations (older than 10 minutes) with pagination
  StaticConversationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staticConversationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staticConversationsHash();

  @$internal
  @override
  StaticConversations create() => StaticConversations();
}

String _$staticConversationsHash() =>
    r'087211f1f741f449e698b4e16903ca5e072684ae';

/// STATIC conversations (older than 10 minutes) with pagination

abstract class _$StaticConversations
    extends $AsyncNotifier<List<ConversationListView>> {
  FutureOr<List<ConversationListView>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ConversationListView>>,
              List<ConversationListView>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ConversationListView>>,
                List<ConversationListView>
              >,
              AsyncValue<List<ConversationListView>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
