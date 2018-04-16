import gql from "graphql-tag";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

export const fetchTeamUsersQuery = variables => {
  const query = gql`
    query GetTeamUsersQuery($id: ID!) {
      getTeamUsers(id: $id) {
        email
        id
      }
    }
  `;

  return window.grapqlClient.query({ query, variables }).then(response => {
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

  return window.grapqlClient.query({ query, variables }).then(response => {
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

  return window.grapqlClient.query({ query, variables }).then(response => {
    return response.data.getUser;
  });
};

export const getIjustDefaultContextQuery = variables => {
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
    window.grapqlClient
      .query({ query, variables })
      .then(response => {
        resolve(response.data.getIjustDefaultContext);
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
    window.grapqlClient
      .query({ query, variables, fetchPolicy: "network-only" })
      .then(response => {
        resolve(response.data.getIjustRecentEvents);
      })
      .catch(error => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};
