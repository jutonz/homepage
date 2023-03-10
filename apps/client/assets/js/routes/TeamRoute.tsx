import { css, StyleSheet } from "aphrodite";
import React from "react";
import { useParams } from "react-router-dom";
import { gql } from "urql";

import { MainNav } from "./../components/MainNav";
import { TeamDeleteButton } from "./../components/TeamDeleteButton";
import { TeamLeaveForm } from "./../components/TeamLeaveForm";
import { TeamRenameForm } from "./../components/TeamRenameForm";
import { TeamUsersForm } from "./../components/TeamUsersForm";
import { QueryLoader } from "./../utils/QueryLoader";

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

const GET_TEAMS_QUERY = gql`
  query GetTeams {
    getTeams {
      name
      id
    }
  }
`;

const renderTeam = (team: any) => {
  return (
    <div>
      <h1>{team.name}</h1>
      <div className={css(style.components)}>
        <TeamRenameForm team={team} />
        <TeamUsersForm team={team} onDelete={() => {}} />
        <TeamDeleteButton team={team} onDelete={() => {}} />
        <TeamLeaveForm team={team} />
      </div>
    </div>
  );
};

export function TeamRoute() {
  const { id: teamId } = useParams();

  return (
    <div>
      <MainNav activeItem={"settings"} />
      <QueryLoader
        query={GET_TEAMS_QUERY}
        component={({ data }) => {
          const teams = data.getTeams;
          const team = teams.find((team: any) => team.id === teamId);

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
