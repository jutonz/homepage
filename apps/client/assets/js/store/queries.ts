import gql from "graphql-tag";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";
import { GraphqlClient } from "@app/index";

export const fetchTeamUsersQuery = variables => {
  const query = gql`
    query GetTeamUsersQuery($id: ID!) {
      getTeamUsers(id: $id) {
        email
        id
      }
    }
  `;

  return GraphqlClient.query({ query, variables }).then((response: any) => {
    return response.data.getTeamUsers;
  });
};

export const fetchTeamUserQuery = variables => {
  const query = gql`
    query GetTeamUserQuery($userId: ID!, $teamId: ID!) {
      getTeamUser(userId: $userId, teamId: $teamId) {
        email
        id
      }
    }
  `;

  return GraphqlClient.query({ query, variables }).then((response: any) => {
    return response.data.getTeamUser;
  });
};

export const fetchUserQuery = variables => {
  const query = gql`
    query GetUserQuery($id: ID!) {
      getUser(id: $id) {
        id
        email
      }
    }
  `;

  return GraphqlClient.query({ query, variables }).then((response: any) => {
    return response.data.getUser;
  });
};

export const getIjustDefaultContextQuery = (variables = {}) => {
  const query = gql`
    query FetchIjustDefaultContextQuery {
      getIjustDefaultContext {
        id
        name
        userId
      }
    }
  `;

  return new Promise((resolve, reject) => {
    GraphqlClient.query({ query, variables })
      .then((response: any) => {
        resolve(response.data.getIjustDefaultContext);
      })
      .catch(error => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};

export const getIjustContextQuery = variables => {
  const query = gql`
    query FetchIjustContextQuery($id: ID!) {
      getIjustContext(id: $id) {
        id
        name
        userId
      }
    }
  `;

  return new Promise((resolve, reject) => {
    GraphqlClient.query({ query, variables })
      .then((response: any) => {
        resolve(response.data.getIjustContext);
      })
      .catch(error => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};

export const getIjustRecentEventsQuery = variables => {
  const query = gql`
    query FetchIjustRecentEventsQuery($contextId: ID!) {
      getIjustRecentEvents(contextId: $contextId) {
        id
        name
        count
        insertedAt
        updatedAt
        ijustContextId
      }
    }
  `;

  return new Promise((resolve, reject) => {
    GraphqlClient.query({ query, variables, fetchPolicy: "network-only" })
      .then((response: any) => {
        resolve(response.data.getIjustRecentEvents);
      })
      .catch(error => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};

export const getIjustContextEventQuery = (variables: {
  contextId: string;
  eventId: string;
}) => {
  const query = gql`
    query GetIjustContextEvent($contextId: ID!, $eventId: ID!) {
      getIjustContextEvent(contextId: $contextId, eventId: $eventId) {
        id
        name
        count
        insertedAt
        updatedAt
        ijustContextId
      }
    }
  `;

  return new Promise((resolve, reject) => {
    GraphqlClient.query({ query, variables })
      .then((response: any) => {
        resolve(response.data.getIjustContextEvent);
      })
      .catch(error => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};
