/* eslint-disable */
import { TypedDocumentNode as DocumentNode } from '@graphql-typed-document-node/core';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
};

export type IjustContext = {
  __typename?: 'IjustContext';
  accountId: Scalars['ID']['output'];
  id: Scalars['ID']['output'];
  insertedAt: Scalars['String']['output'];
  name: Scalars['String']['output'];
  updatedAt: Scalars['String']['output'];
  userId: Scalars['ID']['output'];
};

export type IjustEvent = {
  __typename?: 'IjustEvent';
  cost?: Maybe<Money>;
  count: Scalars['Int']['output'];
  id: Scalars['ID']['output'];
  ijustContext: IjustContext;
  ijustContextId: Scalars['ID']['output'];
  ijustOccurrences?: Maybe<Array<Maybe<IjustOccurrence>>>;
  insertedAt: Scalars['String']['output'];
  name: Scalars['String']['output'];
  updatedAt: Scalars['String']['output'];
};

export type IjustEventPayload = {
  __typename?: 'IjustEventPayload';
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<Array<Maybe<ValidationMessage>>>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<IjustEvent>;
  /** Indicates if the mutation completed successfully or not. */
  successful: Scalars['Boolean']['output'];
};

export type IjustOccurrence = {
  __typename?: 'IjustOccurrence';
  id: Scalars['ID']['output'];
  ijustEvent?: Maybe<IjustEvent>;
  ijustEventId: Scalars['ID']['output'];
  insertedAt: Scalars['String']['output'];
  isDeleted?: Maybe<Scalars['Boolean']['output']>;
  updatedAt: Scalars['String']['output'];
};

export type LoginJwt = {
  __typename?: 'LoginJwt';
  accessToken: Scalars['String']['output'];
  refreshToken: Scalars['String']['output'];
  user: User;
};

export type LoginJwtPayload = {
  __typename?: 'LoginJwtPayload';
  /** A list of failed validations. May be blank or null if mutation succeeded. */
  messages?: Maybe<Array<Maybe<ValidationMessage>>>;
  /** The object created/updated/deleted by the mutation. May be null if mutation failed. */
  result?: Maybe<LoginJwt>;
  /** Indicates if the mutation completed successfully or not. */
  successful: Scalars['Boolean']['output'];
};

export type Money = {
  __typename?: 'Money';
  amount: Scalars['Int']['output'];
  currency: Scalars['String']['output'];
};

export type RootMutationType = {
  __typename?: 'RootMutationType';
  changePassword?: Maybe<User>;
  createIjustEvent?: Maybe<IjustEvent>;
  createTeam?: Maybe<Team>;
  deleteTeam?: Maybe<Team>;
  ijustAddOccurrenceToEvent?: Maybe<IjustOccurrence>;
  ijustDeleteOccurrence?: Maybe<IjustOccurrence>;
  joinTeam?: Maybe<Team>;
  leaveTeam?: Maybe<Team>;
  login?: Maybe<LoginJwtPayload>;
  refreshToken?: Maybe<LoginJwtPayload>;
  renameTeam?: Maybe<Team>;
  signup?: Maybe<LoginJwtPayload>;
  twitchChannelSubscribe?: Maybe<TwitchChannel>;
  twitchChannelUnsubscribe?: Maybe<TwitchChannel>;
  twitchRemoveIntegration?: Maybe<TwitchUser>;
  updateIjustEvent?: Maybe<IjustEventPayload>;
  updateUser?: Maybe<User>;
};


export type RootMutationTypeChangePasswordArgs = {
  currentPassword: Scalars['String']['input'];
  newPassword: Scalars['String']['input'];
};


export type RootMutationTypeCreateIjustEventArgs = {
  ijustContextId: Scalars['ID']['input'];
  name: Scalars['String']['input'];
};


export type RootMutationTypeCreateTeamArgs = {
  name: Scalars['String']['input'];
};


export type RootMutationTypeDeleteTeamArgs = {
  id: Scalars['ID']['input'];
};


export type RootMutationTypeIjustAddOccurrenceToEventArgs = {
  ijustEventId: Scalars['ID']['input'];
};


export type RootMutationTypeIjustDeleteOccurrenceArgs = {
  ijustOccurrenceId: Scalars['ID']['input'];
};


export type RootMutationTypeJoinTeamArgs = {
  name: Scalars['String']['input'];
};


export type RootMutationTypeLeaveTeamArgs = {
  id: Scalars['ID']['input'];
};


export type RootMutationTypeLoginArgs = {
  email: Scalars['String']['input'];
  password: Scalars['String']['input'];
};


export type RootMutationTypeRefreshTokenArgs = {
  refreshToken: Scalars['String']['input'];
};


export type RootMutationTypeRenameTeamArgs = {
  id: Scalars['ID']['input'];
  name: Scalars['String']['input'];
};


export type RootMutationTypeSignupArgs = {
  email: Scalars['String']['input'];
  password: Scalars['String']['input'];
};


export type RootMutationTypeTwitchChannelSubscribeArgs = {
  channel: Scalars['String']['input'];
};


export type RootMutationTypeTwitchChannelUnsubscribeArgs = {
  name: Scalars['String']['input'];
};


export type RootMutationTypeUpdateIjustEventArgs = {
  cost?: InputMaybe<Scalars['Int']['input']>;
  id: Scalars['ID']['input'];
  name?: InputMaybe<Scalars['String']['input']>;
};


export type RootMutationTypeUpdateUserArgs = {
  email?: InputMaybe<Scalars['String']['input']>;
  id: Scalars['ID']['input'];
  password?: InputMaybe<Scalars['String']['input']>;
};

export type RootQueryType = {
  __typename?: 'RootQueryType';
  getCurrentUser?: Maybe<User>;
  getIjustContext?: Maybe<IjustContext>;
  getIjustContextEvent?: Maybe<IjustEvent>;
  getIjustContexts?: Maybe<Array<Maybe<IjustContext>>>;
  getIjustDefaultContext?: Maybe<IjustContext>;
  getIjustEventOccurrences?: Maybe<Array<Maybe<IjustOccurrence>>>;
  getIjustRecentEvents?: Maybe<Array<Maybe<IjustEvent>>>;
  getOneTimeLoginLink?: Maybe<Scalars['String']['output']>;
  getTeam?: Maybe<Team>;
  getTeamUser?: Maybe<User>;
  getTeamUsers?: Maybe<Array<Maybe<User>>>;
  getTeams?: Maybe<Array<Maybe<Team>>>;
  getTwitchChannel?: Maybe<TwitchChannel>;
  getTwitchChannels?: Maybe<Array<Maybe<TwitchChannel>>>;
  getTwitchUser?: Maybe<TwitchUser>;
  getUser?: Maybe<User>;
  ijustEventsSearch?: Maybe<Array<Maybe<IjustEvent>>>;
};


export type RootQueryTypeGetIjustContextArgs = {
  id: Scalars['ID']['input'];
};


export type RootQueryTypeGetIjustContextEventArgs = {
  contextId: Scalars['ID']['input'];
  eventId: Scalars['ID']['input'];
};


export type RootQueryTypeGetIjustEventOccurrencesArgs = {
  eventId: Scalars['ID']['input'];
  offset?: InputMaybe<Scalars['Int']['input']>;
};


export type RootQueryTypeGetIjustRecentEventsArgs = {
  contextId: Scalars['ID']['input'];
};


export type RootQueryTypeGetTeamArgs = {
  id: Scalars['ID']['input'];
};


export type RootQueryTypeGetTeamUserArgs = {
  teamId: Scalars['ID']['input'];
  userId: Scalars['ID']['input'];
};


export type RootQueryTypeGetTeamUsersArgs = {
  teamId: Scalars['ID']['input'];
};


export type RootQueryTypeGetTwitchChannelArgs = {
  channelName: Scalars['String']['input'];
};


export type RootQueryTypeGetUserArgs = {
  email?: InputMaybe<Scalars['String']['input']>;
  id?: InputMaybe<Scalars['ID']['input']>;
};


export type RootQueryTypeIjustEventsSearchArgs = {
  ijustContextId: Scalars['ID']['input'];
  name: Scalars['String']['input'];
};

export type Team = {
  __typename?: 'Team';
  id: Scalars['ID']['output'];
  insertedAt: Scalars['String']['output'];
  name: Scalars['String']['output'];
  updatedAt: Scalars['String']['output'];
};

export type TwitchChannel = {
  __typename?: 'TwitchChannel';
  id: Scalars['ID']['output'];
  insertedAt: Scalars['String']['output'];
  name: Scalars['String']['output'];
  updatedAt: Scalars['String']['output'];
  userId: Scalars['ID']['output'];
};

export type TwitchUser = {
  __typename?: 'TwitchUser';
  displayName: Scalars['String']['output'];
  email: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  twitchUserId: Scalars['String']['output'];
  userId: Scalars['String']['output'];
};

export type User = {
  __typename?: 'User';
  email: Scalars['String']['output'];
  id: Scalars['ID']['output'];
  insertedAt: Scalars['String']['output'];
  updatedAt: Scalars['String']['output'];
};

/**
 * Validation messages are returned when mutation input does not meet the requirements.
 *   While client-side validation is highly recommended to provide the best User Experience,
 *   All inputs will always be validated server-side.
 *
 *   Some examples of validations are:
 *
 *   * Username must be at least 10 characters
 *   * Email field does not contain an email address
 *   * Birth Date is required
 *
 *   While GraphQL has support for required values, mutation data fields are always
 *   set to optional in our API. This allows 'required field' messages
 *   to be returned in the same manner as other validations. The only exceptions
 *   are id fields, which may be required to perform updates or deletes.
 */
export type ValidationMessage = {
  __typename?: 'ValidationMessage';
  /** A unique error code for the type of validation used. */
  code: Scalars['String']['output'];
  /**
   * The input field that the error applies to. The field can be used to
   * identify which field the error message should be displayed next to in the
   * presentation layer.
   *
   * If there are multiple errors to display for a field, multiple validation
   * messages will be in the result.
   *
   * This field may be null in cases where an error cannot be applied to a specific field.
   */
  field?: Maybe<Scalars['String']['output']>;
  /**
   * A friendly error message, appropriate for display to the end user.
   *
   * The message is interpolated to include the appropriate variables.
   *
   * Example: `Username must be at least 10 characters`
   *
   * This message may change without notice, so we do not recommend you match against the text.
   * Instead, use the *code* field for matching.
   */
  message?: Maybe<Scalars['String']['output']>;
  /** A list of substitutions to be applied to a validation message template */
  options?: Maybe<Array<Maybe<ValidationOption>>>;
  /**
   * A template used to generate the error message, with placeholders for option substitution.
   *
   * Example: `Username must be at least {count} characters`
   *
   * This message may change without notice, so we do not recommend you match against the text.
   * Instead, use the *code* field for matching.
   */
  template?: Maybe<Scalars['String']['output']>;
};

export type ValidationOption = {
  __typename?: 'ValidationOption';
  /** The name of a variable to be substituted in a validation message template */
  key: Scalars['String']['output'];
  /** The value of a variable to be substituted in a validation message template */
  value: Scalars['String']['output'];
};

export type ChangePasswordMutationVariables = Exact<{
  currentPassword: Scalars['String']['input'];
  newPassword: Scalars['String']['input'];
}>;


export type ChangePasswordMutation = { __typename?: 'RootMutationType', changePassword?: { __typename?: 'User', id: string } | null };

export type CurrentUserDocumentQueryVariables = Exact<{ [key: string]: never; }>;


export type CurrentUserDocumentQuery = { __typename?: 'RootQueryType', getCurrentUser?: { __typename?: 'User', id: string, email: string } | null };

export type GetThisTwitchUserQueryVariables = Exact<{ [key: string]: never; }>;


export type GetThisTwitchUserQuery = { __typename?: 'RootQueryType', getTwitchUser?: { __typename?: 'TwitchUser', id: string, displayName: string } | null };

export type TwitchRemoveIntegrationMutationVariables = Exact<{ [key: string]: never; }>;


export type TwitchRemoveIntegrationMutation = { __typename?: 'RootMutationType', twitchRemoveIntegration?: { __typename?: 'TwitchUser', id: string } | null };

export type LoginMutationVariables = Exact<{
  email: Scalars['String']['input'];
  password: Scalars['String']['input'];
}>;


export type LoginMutation = { __typename?: 'RootMutationType', login?: { __typename?: 'LoginJwtPayload', messages?: Array<{ __typename?: 'ValidationMessage', message?: string | null } | null> | null, result?: { __typename?: 'LoginJwt', accessToken: string, refreshToken: string, user: { __typename?: 'User', id: string, email: string } } | null } | null };

export type GetCurrentUserQueryVariables = Exact<{ [key: string]: never; }>;


export type GetCurrentUserQuery = { __typename?: 'RootQueryType', getCurrentUser?: { __typename?: 'User', id: string, email: string } | null };

export type GetOneTimeLoginLinkQueryVariables = Exact<{ [key: string]: never; }>;


export type GetOneTimeLoginLinkQuery = { __typename?: 'RootQueryType', getOneTimeLoginLink?: string | null };

export type SignupMutationVariables = Exact<{
  email: Scalars['String']['input'];
  password: Scalars['String']['input'];
}>;


export type SignupMutation = { __typename?: 'RootMutationType', signup?: { __typename?: 'LoginJwtPayload', successful: boolean, messages?: Array<{ __typename?: 'ValidationMessage', message?: string | null } | null> | null, result?: { __typename?: 'LoginJwt', accessToken: string, refreshToken: string, user: { __typename?: 'User', id: string, email: string } } | null } | null };

export type CreateTeamMutationVariables = Exact<{
  name: Scalars['String']['input'];
}>;


export type CreateTeamMutation = { __typename?: 'RootMutationType', createTeam?: { __typename?: 'Team', id: string, name: string } | null };

export type DeleteTeamMutationVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type DeleteTeamMutation = { __typename?: 'RootMutationType', deleteTeam?: { __typename?: 'Team', id: string } | null };

export type JoinTeamMutationVariables = Exact<{
  name: Scalars['String']['input'];
}>;


export type JoinTeamMutation = { __typename?: 'RootMutationType', joinTeam?: { __typename?: 'Team', id: string, name: string } | null };

export type LeaveTeamMutationVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type LeaveTeamMutation = { __typename?: 'RootMutationType', leaveTeam?: { __typename?: 'Team', id: string } | null };

export type GetTeamsQueryVariables = Exact<{ [key: string]: never; }>;


export type GetTeamsQuery = { __typename?: 'RootQueryType', getTeams?: Array<{ __typename?: 'Team', id: string, name: string } | null> | null };

export type RenameTeamMutationVariables = Exact<{
  id: Scalars['ID']['input'];
  name: Scalars['String']['input'];
}>;


export type RenameTeamMutation = { __typename?: 'RootMutationType', renameTeam?: { __typename?: 'Team', id: string, name: string } | null };

export type GetTeamUsersQueryVariables = Exact<{
  teamId: Scalars['ID']['input'];
}>;


export type GetTeamUsersQuery = { __typename?: 'RootQueryType', getTeamUsers?: Array<{ __typename?: 'User', email: string, id: string } | null> | null };

export type IjustAddOccurrenceToEventMutationVariables = Exact<{
  ijustEventId: Scalars['ID']['input'];
}>;


export type IjustAddOccurrenceToEventMutation = { __typename?: 'RootMutationType', ijustAddOccurrenceToEvent?: { __typename?: 'IjustOccurrence', id: string, insertedAt: string, isDeleted?: boolean | null, ijustEvent?: { __typename?: 'IjustEvent', id: string, ijustContextId: string } | null } | null };

export type UpdateIjustEventMutationVariables = Exact<{
  id: Scalars['ID']['input'];
  name?: InputMaybe<Scalars['String']['input']>;
  cost?: InputMaybe<Scalars['Int']['input']>;
}>;


export type UpdateIjustEventMutation = { __typename?: 'RootMutationType', updateIjustEvent?: { __typename?: 'IjustEventPayload', successful: boolean, messages?: Array<{ __typename?: 'ValidationMessage', message?: string | null, field?: string | null } | null> | null, result?: { __typename?: 'IjustEvent', id: string, name: string, cost?: { __typename?: 'Money', amount: number, currency: string } | null } | null } | null };

export type CreateIjustEventMutationVariables = Exact<{
  ijustContextId: Scalars['ID']['input'];
  eventName: Scalars['String']['input'];
}>;


export type CreateIjustEventMutation = { __typename?: 'RootMutationType', createIjustEvent?: { __typename?: 'IjustEvent', id: string, name: string, count: number, insertedAt: string, updatedAt: string, ijustContextId: string } | null };

export type GetIjustContextEventQueryVariables = Exact<{
  contextId: Scalars['ID']['input'];
  eventId: Scalars['ID']['input'];
}>;


export type GetIjustContextEventQuery = { __typename?: 'RootQueryType', getIjustContextEvent?: { __typename?: 'IjustEvent', id: string, ijustContextId: string, ijustOccurrences?: Array<{ __typename?: 'IjustOccurrence', id: string, insertedAt: string, updatedAt: string, isDeleted?: boolean | null } | null> | null } | null };

export type IjustDeleteOccurrenceMutationVariables = Exact<{
  occurrenceId: Scalars['ID']['input'];
}>;


export type IjustDeleteOccurrenceMutation = { __typename?: 'RootMutationType', ijustDeleteOccurrence?: { __typename?: 'IjustOccurrence', id: string, ijustEventId: string } | null };

export type GetIjustRecentEventsQueryVariables = Exact<{
  contextId: Scalars['ID']['input'];
}>;


export type GetIjustRecentEventsQuery = { __typename?: 'RootQueryType', getIjustRecentEvents?: Array<{ __typename?: 'IjustEvent', id: string, name: string, count: number, insertedAt: string, updatedAt: string, ijustContextId: string } | null> | null };

export type TwitchChannelUnsubscribeMutationVariables = Exact<{
  name: Scalars['String']['input'];
}>;


export type TwitchChannelUnsubscribeMutation = { __typename?: 'RootMutationType', twitchChannelUnsubscribe?: { __typename?: 'TwitchChannel', id: string } | null };

export type TwitchChannelSubscribeMutationVariables = Exact<{
  channel: Scalars['String']['input'];
}>;


export type TwitchChannelSubscribeMutation = { __typename?: 'RootMutationType', twitchChannelSubscribe?: { __typename?: 'TwitchChannel', id: string, name: string, userId: string } | null };

export type GetIjustContextQueryVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type GetIjustContextQuery = { __typename?: 'RootQueryType', getIjustContext?: { __typename?: 'IjustContext', id: string, name: string, userId: string } | null };

export type GetIjustContextsQueryQueryVariables = Exact<{ [key: string]: never; }>;


export type GetIjustContextsQueryQuery = { __typename?: 'RootQueryType', getIjustContexts?: Array<{ __typename?: 'IjustContext', id: string, name: string } | null> | null };

export type GetIjustDefaultContextQueryQueryVariables = Exact<{ [key: string]: never; }>;


export type GetIjustDefaultContextQueryQuery = { __typename?: 'RootQueryType', getIjustDefaultContext?: { __typename?: 'IjustContext', id: string, name: string, userId: string } | null };

export type GetTeamQueryVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type GetTeamQuery = { __typename?: 'RootQueryType', getTeam?: { __typename?: 'Team', name: string, id: string } | null };

export type GetTeamUserQueryVariables = Exact<{
  teamId: Scalars['ID']['input'];
  userId: Scalars['ID']['input'];
}>;


export type GetTeamUserQuery = { __typename?: 'RootQueryType', getTeamUser?: { __typename?: 'User', email: string, id: string } | null };

export type GetTwitchUserQueryVariables = Exact<{ [key: string]: never; }>;


export type GetTwitchUserQuery = { __typename?: 'RootQueryType', getTwitchUser?: { __typename?: 'TwitchUser', id: string, displayName: string } | null };

export type GetTwitchChannelsQueryVariables = Exact<{ [key: string]: never; }>;


export type GetTwitchChannelsQuery = { __typename?: 'RootQueryType', getTwitchChannels?: Array<{ __typename?: 'TwitchChannel', id: string, name: string, userId: string } | null> | null };

export type GetEventQueryVariables = Exact<{
  contextId: Scalars['ID']['input'];
  eventId: Scalars['ID']['input'];
}>;


export type GetEventQuery = { __typename?: 'RootQueryType', getIjustContextEvent?: { __typename?: 'IjustEvent', id: string, name: string, count: number, insertedAt: string, updatedAt: string, ijustContextId: string, cost?: { __typename?: 'Money', amount: number, currency: string } | null, ijustContext: { __typename?: 'IjustContext', id: string, name: string } } | null };

export type GetTwitchChannelQueryVariables = Exact<{
  channelName: Scalars['String']['input'];
}>;


export type GetTwitchChannelQuery = { __typename?: 'RootQueryType', getTwitchChannel?: { __typename?: 'TwitchChannel', id: string, name: string } | null };

export type IjustEventsSearchQueryVariables = Exact<{
  ijustContextId: Scalars['ID']['input'];
  eventName: Scalars['String']['input'];
}>;


export type IjustEventsSearchQuery = { __typename?: 'RootQueryType', ijustEventsSearch?: Array<{ __typename?: 'IjustEvent', id: string, name: string, count: number, insertedAt: string, updatedAt: string, ijustContextId: string } | null> | null };

export type RefreshTokenMutationVariables = Exact<{
  refreshToken: Scalars['String']['input'];
}>;


export type RefreshTokenMutation = { __typename?: 'RootMutationType', refreshToken?: { __typename?: 'LoginJwtPayload', result?: { __typename: 'LoginJwt', accessToken: string, refreshToken: string } | null } | null };

export type GetIjustContextEventCacheQueryVariables = Exact<{
  contextId: Scalars['ID']['input'];
  eventId: Scalars['ID']['input'];
}>;


export type GetIjustContextEventCacheQuery = { __typename?: 'RootQueryType', getIjustContextEvent?: { __typename?: 'IjustEvent', id: string, ijustOccurrences?: Array<{ __typename?: 'IjustOccurrence', id: string, insertedAt: string, updatedAt: string, isDeleted?: boolean | null } | null> | null } | null };

export type GetTwitchChannelsCacheQueryVariables = Exact<{ [key: string]: never; }>;


export type GetTwitchChannelsCacheQuery = { __typename?: 'RootQueryType', getTwitchChannels?: Array<{ __typename?: 'TwitchChannel', id: string } | null> | null };

export type GetTwitchChannelsCache2QueryVariables = Exact<{ [key: string]: never; }>;


export type GetTwitchChannelsCache2Query = { __typename?: 'RootQueryType', getTwitchChannels?: Array<{ __typename?: 'TwitchChannel', name: string } | null> | null };

export type GetTwitchUserCacheQueryVariables = Exact<{ [key: string]: never; }>;


export type GetTwitchUserCacheQuery = { __typename?: 'RootQueryType', getTwitchUser?: { __typename?: 'TwitchUser', id: string } | null };


export const ChangePasswordDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"ChangePassword"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"currentPassword"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"newPassword"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"changePassword"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"currentPassword"},"value":{"kind":"Variable","name":{"kind":"Name","value":"currentPassword"}}},{"kind":"Argument","name":{"kind":"Name","value":"newPassword"},"value":{"kind":"Variable","name":{"kind":"Name","value":"newPassword"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<ChangePasswordMutation, ChangePasswordMutationVariables>;
export const CurrentUserDocumentDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"currentUserDocument"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getCurrentUser"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"email"}}]}}]}}]} as unknown as DocumentNode<CurrentUserDocumentQuery, CurrentUserDocumentQueryVariables>;
export const GetThisTwitchUserDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetThisTwitchUser"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTwitchUser"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"displayName"}}]}}]}}]} as unknown as DocumentNode<GetThisTwitchUserQuery, GetThisTwitchUserQueryVariables>;
export const TwitchRemoveIntegrationDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"TwitchRemoveIntegration"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"twitchRemoveIntegration"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<TwitchRemoveIntegrationMutation, TwitchRemoveIntegrationMutationVariables>;
export const LoginDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"Login"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"email"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"password"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"login"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"email"},"value":{"kind":"Variable","name":{"kind":"Name","value":"email"}}},{"kind":"Argument","name":{"kind":"Name","value":"password"},"value":{"kind":"Variable","name":{"kind":"Name","value":"password"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"messages"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"message"}}]}},{"kind":"Field","name":{"kind":"Name","value":"result"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"user"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"email"}}]}},{"kind":"Field","name":{"kind":"Name","value":"accessToken"}},{"kind":"Field","name":{"kind":"Name","value":"refreshToken"}}]}}]}}]}}]} as unknown as DocumentNode<LoginMutation, LoginMutationVariables>;
export const GetCurrentUserDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetCurrentUser"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getCurrentUser"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"email"}}]}}]}}]} as unknown as DocumentNode<GetCurrentUserQuery, GetCurrentUserQueryVariables>;
export const GetOneTimeLoginLinkDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetOneTimeLoginLink"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getOneTimeLoginLink"}}]}}]} as unknown as DocumentNode<GetOneTimeLoginLinkQuery, GetOneTimeLoginLinkQueryVariables>;
export const SignupDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"Signup"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"email"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"password"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"signup"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"email"},"value":{"kind":"Variable","name":{"kind":"Name","value":"email"}}},{"kind":"Argument","name":{"kind":"Name","value":"password"},"value":{"kind":"Variable","name":{"kind":"Name","value":"password"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"messages"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"message"}}]}},{"kind":"Field","name":{"kind":"Name","value":"result"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"user"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"email"}}]}},{"kind":"Field","name":{"kind":"Name","value":"accessToken"}},{"kind":"Field","name":{"kind":"Name","value":"refreshToken"}}]}},{"kind":"Field","name":{"kind":"Name","value":"successful"}}]}}]}}]} as unknown as DocumentNode<SignupMutation, SignupMutationVariables>;
export const CreateTeamDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"CreateTeam"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"name"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"createTeam"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"name"},"value":{"kind":"Variable","name":{"kind":"Name","value":"name"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}}]} as unknown as DocumentNode<CreateTeamMutation, CreateTeamMutationVariables>;
export const DeleteTeamDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"DeleteTeam"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"id"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"deleteTeam"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"id"},"value":{"kind":"Variable","name":{"kind":"Name","value":"id"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<DeleteTeamMutation, DeleteTeamMutationVariables>;
export const JoinTeamDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"JoinTeam"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"name"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"joinTeam"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"name"},"value":{"kind":"Variable","name":{"kind":"Name","value":"name"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}}]} as unknown as DocumentNode<JoinTeamMutation, JoinTeamMutationVariables>;
export const LeaveTeamDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"LeaveTeam"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"id"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"leaveTeam"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"id"},"value":{"kind":"Variable","name":{"kind":"Name","value":"id"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<LeaveTeamMutation, LeaveTeamMutationVariables>;
export const GetTeamsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetTeams"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTeams"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}}]} as unknown as DocumentNode<GetTeamsQuery, GetTeamsQueryVariables>;
export const RenameTeamDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"RenameTeam"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"id"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"name"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"renameTeam"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"id"},"value":{"kind":"Variable","name":{"kind":"Name","value":"id"}}},{"kind":"Argument","name":{"kind":"Name","value":"name"},"value":{"kind":"Variable","name":{"kind":"Name","value":"name"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}}]} as unknown as DocumentNode<RenameTeamMutation, RenameTeamMutationVariables>;
export const GetTeamUsersDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetTeamUsers"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"teamId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTeamUsers"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"teamId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"teamId"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"email"}},{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<GetTeamUsersQuery, GetTeamUsersQueryVariables>;
export const IjustAddOccurrenceToEventDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"IjustAddOccurrenceToEvent"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"ijustEventId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"ijustAddOccurrenceToEvent"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"ijustEventId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"ijustEventId"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}},{"kind":"Field","name":{"kind":"Name","value":"isDeleted"}},{"kind":"Field","name":{"kind":"Name","value":"ijustEvent"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"ijustContextId"}}]}}]}}]}}]} as unknown as DocumentNode<IjustAddOccurrenceToEventMutation, IjustAddOccurrenceToEventMutationVariables>;
export const UpdateIjustEventDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"UpdateIjustEvent"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"id"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"name"}},"type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"cost"}},"type":{"kind":"NamedType","name":{"kind":"Name","value":"Int"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"updateIjustEvent"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"id"},"value":{"kind":"Variable","name":{"kind":"Name","value":"id"}}},{"kind":"Argument","name":{"kind":"Name","value":"name"},"value":{"kind":"Variable","name":{"kind":"Name","value":"name"}}},{"kind":"Argument","name":{"kind":"Name","value":"cost"},"value":{"kind":"Variable","name":{"kind":"Name","value":"cost"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"successful"}},{"kind":"Field","name":{"kind":"Name","value":"messages"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"message"}},{"kind":"Field","name":{"kind":"Name","value":"field"}}]}},{"kind":"Field","name":{"kind":"Name","value":"result"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"cost"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"amount"}},{"kind":"Field","name":{"kind":"Name","value":"currency"}}]}}]}}]}}]}}]} as unknown as DocumentNode<UpdateIjustEventMutation, UpdateIjustEventMutationVariables>;
export const CreateIjustEventDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"CreateIjustEvent"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"ijustContextId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"eventName"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"createIjustEvent"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"ijustContextId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"ijustContextId"}}},{"kind":"Argument","name":{"kind":"Name","value":"name"},"value":{"kind":"Variable","name":{"kind":"Name","value":"eventName"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"count"}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}},{"kind":"Field","name":{"kind":"Name","value":"updatedAt"}},{"kind":"Field","name":{"kind":"Name","value":"ijustContextId"}}]}}]}}]} as unknown as DocumentNode<CreateIjustEventMutation, CreateIjustEventMutationVariables>;
export const GetIjustContextEventDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetIjustContextEvent"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"contextId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"eventId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getIjustContextEvent"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"contextId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"contextId"}}},{"kind":"Argument","name":{"kind":"Name","value":"eventId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"eventId"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"ijustContextId"}},{"kind":"Field","name":{"kind":"Name","value":"ijustOccurrences"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}},{"kind":"Field","name":{"kind":"Name","value":"updatedAt"}},{"kind":"Field","name":{"kind":"Name","value":"isDeleted"}}]}}]}}]}}]} as unknown as DocumentNode<GetIjustContextEventQuery, GetIjustContextEventQueryVariables>;
export const IjustDeleteOccurrenceDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"IjustDeleteOccurrence"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"occurrenceId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"ijustDeleteOccurrence"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"ijustOccurrenceId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"occurrenceId"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"ijustEventId"}}]}}]}}]} as unknown as DocumentNode<IjustDeleteOccurrenceMutation, IjustDeleteOccurrenceMutationVariables>;
export const GetIjustRecentEventsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetIjustRecentEvents"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"contextId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getIjustRecentEvents"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"contextId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"contextId"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"count"}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}},{"kind":"Field","name":{"kind":"Name","value":"updatedAt"}},{"kind":"Field","name":{"kind":"Name","value":"ijustContextId"}}]}}]}}]} as unknown as DocumentNode<GetIjustRecentEventsQuery, GetIjustRecentEventsQueryVariables>;
export const TwitchChannelUnsubscribeDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"TwitchChannelUnsubscribe"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"name"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"twitchChannelUnsubscribe"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"name"},"value":{"kind":"Variable","name":{"kind":"Name","value":"name"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<TwitchChannelUnsubscribeMutation, TwitchChannelUnsubscribeMutationVariables>;
export const TwitchChannelSubscribeDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"TwitchChannelSubscribe"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"channel"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"twitchChannelSubscribe"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"channel"},"value":{"kind":"Variable","name":{"kind":"Name","value":"channel"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"userId"}}]}}]}}]} as unknown as DocumentNode<TwitchChannelSubscribeMutation, TwitchChannelSubscribeMutationVariables>;
export const GetIjustContextDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetIjustContext"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"id"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getIjustContext"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"id"},"value":{"kind":"Variable","name":{"kind":"Name","value":"id"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"userId"}}]}}]}}]} as unknown as DocumentNode<GetIjustContextQuery, GetIjustContextQueryVariables>;
export const GetIjustContextsQueryDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetIjustContextsQuery"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getIjustContexts"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}}]} as unknown as DocumentNode<GetIjustContextsQueryQuery, GetIjustContextsQueryQueryVariables>;
export const GetIjustDefaultContextQueryDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetIjustDefaultContextQuery"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getIjustDefaultContext"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"userId"}}]}}]}}]} as unknown as DocumentNode<GetIjustDefaultContextQueryQuery, GetIjustDefaultContextQueryQueryVariables>;
export const GetTeamDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetTeam"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"id"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTeam"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"id"},"value":{"kind":"Variable","name":{"kind":"Name","value":"id"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<GetTeamQuery, GetTeamQueryVariables>;
export const GetTeamUserDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetTeamUser"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"teamId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"userId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTeamUser"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"teamId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"teamId"}}},{"kind":"Argument","name":{"kind":"Name","value":"userId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"userId"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"email"}},{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<GetTeamUserQuery, GetTeamUserQueryVariables>;
export const GetTwitchUserDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetTwitchUser"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTwitchUser"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"displayName"}}]}}]}}]} as unknown as DocumentNode<GetTwitchUserQuery, GetTwitchUserQueryVariables>;
export const GetTwitchChannelsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetTwitchChannels"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTwitchChannels"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"userId"}}]}}]}}]} as unknown as DocumentNode<GetTwitchChannelsQuery, GetTwitchChannelsQueryVariables>;
export const GetEventDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetEvent"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"contextId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"eventId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getIjustContextEvent"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"contextId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"contextId"}}},{"kind":"Argument","name":{"kind":"Name","value":"eventId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"eventId"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"count"}},{"kind":"Field","name":{"kind":"Name","value":"cost"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"amount"}},{"kind":"Field","name":{"kind":"Name","value":"currency"}}]}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}},{"kind":"Field","name":{"kind":"Name","value":"updatedAt"}},{"kind":"Field","name":{"kind":"Name","value":"ijustContextId"}},{"kind":"Field","name":{"kind":"Name","value":"ijustContext"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}}]}}]} as unknown as DocumentNode<GetEventQuery, GetEventQueryVariables>;
export const GetTwitchChannelDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetTwitchChannel"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"channelName"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTwitchChannel"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"channelName"},"value":{"kind":"Variable","name":{"kind":"Name","value":"channelName"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}}]} as unknown as DocumentNode<GetTwitchChannelQuery, GetTwitchChannelQueryVariables>;
export const IjustEventsSearchDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"IjustEventsSearch"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"ijustContextId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"eventName"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"ijustEventsSearch"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"ijustContextId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"ijustContextId"}}},{"kind":"Argument","name":{"kind":"Name","value":"name"},"value":{"kind":"Variable","name":{"kind":"Name","value":"eventName"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"name"}},{"kind":"Field","name":{"kind":"Name","value":"count"}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}},{"kind":"Field","name":{"kind":"Name","value":"updatedAt"}},{"kind":"Field","name":{"kind":"Name","value":"ijustContextId"}}]}}]}}]} as unknown as DocumentNode<IjustEventsSearchQuery, IjustEventsSearchQueryVariables>;
export const RefreshTokenDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"RefreshToken"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"refreshToken"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"refreshToken"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"refreshToken"},"value":{"kind":"Variable","name":{"kind":"Name","value":"refreshToken"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"result"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"accessToken"}},{"kind":"Field","name":{"kind":"Name","value":"refreshToken"}},{"kind":"Field","name":{"kind":"Name","value":"__typename"}}]}}]}}]}}]} as unknown as DocumentNode<RefreshTokenMutation, RefreshTokenMutationVariables>;
export const GetIjustContextEventCacheDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetIjustContextEventCache"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"contextId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}},{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"eventId"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getIjustContextEvent"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"contextId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"contextId"}}},{"kind":"Argument","name":{"kind":"Name","value":"eventId"},"value":{"kind":"Variable","name":{"kind":"Name","value":"eventId"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"ijustOccurrences"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}},{"kind":"Field","name":{"kind":"Name","value":"updatedAt"}},{"kind":"Field","name":{"kind":"Name","value":"isDeleted"}}]}}]}}]}}]} as unknown as DocumentNode<GetIjustContextEventCacheQuery, GetIjustContextEventCacheQueryVariables>;
export const GetTwitchChannelsCacheDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetTwitchChannelsCache"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTwitchChannels"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<GetTwitchChannelsCacheQuery, GetTwitchChannelsCacheQueryVariables>;
export const GetTwitchChannelsCache2Document = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetTwitchChannelsCache2"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTwitchChannels"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"name"}}]}}]}}]} as unknown as DocumentNode<GetTwitchChannelsCache2Query, GetTwitchChannelsCache2QueryVariables>;
export const GetTwitchUserCacheDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetTwitchUserCache"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getTwitchUser"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<GetTwitchUserCacheQuery, GetTwitchUserCacheQueryVariables>;