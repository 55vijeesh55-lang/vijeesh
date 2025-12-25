part of 'generated.dart';

class CreatePublicListVariablesBuilder {
  String name;
  String description;

  final FirebaseDataConnect _dataConnect;
  CreatePublicListVariablesBuilder(this._dataConnect, {required  this.name,required  this.description,});
  Deserializer<CreatePublicListData> dataDeserializer = (dynamic json)  => CreatePublicListData.fromJson(jsonDecode(json));
  Serializer<CreatePublicListVariables> varsSerializer = (CreatePublicListVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreatePublicListData, CreatePublicListVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreatePublicListData, CreatePublicListVariables> ref() {
    CreatePublicListVariables vars= CreatePublicListVariables(name: name,description: description,);
    return _dataConnect.mutation("CreatePublicList", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreatePublicListListInsert {
  final String id;
  CreatePublicListListInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePublicListListInsert otherTyped = other as CreatePublicListListInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreatePublicListListInsert({
    required this.id,
  });
}

@immutable
class CreatePublicListData {
  final CreatePublicListListInsert list_insert;
  CreatePublicListData.fromJson(dynamic json):
  
  list_insert = CreatePublicListListInsert.fromJson(json['list_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePublicListData otherTyped = other as CreatePublicListData;
    return list_insert == otherTyped.list_insert;
    
  }
  @override
  int get hashCode => list_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['list_insert'] = list_insert.toJson();
    return json;
  }

  CreatePublicListData({
    required this.list_insert,
  });
}

@immutable
class CreatePublicListVariables {
  final String name;
  final String description;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreatePublicListVariables.fromJson(Map<String, dynamic> json):
  
  name = nativeFromJson<String>(json['name']),
  description = nativeFromJson<String>(json['description']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePublicListVariables otherTyped = other as CreatePublicListVariables;
    return name == otherTyped.name && 
    description == otherTyped.description;
    
  }
  @override
  int get hashCode => Object.hashAll([name.hashCode, description.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['description'] = nativeToJson<String>(description);
    return json;
  }

  CreatePublicListVariables({
    required this.name,
    required this.description,
  });
}

