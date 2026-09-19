import 'package:json_annotation/json_annotation.dart';

part 'open_api_builder_options.g.dart';

@JsonSerializable()
class const OpenApiBuilderOptions({final EApiLibrary apiLibrary = .none}) {
  factory OpenApiBuilderOptions.fromJson(Map<String, dynamic> json) =>
      _$OpenApiBuilderOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiBuilderOptionsToJson(this);
}

enum EApiLibrary { none, shelf, dartFrog, serverPod }
