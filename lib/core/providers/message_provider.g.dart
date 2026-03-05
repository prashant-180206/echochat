// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Realtime messages (recent updates)

@ProviderFor(dynamicMessages)
final dynamicMessagesProvider = DynamicMessagesFamily._();

/// Realtime messages (recent updates)

final class DynamicMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Message>>,
          List<Message>,
          Stream<List<Message>>
        >
    with $FutureModifier<List<Message>>, $StreamProvider<List<Message>> {
  /// Realtime messages (recent updates)
  DynamicMessagesProvider._({
    required DynamicMessagesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'dynamicMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dynamicMessagesHash();

  @override
  String toString() {
    return r'dynamicMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Message>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Message>> create(Ref ref) {
    final argument = this.argument as int;
    return dynamicMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DynamicMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dynamicMessagesHash() => r'605961fe392ba72a2670ba6e6138cb52f329a58d';

/// Realtime messages (recent updates)

final class DynamicMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Message>>, int> {
  DynamicMessagesFamily._()
    : super(
        retry: null,
        name: r'dynamicMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Realtime messages (recent updates)

  DynamicMessagesProvider call(int conversationId) =>
      DynamicMessagesProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'dynamicMessagesProvider';
}

/// Message history with pagination

@ProviderFor(MessageHistory)
final messageHistoryProvider = MessageHistoryFamily._();

/// Message history with pagination
final class MessageHistoryProvider
    extends $AsyncNotifierProvider<MessageHistory, List<Message>> {
  /// Message history with pagination
  MessageHistoryProvider._({
    required MessageHistoryFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'messageHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messageHistoryHash();

  @override
  String toString() {
    return r'messageHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MessageHistory create() => MessageHistory();

  @override
  bool operator ==(Object other) {
    return other is MessageHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messageHistoryHash() => r'bd328aa1e8fbb19f5c1e89e6bc54c46f514f1863';

/// Message history with pagination

final class MessageHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          MessageHistory,
          AsyncValue<List<Message>>,
          List<Message>,
          FutureOr<List<Message>>,
          int
        > {
  MessageHistoryFamily._()
    : super(
        retry: null,
        name: r'messageHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Message history with pagination

  MessageHistoryProvider call(int conversationId) =>
      MessageHistoryProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'messageHistoryProvider';
}

/// Message history with pagination

abstract class _$MessageHistory extends $AsyncNotifier<List<Message>> {
  late final _$args = ref.$arg as int;
  int get conversationId => _$args;

  FutureOr<List<Message>> build(int conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Message>>, List<Message>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Message>>, List<Message>>,
              AsyncValue<List<Message>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
