import * as React from "react";
import { Header } from "semantic-ui-react";
import { Link } from "react-router-dom";
import { StyleSheet, css } from "aphrodite";
import gql from "graphql-tag";

import { QueryLoader } from "@utils/QueryLoader";
import { FormBox } from "@components/FormBox";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30,
  },
});

const GET_TEAM_USERS = gql`
  query GetTeamUsers($teamId: ID!) {
    getTeamUsers(teamId: $teamId) {
      email
      id
    }
  }
`;

export const TeamUsersForm = ({ team, onDelete }) => (
  <FormBox styles={style.container}>
    <Header>Team users</Header>
    <p>View individual members of a team</p>
    <QueryLoader
      query={GET_TEAM_USERS}
      variables={{ teamId: team.id }}
      component={({ data }) => {
        const users = data.getTeamUsers || [];
        if (users.length === 0) {
          return <p>No users</p>;
        } else {
          return (
            <div>
              {users.map((user) => (
                <div key={user.id}>
                  <Link to={`/teams/${team.id}/users/${user.id}`}>
                    {user.email}
                  </Link>
                </div>
              ))}
            </div>
          );
        }
      }}
    />
  </FormBox>
);
