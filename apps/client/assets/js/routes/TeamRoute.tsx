import { css, StyleSheet } from "aphrodite";
import React from "react";
import { useParams } from "react-router-dom";

import { MainNav } from "./../components/MainNav";
import { TeamDeleteForm } from "./../components/TeamDeleteForm";
import { TeamLeaveForm } from "./../components/TeamLeaveForm";
import { TeamRenameForm } from "./../components/TeamRenameForm";
import { TeamUsersForm } from "./../components/TeamUsersForm";
import { QueryLoader } from "./../utils/QueryLoader";
import { graphql } from "./../gql";

const style = StyleSheet.create({
  routeContainer: {
    margin: "30px",
  },
  components: {
    display: "flex",
    flexWrap: "wrap",
    flexDirection: "column",
  },
});

const GET_TEAM_QUERY = graphql(`
  query GetTeam($id: ID!) {
    getTeam(id: $id) {
      name
      id
    }
  }
`);

const renderTeam = (team: any) => {
  return (
    <div>
      <h1>{team.name}</h1>
      <div className={css(style.components)}>
        <TeamRenameForm team={team} />
        <TeamUsersForm team={team} />
        <TeamDeleteForm team={team} />
        <TeamLeaveForm team={team} />
      </div>
    </div>
  );
};

export function TeamRoute() {
  const { id: teamId } = useParams();

  return (
    <div>
      <MainNav />
      <QueryLoader
        query={GET_TEAM_QUERY}
        variables={{ id: teamId }}
        component={({ data }) => {
          const team = data.getTeam;

          return (
            <div className={css(style.routeContainer)}>
              {team && renderTeam(team)}
            </div>
          );
        }}
      />
    </div>
  );
}
