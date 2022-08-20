import { Form, Header, Message } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import React from "react";
import { connect } from "react-redux";
import { compose } from "redux";
import { useNavigate } from "react-router-dom";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30,
  },
});

const _TeamLeaveForm = ({ team, leaveTeam, isLoading, errors }) => {
  const navigate = useNavigate();

  return (
    <div className={css(style.container)}>
      <Form onSubmit={() => leaveTeam(team.id, navigate)} error={!!errors}>
        <Header>Leave team</Header>
        <Message error>{errors}</Message>
        <p>You can always rejoin later</p>
        <Form.Button primary fluid loading={isLoading}>
          Leave
        </Form.Button>
      </Form>
    </div>
  );
}

export const TeamLeaveForm = compose(
  connect(
    (state) => ({
      isLoading: state.teams.leavingTeam,
      errors: state.teams.leavingTeamErrors,
    }),
    (dispatch) => ({
      leaveTeam: (id, navigate) => dispatch({ type: "LEAVE_TEAM", id, navigate }),
    })
  )
)(_TeamLeaveForm);
