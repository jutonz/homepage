import * as React from "react";
import { StyleSheet, css } from "aphrodite";
import { Header, Form } from "semantic-ui-react";
import { compose, Dispatch } from "redux";
import { connect } from "react-redux";
import { StoreState, fetchAccounts } from "./../Store";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30
  }
});

interface Props {
  fetchAccounts(): void;
  loadingAccounts: boolean;
}

interface State {
}

class _AccountCreationForm extends React.Component<Props, State> {
  public render() {
    return (
      <div className={css(style.container)}>
        <Form>
          <Header>Create an account</Header>
        </Form>
      </div>
    );
  }
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  loadingAccounts: store.accounts.loadingAccounts
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  fetchAccounts: () => dispatch(fetchAccounts())
});

export const AccountCreationForm = compose(
  connect(mapStoreToProps, mapDispatchToProps)
)(_AccountCreationForm);
