import gql from "graphql-tag";
import { FetchResult } from "apollo-link";

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
