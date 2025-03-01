/* eslint-disable */
import * as types from './graphql';
import { TypedDocumentNode as DocumentNode } from '@graphql-typed-document-node/core';

/**
 * Map of all GraphQL operations in the project.
 *
 * This map has several performance disadvantages:
 * 1. It is not tree-shakeable, so it will include all operations in the project.
 * 2. It is not minifiable, so the string of a GraphQL query will be multiple times inside the bundle.
 * 3. It does not support dead code elimination, so it will add unused operations.
 *
 * Therefore it is highly recommended to use the babel or swc plugin for production.
 * Learn more about it here: https://the-guild.dev/graphql/codegen/plugins/presets/preset-client#reducing-bundle-size
 */
type Documents = {
    "\n  mutation ChangePassword($currentPassword: String!, $newPassword: String!) {\n    changePassword(\n      currentPassword: $currentPassword\n      newPassword: $newPassword\n    ) {\n      id\n    }\n  }\n": typeof types.ChangePasswordDocument,
    "\n  query currentUserDocument {\n    getCurrentUser {\n      id\n      email\n    }\n  }\n": typeof types.CurrentUserDocumentDocument,
    "\n  query GetThisTwitchUser {\n    getTwitchUser {\n      id\n      displayName\n    }\n  }\n": typeof types.GetThisTwitchUserDocument,
    "\n  mutation TwitchRemoveIntegration {\n    twitchRemoveIntegration {\n      id\n    }\n  }\n": typeof types.TwitchRemoveIntegrationDocument,
    "\n  mutation Login($email: String!, $password: String!) {\n    login(email: $email, password: $password) {\n      messages {\n        message\n      }\n      result {\n        user {\n          id\n          email\n        }\n        accessToken\n        refreshToken\n      }\n    }\n  }\n": typeof types.LoginDocument,
    "\n  query GetCurrentUser {\n    getCurrentUser {\n      id\n      email\n    }\n  }\n": typeof types.GetCurrentUserDocument,
    "\n  query GetOneTimeLoginLink {\n    getOneTimeLoginLink\n  }\n": typeof types.GetOneTimeLoginLinkDocument,
    "\n  mutation Signup($email: String!, $password: String!) {\n    signup(email: $email, password: $password) {\n      messages {\n        message\n      }\n      result {\n        user {\n          id\n          email\n        }\n        accessToken\n        refreshToken\n      }\n      successful\n    }\n  }\n": typeof types.SignupDocument,
    "\n  mutation CreateTeam($name: String!) {\n    createTeam(name: $name) {\n      id\n      name\n    }\n  }\n": typeof types.CreateTeamDocument,
    "\n  mutation DeleteTeam($id: ID!) {\n    deleteTeam(id: $id) {\n      id\n    }\n  }\n": typeof types.DeleteTeamDocument,
    "\n  mutation JoinTeam($name: String!) {\n    joinTeam(name: $name) {\n      id\n      name\n    }\n  }\n": typeof types.JoinTeamDocument,
    "\n  mutation LeaveTeam($id: ID!) {\n    leaveTeam(id: $id) {\n      id\n    }\n  }\n": typeof types.LeaveTeamDocument,
    "\n  query GetTeams {\n    getTeams {\n      id\n      name\n    }\n  }\n": typeof types.GetTeamsDocument,
    "\n  mutation RenameTeam($id: ID!, $name: String!) {\n    renameTeam(id: $id, name: $name) {\n      id\n      name\n    }\n  }\n": typeof types.RenameTeamDocument,
    "\n  query GetTeamUsers($teamId: ID!) {\n    getTeamUsers(teamId: $teamId) {\n      email\n      id\n    }\n  }\n": typeof types.GetTeamUsersDocument,
    "\n  mutation IjustAddOccurrenceToEvent($ijustEventId: ID!) {\n    ijustAddOccurrenceToEvent(ijustEventId: $ijustEventId) {\n      id\n      insertedAt\n      isDeleted\n      ijustEvent {\n        id\n        ijustContextId\n      }\n    }\n  }\n": typeof types.IjustAddOccurrenceToEventDocument,
    "\n  mutation UpdateIjustEvent($id: ID!, $name: String, $cost: Int) {\n    updateIjustEvent(id: $id, name: $name, cost: $cost) {\n      successful\n      messages {\n        message\n        field\n      }\n      result {\n        id\n        name\n        cost {\n          amount\n          currency\n        }\n      }\n    }\n  }\n": typeof types.UpdateIjustEventDocument,
    "\n  mutation CreateIjustEvent($ijustContextId: ID!, $eventName: String!) {\n    createIjustEvent(ijustContextId: $ijustContextId, name: $eventName) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n": typeof types.CreateIjustEventDocument,
    "\n  query GetIjustContextEvent($contextId: ID!, $eventId: ID!) {\n    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n      id\n      ijustContextId\n      ijustOccurrences {\n        id\n        insertedAt\n        updatedAt\n        isDeleted\n      }\n    }\n  }\n": typeof types.GetIjustContextEventDocument,
    "\n  mutation IjustDeleteOccurrence($occurrenceId: ID!) {\n    ijustDeleteOccurrence(ijustOccurrenceId: $occurrenceId) {\n      id\n      ijustEventId\n    }\n  }\n": typeof types.IjustDeleteOccurrenceDocument,
    "\n  query GetIjustRecentEvents($contextId: ID!) {\n    getIjustRecentEvents(contextId: $contextId) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n": typeof types.GetIjustRecentEventsDocument,
    "\n  mutation TwitchChannelUnsubscribe($name: String!) {\n    twitchChannelUnsubscribe(name: $name) {\n      id\n    }\n  }\n": typeof types.TwitchChannelUnsubscribeDocument,
    "\n  mutation TwitchChannelSubscribe($channel: String!) {\n    twitchChannelSubscribe(channel: $channel) {\n      id\n      name\n      userId\n    }\n  }\n": typeof types.TwitchChannelSubscribeDocument,
    "\n  query GetIjustContext($id: ID!) {\n    getIjustContext(id: $id) {\n      id\n      name\n      userId\n    }\n  }\n": typeof types.GetIjustContextDocument,
    "\n  query GetIjustContextsQuery {\n    getIjustContexts {\n      id\n      name\n    }\n  }\n": typeof types.GetIjustContextsQueryDocument,
    "\n  query GetIjustDefaultContextQuery {\n    getIjustDefaultContext {\n      id\n      name\n      userId\n    }\n  }\n": typeof types.GetIjustDefaultContextQueryDocument,
    "\n  query GetTeam($id: ID!) {\n    getTeam(id: $id) {\n      name\n      id\n    }\n  }\n": typeof types.GetTeamDocument,
    "\n  query GetTeamUser($teamId: ID!, $userId: ID!) {\n    getTeamUser(teamId: $teamId, userId: $userId) {\n      email\n      id\n    }\n  }\n": typeof types.GetTeamUserDocument,
    "\n  query GetTwitchUser {\n    getTwitchUser {\n      id\n      displayName\n    }\n  }\n": typeof types.GetTwitchUserDocument,
    "\n  query GetTwitchChannels {\n    getTwitchChannels {\n      id\n      name\n      userId\n    }\n  }\n": typeof types.GetTwitchChannelsDocument,
    "\n  query GetEvent($contextId: ID!, $eventId: ID!) {\n    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n      id\n      name\n      count\n      cost {\n        amount\n        currency\n      }\n      insertedAt\n      updatedAt\n      ijustContextId\n      ijustContext {\n        id\n        name\n      }\n    }\n  }\n": typeof types.GetEventDocument,
    "\n  query GetTwitchChannel($channelName: String!) {\n    getTwitchChannel(channelName: $channelName) {\n      id\n      name\n    }\n  }\n": typeof types.GetTwitchChannelDocument,
    "\n  query IjustEventsSearch($ijustContextId: ID!, $eventName: String!) {\n    ijustEventsSearch(ijustContextId: $ijustContextId, name: $eventName) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n": typeof types.IjustEventsSearchDocument,
    "\n  mutation RefreshToken($refreshToken: String!) {\n    refreshToken(refreshToken: $refreshToken) {\n      result {\n        accessToken\n        refreshToken\n        __typename\n      }\n    }\n  }\n": typeof types.RefreshTokenDocument,
    "\n          query GetTeams {\n            getTeams {\n              id\n              name\n            }\n          }\n        ": typeof types.GetTeamsDocument,
    "\n          query GetIjustContextEventCache($contextId: ID!, $eventId: ID!) {\n            getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n              id\n              ijustOccurrences {\n                id\n                insertedAt\n                updatedAt\n                isDeleted\n              }\n            }\n          }\n        ": typeof types.GetIjustContextEventCacheDocument,
    "\n          query GetTwitchChannelsCache {\n            getTwitchChannels {\n              id\n            }\n          }\n        ": typeof types.GetTwitchChannelsCacheDocument,
    "\n          query GetTwitchChannelsCache2 {\n            getTwitchChannels {\n              name\n            }\n          }\n        ": typeof types.GetTwitchChannelsCache2Document,
    "\n          query GetTwitchUserCache {\n            getTwitchUser {\n              id\n            }\n          }\n        ": typeof types.GetTwitchUserCacheDocument,
};
const documents: Documents = {
    "\n  mutation ChangePassword($currentPassword: String!, $newPassword: String!) {\n    changePassword(\n      currentPassword: $currentPassword\n      newPassword: $newPassword\n    ) {\n      id\n    }\n  }\n": types.ChangePasswordDocument,
    "\n  query currentUserDocument {\n    getCurrentUser {\n      id\n      email\n    }\n  }\n": types.CurrentUserDocumentDocument,
    "\n  query GetThisTwitchUser {\n    getTwitchUser {\n      id\n      displayName\n    }\n  }\n": types.GetThisTwitchUserDocument,
    "\n  mutation TwitchRemoveIntegration {\n    twitchRemoveIntegration {\n      id\n    }\n  }\n": types.TwitchRemoveIntegrationDocument,
    "\n  mutation Login($email: String!, $password: String!) {\n    login(email: $email, password: $password) {\n      messages {\n        message\n      }\n      result {\n        user {\n          id\n          email\n        }\n        accessToken\n        refreshToken\n      }\n    }\n  }\n": types.LoginDocument,
    "\n  query GetCurrentUser {\n    getCurrentUser {\n      id\n      email\n    }\n  }\n": types.GetCurrentUserDocument,
    "\n  query GetOneTimeLoginLink {\n    getOneTimeLoginLink\n  }\n": types.GetOneTimeLoginLinkDocument,
    "\n  mutation Signup($email: String!, $password: String!) {\n    signup(email: $email, password: $password) {\n      messages {\n        message\n      }\n      result {\n        user {\n          id\n          email\n        }\n        accessToken\n        refreshToken\n      }\n      successful\n    }\n  }\n": types.SignupDocument,
    "\n  mutation CreateTeam($name: String!) {\n    createTeam(name: $name) {\n      id\n      name\n    }\n  }\n": types.CreateTeamDocument,
    "\n  mutation DeleteTeam($id: ID!) {\n    deleteTeam(id: $id) {\n      id\n    }\n  }\n": types.DeleteTeamDocument,
    "\n  mutation JoinTeam($name: String!) {\n    joinTeam(name: $name) {\n      id\n      name\n    }\n  }\n": types.JoinTeamDocument,
    "\n  mutation LeaveTeam($id: ID!) {\n    leaveTeam(id: $id) {\n      id\n    }\n  }\n": types.LeaveTeamDocument,
    "\n  query GetTeams {\n    getTeams {\n      id\n      name\n    }\n  }\n": types.GetTeamsDocument,
    "\n  mutation RenameTeam($id: ID!, $name: String!) {\n    renameTeam(id: $id, name: $name) {\n      id\n      name\n    }\n  }\n": types.RenameTeamDocument,
    "\n  query GetTeamUsers($teamId: ID!) {\n    getTeamUsers(teamId: $teamId) {\n      email\n      id\n    }\n  }\n": types.GetTeamUsersDocument,
    "\n  mutation IjustAddOccurrenceToEvent($ijustEventId: ID!) {\n    ijustAddOccurrenceToEvent(ijustEventId: $ijustEventId) {\n      id\n      insertedAt\n      isDeleted\n      ijustEvent {\n        id\n        ijustContextId\n      }\n    }\n  }\n": types.IjustAddOccurrenceToEventDocument,
    "\n  mutation UpdateIjustEvent($id: ID!, $name: String, $cost: Int) {\n    updateIjustEvent(id: $id, name: $name, cost: $cost) {\n      successful\n      messages {\n        message\n        field\n      }\n      result {\n        id\n        name\n        cost {\n          amount\n          currency\n        }\n      }\n    }\n  }\n": types.UpdateIjustEventDocument,
    "\n  mutation CreateIjustEvent($ijustContextId: ID!, $eventName: String!) {\n    createIjustEvent(ijustContextId: $ijustContextId, name: $eventName) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n": types.CreateIjustEventDocument,
    "\n  query GetIjustContextEvent($contextId: ID!, $eventId: ID!) {\n    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n      id\n      ijustContextId\n      ijustOccurrences {\n        id\n        insertedAt\n        updatedAt\n        isDeleted\n      }\n    }\n  }\n": types.GetIjustContextEventDocument,
    "\n  mutation IjustDeleteOccurrence($occurrenceId: ID!) {\n    ijustDeleteOccurrence(ijustOccurrenceId: $occurrenceId) {\n      id\n      ijustEventId\n    }\n  }\n": types.IjustDeleteOccurrenceDocument,
    "\n  query GetIjustRecentEvents($contextId: ID!) {\n    getIjustRecentEvents(contextId: $contextId) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n": types.GetIjustRecentEventsDocument,
    "\n  mutation TwitchChannelUnsubscribe($name: String!) {\n    twitchChannelUnsubscribe(name: $name) {\n      id\n    }\n  }\n": types.TwitchChannelUnsubscribeDocument,
    "\n  mutation TwitchChannelSubscribe($channel: String!) {\n    twitchChannelSubscribe(channel: $channel) {\n      id\n      name\n      userId\n    }\n  }\n": types.TwitchChannelSubscribeDocument,
    "\n  query GetIjustContext($id: ID!) {\n    getIjustContext(id: $id) {\n      id\n      name\n      userId\n    }\n  }\n": types.GetIjustContextDocument,
    "\n  query GetIjustContextsQuery {\n    getIjustContexts {\n      id\n      name\n    }\n  }\n": types.GetIjustContextsQueryDocument,
    "\n  query GetIjustDefaultContextQuery {\n    getIjustDefaultContext {\n      id\n      name\n      userId\n    }\n  }\n": types.GetIjustDefaultContextQueryDocument,
    "\n  query GetTeam($id: ID!) {\n    getTeam(id: $id) {\n      name\n      id\n    }\n  }\n": types.GetTeamDocument,
    "\n  query GetTeamUser($teamId: ID!, $userId: ID!) {\n    getTeamUser(teamId: $teamId, userId: $userId) {\n      email\n      id\n    }\n  }\n": types.GetTeamUserDocument,
    "\n  query GetTwitchUser {\n    getTwitchUser {\n      id\n      displayName\n    }\n  }\n": types.GetTwitchUserDocument,
    "\n  query GetTwitchChannels {\n    getTwitchChannels {\n      id\n      name\n      userId\n    }\n  }\n": types.GetTwitchChannelsDocument,
    "\n  query GetEvent($contextId: ID!, $eventId: ID!) {\n    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n      id\n      name\n      count\n      cost {\n        amount\n        currency\n      }\n      insertedAt\n      updatedAt\n      ijustContextId\n      ijustContext {\n        id\n        name\n      }\n    }\n  }\n": types.GetEventDocument,
    "\n  query GetTwitchChannel($channelName: String!) {\n    getTwitchChannel(channelName: $channelName) {\n      id\n      name\n    }\n  }\n": types.GetTwitchChannelDocument,
    "\n  query IjustEventsSearch($ijustContextId: ID!, $eventName: String!) {\n    ijustEventsSearch(ijustContextId: $ijustContextId, name: $eventName) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n": types.IjustEventsSearchDocument,
    "\n  mutation RefreshToken($refreshToken: String!) {\n    refreshToken(refreshToken: $refreshToken) {\n      result {\n        accessToken\n        refreshToken\n        __typename\n      }\n    }\n  }\n": types.RefreshTokenDocument,
    "\n          query GetTeams {\n            getTeams {\n              id\n              name\n            }\n          }\n        ": types.GetTeamsDocument,
    "\n          query GetIjustContextEventCache($contextId: ID!, $eventId: ID!) {\n            getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n              id\n              ijustOccurrences {\n                id\n                insertedAt\n                updatedAt\n                isDeleted\n              }\n            }\n          }\n        ": types.GetIjustContextEventCacheDocument,
    "\n          query GetTwitchChannelsCache {\n            getTwitchChannels {\n              id\n            }\n          }\n        ": types.GetTwitchChannelsCacheDocument,
    "\n          query GetTwitchChannelsCache2 {\n            getTwitchChannels {\n              name\n            }\n          }\n        ": types.GetTwitchChannelsCache2Document,
    "\n          query GetTwitchUserCache {\n            getTwitchUser {\n              id\n            }\n          }\n        ": types.GetTwitchUserCacheDocument,
};

/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 *
 *
 * @example
 * ```ts
 * const query = graphql(`query GetUser($id: ID!) { user(id: $id) { name } }`);
 * ```
 *
 * The query argument is unknown!
 * Please regenerate the types.
 */
export function graphql(source: string): unknown;

/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation ChangePassword($currentPassword: String!, $newPassword: String!) {\n    changePassword(\n      currentPassword: $currentPassword\n      newPassword: $newPassword\n    ) {\n      id\n    }\n  }\n"): (typeof documents)["\n  mutation ChangePassword($currentPassword: String!, $newPassword: String!) {\n    changePassword(\n      currentPassword: $currentPassword\n      newPassword: $newPassword\n    ) {\n      id\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query currentUserDocument {\n    getCurrentUser {\n      id\n      email\n    }\n  }\n"): (typeof documents)["\n  query currentUserDocument {\n    getCurrentUser {\n      id\n      email\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetThisTwitchUser {\n    getTwitchUser {\n      id\n      displayName\n    }\n  }\n"): (typeof documents)["\n  query GetThisTwitchUser {\n    getTwitchUser {\n      id\n      displayName\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation TwitchRemoveIntegration {\n    twitchRemoveIntegration {\n      id\n    }\n  }\n"): (typeof documents)["\n  mutation TwitchRemoveIntegration {\n    twitchRemoveIntegration {\n      id\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation Login($email: String!, $password: String!) {\n    login(email: $email, password: $password) {\n      messages {\n        message\n      }\n      result {\n        user {\n          id\n          email\n        }\n        accessToken\n        refreshToken\n      }\n    }\n  }\n"): (typeof documents)["\n  mutation Login($email: String!, $password: String!) {\n    login(email: $email, password: $password) {\n      messages {\n        message\n      }\n      result {\n        user {\n          id\n          email\n        }\n        accessToken\n        refreshToken\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetCurrentUser {\n    getCurrentUser {\n      id\n      email\n    }\n  }\n"): (typeof documents)["\n  query GetCurrentUser {\n    getCurrentUser {\n      id\n      email\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetOneTimeLoginLink {\n    getOneTimeLoginLink\n  }\n"): (typeof documents)["\n  query GetOneTimeLoginLink {\n    getOneTimeLoginLink\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation Signup($email: String!, $password: String!) {\n    signup(email: $email, password: $password) {\n      messages {\n        message\n      }\n      result {\n        user {\n          id\n          email\n        }\n        accessToken\n        refreshToken\n      }\n      successful\n    }\n  }\n"): (typeof documents)["\n  mutation Signup($email: String!, $password: String!) {\n    signup(email: $email, password: $password) {\n      messages {\n        message\n      }\n      result {\n        user {\n          id\n          email\n        }\n        accessToken\n        refreshToken\n      }\n      successful\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation CreateTeam($name: String!) {\n    createTeam(name: $name) {\n      id\n      name\n    }\n  }\n"): (typeof documents)["\n  mutation CreateTeam($name: String!) {\n    createTeam(name: $name) {\n      id\n      name\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation DeleteTeam($id: ID!) {\n    deleteTeam(id: $id) {\n      id\n    }\n  }\n"): (typeof documents)["\n  mutation DeleteTeam($id: ID!) {\n    deleteTeam(id: $id) {\n      id\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation JoinTeam($name: String!) {\n    joinTeam(name: $name) {\n      id\n      name\n    }\n  }\n"): (typeof documents)["\n  mutation JoinTeam($name: String!) {\n    joinTeam(name: $name) {\n      id\n      name\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation LeaveTeam($id: ID!) {\n    leaveTeam(id: $id) {\n      id\n    }\n  }\n"): (typeof documents)["\n  mutation LeaveTeam($id: ID!) {\n    leaveTeam(id: $id) {\n      id\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetTeams {\n    getTeams {\n      id\n      name\n    }\n  }\n"): (typeof documents)["\n  query GetTeams {\n    getTeams {\n      id\n      name\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation RenameTeam($id: ID!, $name: String!) {\n    renameTeam(id: $id, name: $name) {\n      id\n      name\n    }\n  }\n"): (typeof documents)["\n  mutation RenameTeam($id: ID!, $name: String!) {\n    renameTeam(id: $id, name: $name) {\n      id\n      name\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetTeamUsers($teamId: ID!) {\n    getTeamUsers(teamId: $teamId) {\n      email\n      id\n    }\n  }\n"): (typeof documents)["\n  query GetTeamUsers($teamId: ID!) {\n    getTeamUsers(teamId: $teamId) {\n      email\n      id\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation IjustAddOccurrenceToEvent($ijustEventId: ID!) {\n    ijustAddOccurrenceToEvent(ijustEventId: $ijustEventId) {\n      id\n      insertedAt\n      isDeleted\n      ijustEvent {\n        id\n        ijustContextId\n      }\n    }\n  }\n"): (typeof documents)["\n  mutation IjustAddOccurrenceToEvent($ijustEventId: ID!) {\n    ijustAddOccurrenceToEvent(ijustEventId: $ijustEventId) {\n      id\n      insertedAt\n      isDeleted\n      ijustEvent {\n        id\n        ijustContextId\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation UpdateIjustEvent($id: ID!, $name: String, $cost: Int) {\n    updateIjustEvent(id: $id, name: $name, cost: $cost) {\n      successful\n      messages {\n        message\n        field\n      }\n      result {\n        id\n        name\n        cost {\n          amount\n          currency\n        }\n      }\n    }\n  }\n"): (typeof documents)["\n  mutation UpdateIjustEvent($id: ID!, $name: String, $cost: Int) {\n    updateIjustEvent(id: $id, name: $name, cost: $cost) {\n      successful\n      messages {\n        message\n        field\n      }\n      result {\n        id\n        name\n        cost {\n          amount\n          currency\n        }\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation CreateIjustEvent($ijustContextId: ID!, $eventName: String!) {\n    createIjustEvent(ijustContextId: $ijustContextId, name: $eventName) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n"): (typeof documents)["\n  mutation CreateIjustEvent($ijustContextId: ID!, $eventName: String!) {\n    createIjustEvent(ijustContextId: $ijustContextId, name: $eventName) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetIjustContextEvent($contextId: ID!, $eventId: ID!) {\n    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n      id\n      ijustContextId\n      ijustOccurrences {\n        id\n        insertedAt\n        updatedAt\n        isDeleted\n      }\n    }\n  }\n"): (typeof documents)["\n  query GetIjustContextEvent($contextId: ID!, $eventId: ID!) {\n    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n      id\n      ijustContextId\n      ijustOccurrences {\n        id\n        insertedAt\n        updatedAt\n        isDeleted\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation IjustDeleteOccurrence($occurrenceId: ID!) {\n    ijustDeleteOccurrence(ijustOccurrenceId: $occurrenceId) {\n      id\n      ijustEventId\n    }\n  }\n"): (typeof documents)["\n  mutation IjustDeleteOccurrence($occurrenceId: ID!) {\n    ijustDeleteOccurrence(ijustOccurrenceId: $occurrenceId) {\n      id\n      ijustEventId\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetIjustRecentEvents($contextId: ID!) {\n    getIjustRecentEvents(contextId: $contextId) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n"): (typeof documents)["\n  query GetIjustRecentEvents($contextId: ID!) {\n    getIjustRecentEvents(contextId: $contextId) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation TwitchChannelUnsubscribe($name: String!) {\n    twitchChannelUnsubscribe(name: $name) {\n      id\n    }\n  }\n"): (typeof documents)["\n  mutation TwitchChannelUnsubscribe($name: String!) {\n    twitchChannelUnsubscribe(name: $name) {\n      id\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation TwitchChannelSubscribe($channel: String!) {\n    twitchChannelSubscribe(channel: $channel) {\n      id\n      name\n      userId\n    }\n  }\n"): (typeof documents)["\n  mutation TwitchChannelSubscribe($channel: String!) {\n    twitchChannelSubscribe(channel: $channel) {\n      id\n      name\n      userId\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetIjustContext($id: ID!) {\n    getIjustContext(id: $id) {\n      id\n      name\n      userId\n    }\n  }\n"): (typeof documents)["\n  query GetIjustContext($id: ID!) {\n    getIjustContext(id: $id) {\n      id\n      name\n      userId\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetIjustContextsQuery {\n    getIjustContexts {\n      id\n      name\n    }\n  }\n"): (typeof documents)["\n  query GetIjustContextsQuery {\n    getIjustContexts {\n      id\n      name\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetIjustDefaultContextQuery {\n    getIjustDefaultContext {\n      id\n      name\n      userId\n    }\n  }\n"): (typeof documents)["\n  query GetIjustDefaultContextQuery {\n    getIjustDefaultContext {\n      id\n      name\n      userId\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetTeam($id: ID!) {\n    getTeam(id: $id) {\n      name\n      id\n    }\n  }\n"): (typeof documents)["\n  query GetTeam($id: ID!) {\n    getTeam(id: $id) {\n      name\n      id\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetTeamUser($teamId: ID!, $userId: ID!) {\n    getTeamUser(teamId: $teamId, userId: $userId) {\n      email\n      id\n    }\n  }\n"): (typeof documents)["\n  query GetTeamUser($teamId: ID!, $userId: ID!) {\n    getTeamUser(teamId: $teamId, userId: $userId) {\n      email\n      id\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetTwitchUser {\n    getTwitchUser {\n      id\n      displayName\n    }\n  }\n"): (typeof documents)["\n  query GetTwitchUser {\n    getTwitchUser {\n      id\n      displayName\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetTwitchChannels {\n    getTwitchChannels {\n      id\n      name\n      userId\n    }\n  }\n"): (typeof documents)["\n  query GetTwitchChannels {\n    getTwitchChannels {\n      id\n      name\n      userId\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetEvent($contextId: ID!, $eventId: ID!) {\n    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n      id\n      name\n      count\n      cost {\n        amount\n        currency\n      }\n      insertedAt\n      updatedAt\n      ijustContextId\n      ijustContext {\n        id\n        name\n      }\n    }\n  }\n"): (typeof documents)["\n  query GetEvent($contextId: ID!, $eventId: ID!) {\n    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n      id\n      name\n      count\n      cost {\n        amount\n        currency\n      }\n      insertedAt\n      updatedAt\n      ijustContextId\n      ijustContext {\n        id\n        name\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query GetTwitchChannel($channelName: String!) {\n    getTwitchChannel(channelName: $channelName) {\n      id\n      name\n    }\n  }\n"): (typeof documents)["\n  query GetTwitchChannel($channelName: String!) {\n    getTwitchChannel(channelName: $channelName) {\n      id\n      name\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query IjustEventsSearch($ijustContextId: ID!, $eventName: String!) {\n    ijustEventsSearch(ijustContextId: $ijustContextId, name: $eventName) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n"): (typeof documents)["\n  query IjustEventsSearch($ijustContextId: ID!, $eventName: String!) {\n    ijustEventsSearch(ijustContextId: $ijustContextId, name: $eventName) {\n      id\n      name\n      count\n      insertedAt\n      updatedAt\n      ijustContextId\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation RefreshToken($refreshToken: String!) {\n    refreshToken(refreshToken: $refreshToken) {\n      result {\n        accessToken\n        refreshToken\n        __typename\n      }\n    }\n  }\n"): (typeof documents)["\n  mutation RefreshToken($refreshToken: String!) {\n    refreshToken(refreshToken: $refreshToken) {\n      result {\n        accessToken\n        refreshToken\n        __typename\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n          query GetTeams {\n            getTeams {\n              id\n              name\n            }\n          }\n        "): (typeof documents)["\n          query GetTeams {\n            getTeams {\n              id\n              name\n            }\n          }\n        "];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n          query GetIjustContextEventCache($contextId: ID!, $eventId: ID!) {\n            getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n              id\n              ijustOccurrences {\n                id\n                insertedAt\n                updatedAt\n                isDeleted\n              }\n            }\n          }\n        "): (typeof documents)["\n          query GetIjustContextEventCache($contextId: ID!, $eventId: ID!) {\n            getIjustContextEvent(contextId: $contextId, eventId: $eventId) {\n              id\n              ijustOccurrences {\n                id\n                insertedAt\n                updatedAt\n                isDeleted\n              }\n            }\n          }\n        "];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n          query GetTwitchChannelsCache {\n            getTwitchChannels {\n              id\n            }\n          }\n        "): (typeof documents)["\n          query GetTwitchChannelsCache {\n            getTwitchChannels {\n              id\n            }\n          }\n        "];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n          query GetTwitchChannelsCache2 {\n            getTwitchChannels {\n              name\n            }\n          }\n        "): (typeof documents)["\n          query GetTwitchChannelsCache2 {\n            getTwitchChannels {\n              name\n            }\n          }\n        "];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n          query GetTwitchUserCache {\n            getTwitchUser {\n              id\n            }\n          }\n        "): (typeof documents)["\n          query GetTwitchUserCache {\n            getTwitchUser {\n              id\n            }\n          }\n        "];

export function graphql(source: string) {
  return (documents as any)[source] ?? {};
}

export type DocumentType<TDocumentNode extends DocumentNode<any, any>> = TDocumentNode extends DocumentNode<  infer TType,  any>  ? TType  : never;