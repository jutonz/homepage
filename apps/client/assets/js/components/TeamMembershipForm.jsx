import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Header, Form, Loader } from "semantic-ui-react";
import { compose } from "redux";
import { connect } from "react-redux";
import { Link } from "react-router-dom";

import { fetchTeams } from "./../store/store";
import { FormBox } from "./FormBox";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30,
    display: "flex",
    flexDirection: "column",
    flexGrow: 1,
  },

  loaderContainer: {
    display: "flex",
    justifyContent: "center",
  },

  fetchError: {
    color: "red",
  },
});

class _TeamMembershipForm extends React.Component {
  componentWillMount() {
    this.props.fetchTeams();
  }

  render() {
    return (
      <div className={css(style.container)}>
        <FormBox>
          <Form>
            <Header>Team membership</Header>
            <p>Change which teams you belong to</p>

            {this.renderTeams()}
          </Form>
        </FormBox>
      </div>
    );
  }

  renderTeams = () => {
    if (this.props.isLoading) {
      return (
        <div className={css(style.loaderContainer)}>
          <Loader active inline />
        </div>
      );
    } else if (this.props.teamsFetchError) {
      return (
        <div className={css(style.fetchError)}>
          {this.props.teamsFetchError}
        </div>
      );
    } else if (
      this.props.teams &&
      Object.getOwnPropertyNames(this.props.teams).length !== 0
    ) {
      return (
        <div>
          {Object.keys(this.props.teams).map((id) => (
            <div key={id}>
              <Link to={`/teams/${id}`}>{this.props.teams[id].name}</Link>
            </div>
          ))}
        </div>
      );
    } else {
      return (
        <div>
          <p>You do not belong to any teams</p>
        </div>
      );
    }
  };
}

const mapStateToProps = (state) => ({
  isLoading: state.teams.loadingAllTeams,
  teams: state.teams.teams,
  teamsFetchError: state.teams.teamsFetchError,
});

const mapDispatchToProps = (dispatch) => ({
  fetchTeams: () => dispatch(fetchTeams()),
});

export const TeamMembershipForm = compose(
  connect(mapStateToProps, mapDispatchToProps)
)(_TeamMembershipForm);
