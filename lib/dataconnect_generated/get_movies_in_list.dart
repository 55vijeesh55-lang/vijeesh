part of 'generated.dart';

class GetMoviesInListVariablesBuilder {
  String listId;

  final FirebaseDataConnect _dataConnect;
  GetMoviesInListVariablesBuilder(this._dataConnect, {required  this.listId,});
  Deserializer<GetMoviesInListData> dataDeserializer = (dynamic json)  => GetMoviesInListData.fromJson(jsonDecode(json));
  Serializer<GetMoviesInListVariables> varsSerializer = (GetMoviesInListVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetMoviesInListData, GetMoviesInListVariables>> execute() {
    return ref().execute();
  }

  QueryRef<GetMoviesInListData, GetMoviesInListVariables> ref() {
    GetMoviesInListVariables vars= GetMoviesInListVariables(listId: listId,);
    return _dataConnect.query("GetMoviesInList", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetMoviesInListList {
  final List<GetMoviesInListListListMoviesOnList> listMovies_on_list;
  GetMoviesInListList.fromJson(dynamic json):
  
  listMovies_on_list = (json['listMovies_on_list'] as List<dynamic>)
        .map((e) => GetMoviesInListListListMoviesOnList.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMoviesInListList otherTyped = other as GetMoviesInListList;
    return listMovies_on_list == otherTyped.listMovies_on_list;
    
  }
  @override
  int get hashCode => listMovies_on_list.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['listMovies_on_list'] = listMovies_on_list.map((e) => e.toJson()).toList();
    return json;
  }

  GetMoviesInListList({
    required this.listMovies_on_list,
  });
}

@immutable
class GetMoviesInListListListMoviesOnList {
  final GetMoviesInListListListMoviesOnListMovie movie;
  final String? note;
  final int position;
  GetMoviesInListListListMoviesOnList.fromJson(dynamic json):
  
  movie = GetMoviesInListListListMoviesOnListMovie.fromJson(json['movie']),
  note = json['note'] == null ? null : nativeFromJson<String>(json['note']),
  position = nativeFromJson<int>(json['position']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMoviesInListListListMoviesOnList otherTyped = other as GetMoviesInListListListMoviesOnList;
    return movie == otherTyped.movie && 
    note == otherTyped.note && 
    position == otherTyped.position;
    
  }
  @override
  int get hashCode => Object.hashAll([movie.hashCode, note.hashCode, position.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['movie'] = movie.toJson();
    if (note != null) {
      json['note'] = nativeToJson<String?>(note);
    }
    json['position'] = nativeToJson<int>(position);
    return json;
  }

  GetMoviesInListListListMoviesOnList({
    required this.movie,
    this.note,
    required this.position,
  });
}

@immutable
class GetMoviesInListListListMoviesOnListMovie {
  final String id;
  final String title;
  final String? summary;
  final int year;
  final List<String>? genres;
  GetMoviesInListListListMoviesOnListMovie.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  title = nativeFromJson<String>(json['title']),
  summary = json['summary'] == null ? null : nativeFromJson<String>(json['summary']),
  year = nativeFromJson<int>(json['year']),
  genres = json['genres'] == null ? null : (json['genres'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMoviesInListListListMoviesOnListMovie otherTyped = other as GetMoviesInListListListMoviesOnListMovie;
    return id == otherTyped.id && 
    title == otherTyped.title && 
    summary == otherTyped.summary && 
    year == otherTyped.year && 
    genres == otherTyped.genres;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode, summary.hashCode, year.hashCode, genres.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['title'] = nativeToJson<String>(title);
    if (summary != null) {
      json['summary'] = nativeToJson<String?>(summary);
    }
    json['year'] = nativeToJson<int>(year);
    if (genres != null) {
      json['genres'] = genres?.map((e) => nativeToJson<String>(e)).toList();
    }
    return json;
  }

  GetMoviesInListListListMoviesOnListMovie({
    required this.id,
    required this.title,
    this.summary,
    required this.year,
    this.genres,
  });
}

@immutable
class GetMoviesInListData {
  final GetMoviesInListList? list;
  GetMoviesInListData.fromJson(dynamic json):
  
  list = json['list'] == null ? null : GetMoviesInListList.fromJson(json['list']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMoviesInListData otherTyped = other as GetMoviesInListData;
    return list == otherTyped.list;
    
  }
  @override
  int get hashCode => list.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (list != null) {
      json['list'] = list!.toJson();
    }
    return json;
  }

  GetMoviesInListData({
    this.list,
  });
}

@immutable
class GetMoviesInListVariables {
  final String listId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetMoviesInListVariables.fromJson(Map<String, dynamic> json):
  
  listId = nativeFromJson<String>(json['listId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMoviesInListVariables otherTyped = other as GetMoviesInListVariables;
    return listId == otherTyped.listId;
    
  }
  @override
  int get hashCode => listId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['listId'] = nativeToJson<String>(listId);
    return json;
  }

  GetMoviesInListVariables({
    required this.listId,
  });
}

