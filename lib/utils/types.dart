import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum MessageType {
  @JsonValue('text')
  text,

  @JsonValue('image')
  image,

  @JsonValue('file')
  file,
}
