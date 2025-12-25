part of 'generated.dart';

class GetPublicListsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetPublicListsVariablesBuilder(this._dataConnect, );
  Deserializer<GetPublicListsData> dataDeserializer = (dynamic json)  => GetPublicListsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetPublicListsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetPublicListsData, void> ref() {
    
    return _dataConnect.query("GetPublicLists", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetPublicListsLists {
  final String id;
  final String name;
  final String? description;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  GetPublicListsLists.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  updatedAt = Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPublicListsLists otherTyped = other as GetPublicListsLists;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    description == otherTyped.description && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, description.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['createdAt'] = createdAt.toJson();
    json['updatedAt'] = updatedAt.toJson();
    return json;
  }

  GetPublicListsLists({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
}

@immutable
class GetPublicListsData {
  final List<GetPublicListsLists> lists;
  GetPublicListsData.fromJson(dynamic json):
  
  lists = (json['lists'] as List<dynamic>)
        .map((e) => GetPublicListsLists.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPublicListsData otherTyped = other as GetPublicListsData;
    return lists == otherTyped.lists;
    
  }
  @override
  int get hashCode => lists.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['lists'] = lists.map((e) => e.toJson()).toList();
    return json;
  }

  GetPublicListsData({
    required this.lists,
  });
}

