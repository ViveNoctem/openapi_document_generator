import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:open_api_spec_builder_generator/src/data_classes/open_api_components.dart';

class const ContentUtils() {
  (String?, Set<DartType>?) getJsonForContentType({
    required DartType? type,
    required bool isComponents,
  }) {
    if (type == null) {
      return (null, null);
    }
    final addedObjectTypes = <DartType>{};
    final json = <String, dynamic>{};

    if (type.isDartCoreBool) {
      if (isComponents) {
        return (null, null);
      }
      json["type"] = "boolean";
    } else if (type.isDartCoreInt) {
      if (isComponents) {
        return (null, null);
      }
      json["type"] = "integer";
    } else if (type.isDartCoreString) {
      if (isComponents) {
        return (null, null);
      }
      json["type"] = "string";
    } else if (type.isDartCoreDouble) {
      if (isComponents) {
        return (null, null);
      }
      json["type"] = "number";
    } else if (type.isDartCoreNull) {
      if (isComponents) {
        return (null, null);
      }
      json["type"] = "null";
    } else if (type.isDartCoreList) {
      throw UnimplementedError("List as a parameter Type not supported");
    } else {
      if (isComponents == false) {
        json["type"] = "object";
        json["\$ref"] = "#/components/schemas/${type.element?.displayName}";
        addedObjectTypes.add(type);
      } else {
        json["type"] = "object";
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
          final propertiesJson = <String, dynamic>{};

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
              final (objectJson, newDartTypes) = getJsonForContentType(
                type: field.type,
                isComponents: false,
              );

              if (objectJson == null) {
                continue;
              }

              if (newDartTypes != null) {
                addedObjectTypes.addAll(newDartTypes);
              }

              propertiesJson[fieldName] = jsonDecode(objectJson);
            }
          }
          if (required.isNotEmpty) {
            json["required"] = required;
          }
          if (propertiesJson.isNotEmpty) {
            json["properties"] = propertiesJson;
          }
        } else {
          throw UnimplementedError("object is not a InterfaceElement");
        }
      }
    }

    return (jsonEncode(json), addedObjectTypes);
  }

  OpenApiComponents getSchemas(Set<DartType> types) {
    final typesDone = <DartType>{};
    final toBeDone = <DartType>[...types];
    var typesJson = <String, dynamic>{};

    while (toBeDone.isNotEmpty) {
      final current = toBeDone.removeAt(0);

      if (typesDone.contains(current)) {
        continue;
      }

      typesDone.add(current);

      final (json, newTypes) = getJsonForContentType(
        type: current,
        isComponents: true,
      );
      if (json != null) {
        typesJson[current.element!.name!] = jsonDecode(json);
      }
      if (newTypes != null) {
        for (final newType in newTypes) {
          if (typesDone.contains(newType) == false) {
            toBeDone.add(newType);
          }
        }
      }
    }

    return OpenApiComponents(types: typesDone, schemas: jsonEncode(typesJson));
  }
}
