import React from "react";
import { Loader } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { compose } from "redux";
import { connect } from "react-redux";
import gql from "graphql-tag";

import { TeamDeleteButton } from "@components/TeamDeleteButton";
import { TeamName } from "@components/TeamName";
import { TeamRenameForm } from "@components/TeamRenameForm";
import { TeamUsersForm } from "@components/TeamUsersForm";
import { TeamLeaveForm } from "@components/TeamLeaveForm";
import { MainNav } from "@components/MainNav";
import { fetchTeam, showFlash } from "@store";
import { QueryLoader } from "@utils/QueryLoader";

const GET_TEAM = gql`
  query GetTeam($slug: String!) {
    getTeam(slug: $slug) {
      id
      name
      slug
    }
  }
`;

const style = StyleSheet.create({
  routeContainer: {
    margin: "30px"
  },
  components: {
    display: "flex",
    flexWrap: "wrap",
    flexDirection: "column"
  }
});

class _TeamRoute extends React.Component {
  render() {
    const slug = this.props.match.params.slug;
    return (
      <div>
        <MainNav activeItem={"settings"} />
        <QueryLoader
          query={GET_TEAM}
          variables={{ slug }}
          component={({ data }) => {
            const team = data.getTeam;
            return (
              <div>
                <TeamName team={team} />
                <div className={css(style.components)}>
                  <TeamRenameForm team={team} />
                  <TeamUsersForm team={team} />
                  <TeamDeleteButton team={team} onDelete={this.onDelete} />
                  <TeamLeaveForm team={team} />
                </div>
              </div>
            );
          }}
        />
      </div>
    );
  }

  onDelete = () => {
    this.props.showFlash("Team deleted", "success");
    this.props.history.push("/settings");
  };
}

const getTeam = (state, props) => {
  const teams = state.teams.teams;
  const targetId = props.match.params.id;
  return teams[targetId];
};

const isStatus = (status, state, props): boolean => {
  const teamId = props.match.params.id;
  const team = state.teams.teams[teamId];
  return team && team.fetchStatus === status;
};

const mapStoreToProps = (store, props) => ({
  team: getTeam(store, props),
  isLoading: isStatus("in_progress", store, props)
});

const mapDispatchToProps = dispatch => ({
  fetchTeam: id => dispatch(fetchTeam(id)),
  showFlash: (message, tone) => dispatch(showFlash(message, tone))
});

export const TeamRoute = compose(
  connect(
    mapStoreToProps,
    mapDispatchToProps
  )
)(_TeamRoute);
