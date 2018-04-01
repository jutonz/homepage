import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Header, Form, Message } from "semantic-ui-react";
import { connect } from "react-redux";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30,
    display: "flex",
    flexDirection: "column",
    flexGrow: 1
  }
});

const _AccountJoinForm = ({ name, setName, join, isLoading, errors }) => (
  <div className={css(style.container)} onSubmit={() => join(name)}>
    <Form error={!!errors}>
      <Header>Join an account</Header>
      <p>Become a member of an existing account</p>
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

export const AccountJoinForm = connect(
  state => ({
    name: state.accounts.joinAccountName || "",
    isLoading: state.accounts.joiningAccount,
    errors: state.accounts.joinAccountErrors
  }),
  dispatch => ({
    setName: name => dispatch({ type: "SET_JOIN_ACCOUNT_NAME", name }),
    join: name => dispatch({ type: "JOIN_ACCOUNT", name })
  })
)(_AccountJoinForm);
