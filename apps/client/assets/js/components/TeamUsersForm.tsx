import * as React from "react";
import { Header } from "semantic-ui-react";
import { Link } from "react-router-dom";
import gql from "graphql-tag";

import { QueryLoader } from "./../utils/QueryLoader";
import type { User } from "@types";

const GET_TEAM_USERS = gql`
  query GetTeamUsers($teamId: ID!) {
    getTeamUsers(teamId: $teamId) {
      email
      id
    }
  }
`;

type GetUsersType = {
  getTeamUsers: User[];
};

export const TeamUsersForm = ({ team }) => (
  <div className="w-80 mt-5 p-2.5 border-gray-300 border">
    <Header>Team users</Header>
    <p>View individual members of a team</p>
    <QueryLoader<GetUsersType>
      query={GET_TEAM_USERS}
      variables={{ teamId: team.id }}
      component={({ data }) => {
        const users = data.getTeamUsers || [];
        if (users.length === 0) {
          return <p>No users</p>;
        } else {
          return (
            <div>
              {users.map((user: User) => (
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
  </div>
);
