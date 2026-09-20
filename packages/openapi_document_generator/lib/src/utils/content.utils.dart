import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_components.dart';
import 'package:openapi_document_generator/src/data_classes/open_api_content.dart';

class const ContentUtils() {
  (OpenApiSchemaContent?, Set<DartType>?) getOpenApiSchemaForType({
    required DartType? type,
    required bool isComponents,
  }) {
    if (type == null) {
      return (null, null);
    }
    final addedObjectTypes = <DartType>{};
    OpenApiSchemaContent? contentResult = null;

    if (type.isDartCoreBool) {
      if (isComponents) {
        return (null, null);
      }
      contentResult = OpenApiSchemaContent(type: .boolean);
    } else if (type.isDartCoreInt) {
      if (isComponents) {
        return (null, null);
      }
      contentResult = OpenApiSchemaContent(type: .integer);
    } else if (type.isDartCoreString) {
      if (isComponents) {
        return (null, null);
      }
      contentResult = OpenApiSchemaContent(type: .string);
    } else if (type.isDartCoreDouble) {
      if (isComponents) {
        return (null, null);
      }
      contentResult = OpenApiSchemaContent(type: .number);
    } else if (type.isDartCoreNull) {
      if (isComponents) {
        return (null, null);
      }
      contentResult = OpenApiSchemaContent(type: .nullVal);
    } else if (type.isDartCoreList) {
      throw UnimplementedError("List as a parameter Type not supported");
      contentResult = OpenApiSchemaContent(type: .array);
    } else {
      if (isComponents == false) {
        if (type.element?.name case final name?) {
          contentResult = OpenApiSchemaContent(
            type: .object,
            ref: "#/components/schemas/$name",
            dartType: type,
          );
          addedObjectTypes.add(type);
        }
      } else {
        // TODO required
        if (type.element case InterfaceElement interfaceElement) {
          final constructor = interfaceElement.constructors.firstOrNull;
          if (constructor == null) {
            throw UnimplementedError("couldn't find constructor");
          }

          List<String> required = <String>[];

          for (final parameter in constructor.formalParameters) {
            if (parameter.isRequired) {
              if (parameter.name case final name?) {
                required.add(name);
              }
            }
          }

          // TODO property Name to propertyJsonString
          final propertiesMap = <String, OpenApiSchemaContent>{};

          for (final superType in [
            interfaceElement.thisType,
            ...interfaceElement.allSupertypes,
          ]) {
            final superElement = superType.element;
            for (final field in superElement.fields) {
              // list only public and "real" fields no getter/setter
              // TODO doesn't work like i thought it would.
              // TODO
              if (field.isPublic == false ||
                  (field.isOriginDeclaringFormalParameter == false &&
                      field.isOriginDeclaration == false)) {
                continue;
              }
              final fieldName = field.name;

              if (fieldName == null ||
                  fieldName == "hashCode" ||
                  fieldName == "runtimeType") {
                continue;
              }

              // TODO have to know if field is another dartType, that has to be generated
              final (objectJson, newDartTypes) = getOpenApiSchemaForType(
                type: field.type,
                isComponents: false,
              );

              if (objectJson == null) {
                continue;
              }

              if (newDartTypes != null) {
                addedObjectTypes.addAll(newDartTypes);
              }

              propertiesMap[fieldName] = objectJson;
            }
          }

          contentResult = OpenApiSchemaContent(
            type: .object,
            required: required.isNotEmpty ? required : null,
            properties: propertiesMap.isNotEmpty ? propertiesMap : null,
            dartType: type,
          );
        } else {
          throw UnimplementedError("object is not a InterfaceElement");
        }
      }
    }

    return (contentResult, addedObjectTypes);
  }

  OpenApiComponents getSchemas(Set<DartType> types) {
    final typesDone = <DartType>{};
    final toBeDone = <DartType>[...types];
    final schemaContentMap = <String, OpenApiSchemaContent>{};

    while (toBeDone.isNotEmpty) {
      final current = toBeDone.removeAt(0);

      if (typesDone.contains(current)) {
        continue;
      }

      typesDone.add(current);

      final (openApiSchema, newTypes) = getOpenApiSchemaForType(
        type: current,
        isComponents: true,
      );
      if ((openApiSchema, current.element?.name) case (
        final safeSchema?,
        final safeName?,
      )) {
        schemaContentMap[safeName] = safeSchema;
      }
      if (newTypes != null) {
        for (final newType in newTypes) {
          if (typesDone.contains(newType) == false) {
            toBeDone.add(newType);
          }
        }
      }
    }

    return OpenApiComponents(types: typesDone, schemas: schemaContentMap);
  }
}
