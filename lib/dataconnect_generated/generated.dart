library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_public_list.dart';

part 'get_public_lists.dart';

part 'add_movie_to_list.dart';

part 'get_movies_in_list.dart';







class ExampleConnector {
  
  
  CreatePublicListVariablesBuilder createPublicList ({required String name, required String description, }) {
    return CreatePublicListVariablesBuilder(dataConnect, name: name,description: description,);
  }
  
  
  GetPublicListsVariablesBuilder getPublicLists () {
    return GetPublicListsVariablesBuilder(dataConnect, );
  }
  
  
  AddMovieToListVariablesBuilder addMovieToList ({required String listId, required String movieId, required String note, required int position, }) {
    return AddMovieToListVariablesBuilder(dataConnect, listId: listId,movieId: movieId,note: note,position: position,);
  }
  
  
  GetMoviesInListVariablesBuilder getMoviesInList ({required String listId, }) {
    return GetMoviesInListVariablesBuilder(dataConnect, listId: listId,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'vijeesh-1',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
