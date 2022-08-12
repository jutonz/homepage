import gql from "graphql-tag";

import { urqlClient } from "./../index";
import collectGraphqlErrors from "./../utils/collectGraphqlErrors";

export const deleteTeamMutation = (variables) => {
  const mutation = gql`
    mutation DeleteTeam($id: ID!) {
      deleteTeam(id: $id) {
        id
      }
    }
  `;

  return urqlClient.mutation(mutation, variables);
};

export const renameTeamMutation = (variables) => {
  const mutation = gql`
    mutation RenameTeam($id: ID!, $name: String!) {
      renameTeam(id: $id, name: $name) {
        name
      }
    }
  `;

  return urqlClient
    .mutation(mutation, variables)
    .toPromise()
    .then((response) => {
      return response.data.renameTeam;
    });
};

export const joinTeamMutation = (variables) => {
  const mutation = gql`
    mutation JoinTeam($name: String!) {
      joinTeam(name: $name) {
        name
        id
      }
    }
  `;

  return urqlClient
    .mutation(mutation, variables)
    .toPromise()
    .then((response) => {
      return response.data.joinTeam;
    });
};

export const leaveTeamMutation = (variables) => {
  const mutation = gql`
    mutation LeaveTeam($id: ID!) {
      leaveTeam(id: $id) {
        id
      }
    }
  `;

  return new Promise((resolve, reject) => {
    urqlClient
      .mutation(mutation, variables)
      .toPromise()
      .then((response) => {
        resolve(response.data.joinTeam);
      })
      .catch((error) => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};

export const createIjustEventMuation = (variables: {
  ijustContextId: string;
  name: string;
}) => {
  const mutation = gql`
    mutation CreateIjustEvent($ijustContextId: ID!, $name: String!) {
      createIjustEvent(ijustContextId: $ijustContextId, name: $name) {
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
      .mutation(mutation, variables)
      .toPromise()
      .then((response) => resolve(response.data.createIjustEvent))
      .catch((error) => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};
