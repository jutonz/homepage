import gql from "graphql-tag";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

export const deleteTeamMutation = variables => {
  const mutation = gql`
    mutation DeleteTeam($id: ID!) {
      deleteTeam(id: $id) {
        id
      }
    }
  `;

  return window.grapqlClient.mutate({ mutation, variables });
};

export const renameTeamMutation = variables => {
  const mutation = gql`
    mutation RenameTeam($id: ID!, $name: String!) {
      renameTeam(id: $id, name: $name) {
        name
      }
    }
  `;

  return window.grapqlClient.mutate({ mutation, variables }).then(response => {
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

  return window.grapqlClient.mutate({ mutation, variables }).then(response => {
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
    window.grapqlClient
      .mutate({ mutation, variables })
      .then(response => {
        resolve(response.data.joinTeam);
      })
      .catch(error => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};
