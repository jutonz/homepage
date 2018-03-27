import React from "react";
import { Button, Header, Form, Message } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30
  }
});

const _AccountRenameForm = ({ account, setNewName, renameAccount }) => (
  <Form error={!!account.renameErrors} className={css(style.container)}>
    <Header>Rename account</Header>
    <Message error>{account.renameErrors}</Message>
    <Form.Input
      label="Name"
      value={account.renameName || ""}
      onChange={(_ev, data) => setNewName(account.id, data.value)}
    />
    <Button
      primary
      fluid
      onClick={() => renameAccount(account.id, account.renameName)}
      loading={account.isRenaming}
      disabled={!newNameIsValid(account.renameName)}
    >
      Rename
    </Button>
  </Form>
);

const newNameIsValid = name => !!name;

const getRenameErrors = (state, props) => {
  const account = state.accounts.accounts[parseInt(props.account.id)];
  return account.renameErrors;
};

const mapDispatchToProps = dispatch => ({
  setNewName: (id, name) =>
    dispatch({ type: "SET_ACCOUNT_RENAME_NAME", id, name }),
  renameAccount: (id, name) => dispatch({ type: "RENAME_ACCOUNT", id, name })
});

export const AccountRenameForm = connect(null, mapDispatchToProps)(
  _AccountRenameForm
);
