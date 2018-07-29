import React from "react";
import { Header, Form, Message, Loader } from "semantic-ui-react";
import { Link } from "react-router-dom";
import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";
import gql from "graphql-tag";

import { QueryLoader } from "@utils/QueryLoader";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30
  },
  loaderContainer: {
    display: "flex",
    justifyContent: "center"
  }
});

const GET_TEAM_USERS = gql`
  query GetTeamUsersQuery($slug: String!) {
    getTeamUsers(slug: $slug) {
      email
      id
    }
  }
`;

export const TeamUsersForm = ({ team }) => {
  return (
    <div>
      <Form className={css(style.container)}>
        <Header>Team users</Header>
        <p>View individual members of an team</p>
        <QueryLoader
          query={GET_TEAM_USERS}
          variables={{ slug: team.slug }}
          component={({ data }) => {
            const users = data.getTeamUsers;
            if (!users || users.length === 0) {
              return <p>No users</p>;
            } else {
              return (
                <div>
                  {users.map(user => (
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
      </Form>
    </div>
  );
};
