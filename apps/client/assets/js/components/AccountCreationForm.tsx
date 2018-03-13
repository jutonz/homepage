import * as React from "react";
import { StyleSheet, css } from "aphrodite";
import { Header, Form, InputOnChangeData, Message } from "semantic-ui-react";
import { compose, Dispatch } from "redux";
import { connect } from "react-redux";
import {
  StoreState,
  fetchAccounts,
  setNewAccountName,
  createAccount
} from "./../Store";

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

interface Props {
  fetchAccounts(): void;
  loadingAccounts: boolean;
  newAccountName?: string;
  setNewAccountName(newName: string): void;
  newNameIsValid?: boolean;
  createAccount(name: string): void;
  creatingNewAccount?: boolean;
  createNewAccountError?: string;
}

class _AccountCreationForm extends React.Component<Props> {
  public render() {
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

  private nameChanged = (
    _event: React.SyntheticEvent<HTMLInputElement>,
    data: InputOnChangeData
  ): void => {
    this.props.setNewAccountName(data.value);
  };

  private createAccount = () => {
    const { newAccountName, createAccount } = this.props;
    createAccount(newAccountName);
  };
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  loadingAccounts: store.accounts.loadingAccounts,
  newAccountName: store.accounts.newAccountName,
  newNameIsValid: store.accounts.newAccountNameIsValid,
  creatingNewAccount: store.accounts.creatingNewAccount,
  createNewAccountError: store.accounts.createNewAccountError
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  fetchAccounts: () => dispatch(fetchAccounts()),
  setNewAccountName: (newName: string) => dispatch(setNewAccountName(newName)),
  createAccount: (name: string) => dispatch(createAccount(name))
});

export const AccountCreationForm = compose(
  connect(mapStoreToProps, mapDispatchToProps)
)(_AccountCreationForm);
