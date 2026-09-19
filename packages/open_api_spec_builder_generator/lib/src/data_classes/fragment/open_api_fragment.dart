import 'package:json_annotation/json_annotation.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_endpoint.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_spec.dart';

part 'open_api_fragment.g.dart';

@JsonSerializable()
final class const OpenApiFragment({required final OpenApiPaths paths}) {
  factory OpenApiFragment.fromJson(Map<String, dynamic> json) =>
      _$OpenApiFragmentFromJson(json);
  Map<String, dynamic> toJson() => _$OpenApiFragmentToJson(this);
}
