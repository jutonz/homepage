import React from "react";
import { useParams } from "react-router-dom";

import { QueryLoader } from "./../utils/QueryLoader";
import { MainNav } from "../components/MainNav";
import { graphql } from "../gql";
import type { GetTeamUsersQuery } from "@gql-types";

const GET_TEAM_USER = graphql(`
  query GetTeamUser($teamId: ID!, $userId: ID!) {
    getTeamUser(teamId: $teamId, userId: $userId) {
      email
      id
    }
  }
`);

export function TeamUserRoute() {
  const { user_id: userId, team_id: teamId } = useParams();

  return (
    <>
      <MainNav />
      <div className="mt-5">
        <QueryLoader<GetTeamUsersQuery>
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
