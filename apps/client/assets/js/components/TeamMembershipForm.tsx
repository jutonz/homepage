import { css, StyleSheet } from "aphrodite";
import React from "react";
import { Link } from "react-router-dom";
import { gql } from "urql";

import { QueryLoader } from "./../utils/QueryLoader";
import { FormBox } from "./FormBox";

const GET_TEAMS_QUERY = gql`
  query GetTeams {
    getTeams {
      id
      name
    }
  }
`;

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30,
    display: "flex",
    flexDirection: "column",
    flexGrow: 1,
  },
});

type Team = {
  id: string;
  name: string;
};

function renderTeams(teams: Team[]) {
  if (teams.length === 0) {
    return <div>You don't belong to any teams.</div>;
  }

  return (
    <div>
      {teams.map(({ id, name }) => {
        return (
          <div key={id}>
            <Link to={`/teams/${id}`}>{name}</Link>
          </div>
        );
      })}
    </div>
  );
}

export function TeamMembershipForm() {
  return (
    <div className={css(style.container)}>
      <FormBox>
        <h3 className="text-lg mb-3">Team membership</h3>
        <p>Change which teams you belong to</p>
        <QueryLoader
          query={GET_TEAMS_QUERY}
          component={({ data: { getTeams: teams } }) => renderTeams(teams)}
        />
      </FormBox>
    </div>
  );
}
