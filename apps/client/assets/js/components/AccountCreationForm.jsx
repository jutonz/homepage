import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Header, Form, Message } from "semantic-ui-react";
import { compose } from "redux";
import { connect } from "react-redux";
import { fetchAccounts, setNewAccountName, createAccount } from "@store";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30
  },

  fetchError: {
    color: "red"
  }
});


class _AccountCreationForm extends React.Component {
  render() {
    const {
      newAccountName,
      newNameIsValid,
      creatingNewAccount,
      createNewAccountError
    } = this.props;
    return (
      <div className={css(style.container)}>
        <Form onSubmit={this.createAccount} error={!!createNewAccountError}>
          <Header>Create an account</Header>
          <Message error>{createNewAccountError}</Message>
          <Form.Input
            label="Name"
            value={newAccountName}
            onChange={this.nameChanged}
          />
          <Form.Button
            primary
            fluid
            type="submit"
            disabled={!newNameIsValid}
            loading={creatingNewAccount}
          >
            Create
          </Form.Button>
        </Form>
      </div>
    );
  }

  nameChanged = (_event, data) => {
    this.props.setNewAccountName(data.value);
  };

  createAccount = () => {
    const { newAccountName, createAccount } = this.props;
    createAccount(newAccountName);
  };
}

const mapStateToProps = state => ({
  newAccountName: state.accounts.createAccount.newAccountName,
  newNameIsValid: state.accounts.createAccount.newAccountNameIsValid,
  creatingNewAccount: state.accounts.createAccount.creating,
  createNewAccountError: state.accounts.createAccount.error
});

const mapDispatchToProps = dispatch => ({
  fetchAccounts: () => dispatch(fetchAccounts()),
  setNewAccountName: (newName) => dispatch(setNewAccountName(newName)),
  createAccount: (name) => dispatch(createAccount(name))
});

export const AccountCreationForm = compose(
  connect(mapStateToProps, mapDispatchToProps)
)(_AccountCreationForm);
