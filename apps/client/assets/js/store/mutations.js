import gql from "graphql-tag";
import { FetchResult } from "apollo-link";

export const deleteAccountMutation = (variables) => {
  const mutation = gql`
    mutation DeleteAccount($id: ID!) {
      deleteAccount(id: $id) {
        id
      }
    }
  `;

  return window.grapqlClient.mutate({ mutation, variables });
};
