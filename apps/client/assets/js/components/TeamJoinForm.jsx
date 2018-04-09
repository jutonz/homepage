import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Header, Form, Message } from "semantic-ui-react";
import { connect } from "react-redux";
import { compose } from "redux";
import { withRouter } from "react-router";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30,
    display: "flex",
    flexDirection: "column",
    flexGrow: 1
  }
});

const _TeamJoinForm = ({ name, setName, join, isLoading, errors, history }) => (
  <div className={css(style.container)} onSubmit={() => join(name, history)}>
    <Form error={!!errors}>
      <Header>Join a team</Header>
      <p>Become a member of an existing team</p>
      <Message error>{errors}</Message>
      <Form.Input
        label="Name"
        value={name}
        onChange={(_ev, data) => setName(data.value)}
      />
      <Form.Button primary fluid disabled={!!!name} loading={!!isLoading}>
        Join
      </Form.Button>
    </Form>
  </div>
);

export const TeamJoinForm = compose(
  connect(
    state => ({
      name: state.teams.joinTeamName || "",
      isLoading: state.teams.joiningTeam,
      errors: state.teams.joinTeamErrors
    }),
    dispatch => ({
      setName: name => dispatch({ type: "SET_JOIN_TEAM_NAME", name }),
      join: (name, history) => dispatch({ type: "JOIN_TEAM", name, history })
    })
  ),
  withRouter
)(_TeamJoinForm);
