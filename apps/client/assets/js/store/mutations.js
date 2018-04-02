import gql from "graphql-tag";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

export const deleteAccountMutation = variables => {
  const mutation = gql`
    mutation DeleteAccount($id: ID!) {
      deleteAccount(id: $id) {
        id
      }
    }
  `;

  return window.grapqlClient.mutate({ mutation, variables });
};

export const renameAccountMutation = variables => {
  const mutation = gql`
    mutation RenameAccount($id: ID!, $name: String!) {
      renameAccount(id: $id, name: $name) {
        name
      }
    }
  `;

  return window.grapqlClient.mutate({ mutation, variables }).then(response => {
    return response.data.renameAccount;
  });
};

export const joinAccountMutation = variables => {
  const mutation = gql`
    mutation JoinAccount($name: String!) {
      joinAccount(name: $name) {
        name
        id
      }
    }
  `;

  return window.grapqlClient.mutate({ mutation, variables }).then(response => {
    return response.data.joinAccount;
  });
};

export const leaveAccountMutation = variables => {
  const mutation = gql`
    mutation LeaveAccount($id: ID!) {
      leaveAccount(id: $id) {
        id
      }
    }
  `;

  return new Promise((resolve, reject) => {
    window.grapqlClient
      .mutate({ mutation, variables })
      .then(response => {
        resolve(response.data.joinAccount);
      })
      .catch(error => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};
