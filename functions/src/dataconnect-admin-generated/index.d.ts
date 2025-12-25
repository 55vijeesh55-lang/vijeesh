import { ConnectorConfig, DataConnect, OperationOptions, ExecuteOperationResponse } from 'firebase-admin/data-connect';

export const connectorConfig: ConnectorConfig;

export type TimestampString = string;
export type UUIDString = string;
export type Int64String = string;
export type DateString = string;


export interface AddMovieToListData {
  listMovie_insert: {
    listId: UUIDString;
    movieId: UUIDString;
  };
}

export interface AddMovieToListVariables {
  listId: UUIDString;
  movieId: UUIDString;
  note: string;
  position: number;
}

export interface CreatePublicListData {
  list_insert: {
    id: UUIDString;
  };
}

export interface CreatePublicListVariables {
  name: string;
  description: string;
}

export interface GetMoviesInListData {
  list?: {
    listMovies_on_list: ({
      movie: {
        id: UUIDString;
        title: string;
        summary?: string | null;
        year: number;
        genres?: string[] | null;
      } & Movie_Key;
        note?: string | null;
        position: number;
    })[];
  };
}

export interface GetMoviesInListVariables {
  listId: UUIDString;
}

export interface GetPublicListsData {
  lists: ({
    id: UUIDString;
    name: string;
    description?: string | null;
    createdAt: TimestampString;
    updatedAt: TimestampString;
  } & List_Key)[];
}

export interface ListMovie_Key {
  listId: UUIDString;
  movieId: UUIDString;
  __typename?: 'ListMovie_Key';
}

export interface List_Key {
  id: UUIDString;
  __typename?: 'List_Key';
}

export interface Movie_Key {
  id: UUIDString;
  __typename?: 'Movie_Key';
}

export interface Review_Key {
  id: UUIDString;
  __typename?: 'Review_Key';
}

export interface User_Key {
  id: UUIDString;
  __typename?: 'User_Key';
}

export interface Watch_Key {
  id: UUIDString;
  __typename?: 'Watch_Key';
}

/** Generated Node Admin SDK operation action function for the 'CreatePublicList' Mutation. Allow users to execute without passing in DataConnect. */
export function createPublicList(dc: DataConnect, vars: CreatePublicListVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreatePublicListData>>;
/** Generated Node Admin SDK operation action function for the 'CreatePublicList' Mutation. Allow users to pass in custom DataConnect instances. */
export function createPublicList(vars: CreatePublicListVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<CreatePublicListData>>;

/** Generated Node Admin SDK operation action function for the 'GetPublicLists' Query. Allow users to execute without passing in DataConnect. */
export function getPublicLists(dc: DataConnect, options?: OperationOptions): Promise<ExecuteOperationResponse<GetPublicListsData>>;
/** Generated Node Admin SDK operation action function for the 'GetPublicLists' Query. Allow users to pass in custom DataConnect instances. */
export function getPublicLists(options?: OperationOptions): Promise<ExecuteOperationResponse<GetPublicListsData>>;

/** Generated Node Admin SDK operation action function for the 'AddMovieToList' Mutation. Allow users to execute without passing in DataConnect. */
export function addMovieToList(dc: DataConnect, vars: AddMovieToListVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<AddMovieToListData>>;
/** Generated Node Admin SDK operation action function for the 'AddMovieToList' Mutation. Allow users to pass in custom DataConnect instances. */
export function addMovieToList(vars: AddMovieToListVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<AddMovieToListData>>;

/** Generated Node Admin SDK operation action function for the 'GetMoviesInList' Query. Allow users to execute without passing in DataConnect. */
export function getMoviesInList(dc: DataConnect, vars: GetMoviesInListVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetMoviesInListData>>;
/** Generated Node Admin SDK operation action function for the 'GetMoviesInList' Query. Allow users to pass in custom DataConnect instances. */
export function getMoviesInList(vars: GetMoviesInListVariables, options?: OperationOptions): Promise<ExecuteOperationResponse<GetMoviesInListData>>;

