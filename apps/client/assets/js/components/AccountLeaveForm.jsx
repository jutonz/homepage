import { Form, Header, Message } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import React from "react";
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

const _AccountLeaveForm = ({
  account,
  leaveAccount,
  isLoading,
  errors,
  history
}) => (
  <div className={css(style.container)}>
    <Form onSubmit={() => leaveAccount(account.id, history)} error={!!errors}>
      <Header>Leave account</Header>
      <Message error>{errors}</Message>
      <p>You can always rejoin later</p>
      <Form.Button primary fluid loading={isLoading}>
        Leave
      </Form.Button>
    </Form>
  </div>
);

export const AccountLeaveForm = compose(
  connect(
    state => ({
      isLoading: state.accounts.leavingAccount,
      errors: state.accounts.leavingAccountErrors
    }),
    dispatch => ({
      leaveAccount: (id, history) =>
        dispatch({ type: "LEAVE_ACCOUNT", id, history })
    })
  ),
  withRouter
)(_AccountLeaveForm);
