# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetPublicLists
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getPublicLists().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPublicListsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPublicLists();
GetPublicListsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getPublicLists().ref();
ref.execute();

ref.subscribe(...);
```


### GetMoviesInList
#### Required Arguments
```dart
String listId = ...;
ExampleConnector.instance.getMoviesInList(
  listId: listId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMoviesInListData, GetMoviesInListVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getMoviesInList(
  listId: listId,
);
GetMoviesInListData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String listId = ...;

final ref = ExampleConnector.instance.getMoviesInList(
  listId: listId,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreatePublicList
#### Required Arguments
```dart
String name = ...;
String description = ...;
ExampleConnector.instance.createPublicList(
  name: name,
  description: description,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreatePublicListData, CreatePublicListVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createPublicList(
  name: name,
  description: description,
);
CreatePublicListData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String name = ...;
String description = ...;

final ref = ExampleConnector.instance.createPublicList(
  name: name,
  description: description,
).ref();
ref.execute();
```


### AddMovieToList
#### Required Arguments
```dart
String listId = ...;
String movieId = ...;
String note = ...;
int position = ...;
ExampleConnector.instance.addMovieToList(
  listId: listId,
  movieId: movieId,
  note: note,
  position: position,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddMovieToListData, AddMovieToListVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.addMovieToList(
  listId: listId,
  movieId: movieId,
  note: note,
  position: position,
);
AddMovieToListData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String listId = ...;
String movieId = ...;
String note = ...;
int position = ...;

final ref = ExampleConnector.instance.addMovieToList(
  listId: listId,
  movieId: movieId,
  note: note,
  position: position,
).ref();
ref.execute();
```

