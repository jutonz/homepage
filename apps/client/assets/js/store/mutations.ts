import gql from "graphql-tag";

import { GraphqlClient } from "@app/index";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

export const deleteTeamMutation = variables => {
  const mutation = gql`
    mutation DeleteTeam($id: ID!) {
      deleteTeam(id: $id) {
        id
      }
    }
  `;

  return GraphqlClient.mutate({ mutation, variables });
};

export const renameTeamMutation = variables => {
  const mutation = gql`
    mutation RenameTeam($id: ID!, $name: String!) {
      renameTeam(id: $id, name: $name) {
        name
      }
    }
  `;

  return GraphqlClient.mutate({ mutation, variables }).then(response => {
    return response.data.renameTeam;
  });
};

export const joinTeamMutation = variables => {
  const mutation = gql`
    mutation JoinTeam($name: String!) {
      joinTeam(name: $name) {
        name
        id
      }
    }
  `;

  return GraphqlClient.mutate({ mutation, variables }).then(response => {
    return response.data.joinTeam;
  });
};

export const leaveTeamMutation = variables => {
  const mutation = gql`
    mutation LeaveTeam($id: ID!) {
      leaveTeam(id: $id) {
        id
      }
    }
  `;

  return new Promise((resolve, reject) => {
    GraphqlClient.mutate({ mutation, variables })
      .then(response => {
        resolve(response.data.joinTeam);
      })
      .catch(error => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};

export const createIjustEventMuation = (variables: {
  contextId: string;
  name: string;
}) => {
  const mutation = gql`
    mutation CreateIjustEvent($contextId: ID!, $name: String!) {
      createIjustEvent(contextId: $contextId, name: $name) {
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
    GraphqlClient.mutate({ mutation, variables })
      .then(response => resolve(response.data.createIjustEvent))
      .catch(error => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};
