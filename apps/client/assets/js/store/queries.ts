import gql from "graphql-tag";
import collectGraphqlErrors from "./../utils/collectGraphqlErrors";
import { urqlClient } from "./../index";

export const fetchUserQuery = (variables) => {
  const query = gql`
    query GetUserQuery($id: ID!) {
      getUser(id: $id) {
        id
        email
      }
    }
  `;

  return urqlClient
    .query(query, variables)
    .toPromise()
    .then((response: any) => {
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
    urqlClient
      .query(query, variables)
      .toPromise()
      .then((response: any) => {
        resolve(response.data.getIjustDefaultContext);
      })
      .catch((error) => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};

export const getIjustContextQuery = (variables) => {
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
    urqlClient
      .query(query, variables)
      .toPromise()
      .then((response: any) => {
        resolve(response.data.getIjustContext);
      })
      .catch((error) => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};

export const getIjustRecentEventsQuery = (variables) => {
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
    urqlClient
      .query(query, variables)
      .toPromise()
      .then((response: any) => {
        resolve(response.data.getIjustRecentEvents);
      })
      .catch((error) => {
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
    urqlClient
      .query(query, variables)
      .toPromise()
      .then((response: any) => {
        resolve(response.data.getIjustContextEvent);
      })
      .catch((error) => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};
