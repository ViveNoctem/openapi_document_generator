// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_api_fragment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiFragment _$OpenApiFragmentFromJson(Map<String, dynamic> json) =>
    OpenApiFragment(
      paths: (json['paths'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as Map<String, dynamic>).map(
            (k, e) => MapEntry(
              $enumDecode(_$HttpMethodEnumMap, k),
              OpenApiEndpoint.fromJson(e as Map<String, dynamic>),
            ),
          ),
        ),
      ),
    );

Map<String, dynamic> _$OpenApiFragmentToJson(OpenApiFragment instance) =>
    <String, dynamic>{
      'paths': instance.paths.map(
        (k, e) =>
            MapEntry(k, e.map((k, e) => MapEntry(_$HttpMethodEnumMap[k]!, e))),
      ),
    };

const _$HttpMethodEnumMap = {
  HttpMethod.get: 'GET',
  HttpMethod.post: 'POST',
  HttpMethod.put: 'PUT',
  HttpMethod.delete: 'DELETE',
  HttpMethod.options: 'OPTIONS',
  HttpMethod.head: 'HEAD',
  HttpMethod.patch: 'PATCH',
  HttpMethod.trace: 'TRACE',
  HttpMethod.query: 'QUERY',
};
