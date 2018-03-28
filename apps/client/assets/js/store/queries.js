import gql from "graphql-tag";

export const fetchAccountUsersQuery = variables => {
  const query = gql`
    query GetAccountUsersQuery($id: ID!) {
      getAccountUsers(id: $id) {
        email
        id
      }
    }
  `;

  return window.grapqlClient.query({ query, variables }).then(response => {
    return response.data.getAccountUsers;
  });
};
