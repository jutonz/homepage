import { Loader } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { compose } from "redux";
import { connect } from "react-redux";
import React from "react";

import { TeamDeleteButton } from "@components/TeamDeleteButton";
import { TeamName } from "@components/TeamName";
import { TeamRenameForm } from "@components/TeamRenameForm";
import { TeamUsersForm } from "@components/TeamUsersForm";
import { TeamLeaveForm } from "@components/TeamLeaveForm";
import { MainNav } from "@components/MainNav";
import { fetchTeam, showFlash } from "@store";

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
  componentWillMount() {
    if (!this.props.team) {
      const { fetchTeam, match } = this.props;
      fetchTeam(match.params.id);
    }
  }

  render() {
    const { team, isLoading } = this.props;
    return (
      <div>
        <MainNav activeItem={"settings"} />
        <Loader active={isLoading} />
        <div className={css(style.routeContainer)}>
          {team && this.renderTeam()}
        </div>
      </div>
    );
  }

  renderTeam = () => {
    const { team } = this.props;
    switch (team.fetchStatus) {
      case "failure":
        return (
          <div>
            <div>Failed to load team:</div>
            {team.errors.map((error, index) => <div key={index}>{error}</div>)}
            {team.name}
          </div>
        );
      case "success":
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
      default:
        return <div />;
    }
  };

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
