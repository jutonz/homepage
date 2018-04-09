import gql from "graphql-tag";

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
