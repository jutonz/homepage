import React from "react";
import { useParams } from "react-router-dom";
import gql from "graphql-tag";

import { QueryLoader } from "./../utils/QueryLoader";
import { MainNav } from "../components/MainNav";
import type { User } from "@types";

const GET_TEAM_USER = gql`
  query GetTeamUser($teamId: ID!, $userId: ID!) {
    getTeamUser(teamId: $teamId, userId: $userId) {
      email
      id
    }
  }
`;

type GetUsersType = {
  getTeamUser: User;
};

export function TeamUserRoute() {
  const { user_id: userId, team_id: teamId } = useParams();

  return (
    <>
      <MainNav />
      <div className="mt-5">
        <QueryLoader<GetUsersType>
          query={GET_TEAM_USER}
          variables={{ teamId, userId }}
          component={({ data }) => {
            const user = data.getTeamUser;
            return <div>{user.email}</div>;
          }}
        />
      </div>
    </>
  );
}
