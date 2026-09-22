import 'package:json_annotation/json_annotation.dart';
import 'package:openapi_document_generator/src/data_classes/i_document_node.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_document.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_operation.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_parameter.dart';
import 'package:openapi_document_generator/src/result/result_of.dart';

part 'openapi_path_item.g.dart';

@JsonSerializable()
class const InternOpenapiPathItem({
  @JsonKey(name: '\$ref') final String? ref,
  final String? summary,
  final String? description,
  final InternOpenApiOperation? get,
  final InternOpenApiOperation? put,
  final InternOpenApiOperation? post,
  final InternOpenApiOperation? delete,
  final InternOpenApiOperation? options,
  final InternOpenApiOperation? head,
  final InternOpenApiOperation? patch,
  final InternOpenApiOperation? trace,
  final InternOpenApiOperation? query,
  final List<InternOpenApiParameter>? parameters,
}) implements IDocumentNode {
  factory InternOpenapiPathItem.fromJson(Map<String, dynamic> json) =>
      _$InternOpenapiPathItemFromJson(json);
  Map<String, dynamic> toJson() => _$InternOpenapiPathItemToJson(this);

  InternOpenapiPathItem.withMethod(
    HttpMethod method,
    InternOpenApiOperation operation,
  ) : this(
        get: method == .get ? operation : null,
        put: method == .put ? operation : null,
        post: method == .post ? operation : null,
        delete: method == .delete ? operation : null,
        options: method == .options ? operation : null,
        head: method == .head ? operation : null,
        patch: method == .patch ? operation : null,
        trace: method == .trace ? operation : null,
        query: method == .query ? operation : null,
      );

  List<InternOpenApiOperation> get allOperations => [
    ?get,
    ?put,
    ?post,
    ?delete,
    ?options,
    ?head,
    ?patch,
    ?trace,
    ?query,
  ];

  bool canMerge(InternOpenapiPathItem other) {
    if ((get != null && other.get != null) &&
        (put != null && other.put != null) &&
        (post != null && other.post != null) &&
        (delete != null && other.delete != null) &&
        (options != null && other.options != null) &&
        (head != null && other.head != null) &&
        (patch != null && other.patch != null) &&
        (trace != null && other.trace != null) &&
        (query != null && other.query != null)) {
      return false;
    }
    return true;
  }

  @override
  InternOpenapiPathItem merge(IDocumentNode other) {
    if (other is! InternOpenapiPathItem) {
      return this;
    }

    return InternOpenapiPathItem(
      summary: summary ?? other.summary,
      description: description ?? other.description,
      get: get ?? other.get,
      put: put ?? other.put,
      post: post ?? other.post,
      delete: delete ?? other.delete,
      options: options ?? other.options,
      head: head ?? other.head,
      patch: patch ?? other.patch,
      trace: trace ?? other.trace,
      query: query ?? other.query,
      ref: ref ?? other.ref,
      parameters: parameters ?? other.parameters,
    );
  }

  @override
  ResultOf<void, ValidationErrors> validate(String path) {
    path = path + "/pathItem";
    var errors = ValidationErrors([]);

    if (get case final get?) {
      final result = get.validate(path + "/get");

      switch (result) {
        case FailureOf<void, ValidationErrors>():
          errors = errors.merge(result.failure);
        case SuccessOf<void, ValidationErrors>():
          break;
      }
    }

    if (put case final put?) {
      final result = put.validate(path + "/put");

      switch (result) {
        case FailureOf<void, ValidationErrors>():
          errors = errors.merge(result.failure);
        case SuccessOf<void, ValidationErrors>():
          break;
      }
    }

    if (post case final post?) {
      final result = post.validate(path + "/post");

      switch (result) {
        case FailureOf<void, ValidationErrors>():
          errors = errors.merge(result.failure);
        case SuccessOf<void, ValidationErrors>():
          break;
      }
    }

    if (delete case final delete?) {
      final result = delete.validate(path + "/delete");

      switch (result) {
        case FailureOf<void, ValidationErrors>():
          errors = errors.merge(result.failure);
        case SuccessOf<void, ValidationErrors>():
          break;
      }
    }

    if (options case final options?) {
      final result = options.validate(path + "/options");

      switch (result) {
        case FailureOf<void, ValidationErrors>():
          errors = errors.merge(result.failure);
        case SuccessOf<void, ValidationErrors>():
          break;
      }
    }

    if (head case final head?) {
      final result = head.validate(path + "/head");

      switch (result) {
        case FailureOf<void, ValidationErrors>():
          errors = errors.merge(result.failure);
        case SuccessOf<void, ValidationErrors>():
          break;
      }
    }

    if (patch case final patch?) {
      final result = patch.validate(path + "/patch");

      switch (result) {
        case FailureOf<void, ValidationErrors>():
          errors = errors.merge(result.failure);
        case SuccessOf<void, ValidationErrors>():
          break;
      }
    }

    if (trace case final trace?) {
      final result = trace.validate(path + "/trace");

      switch (result) {
        case FailureOf<void, ValidationErrors>():
          errors = errors.merge(result.failure);
        case SuccessOf<void, ValidationErrors>():
          break;
      }
    }

    if (query case final query?) {
      final result = query.validate(path + "/query");

      switch (result) {
        case FailureOf<void, ValidationErrors>():
          errors = errors.merge(result.failure);
        case SuccessOf<void, ValidationErrors>():
          break;
      }
    }

    if (errors.validations.isEmpty) {
      return FailureOf(errors);
    }

    return SuccessOf(null);
  }
}
