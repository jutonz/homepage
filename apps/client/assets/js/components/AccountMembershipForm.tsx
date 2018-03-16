import * as React from "react";
import { ReactNode } from "react";
import { StyleSheet, css } from "aphrodite";
import { Header, Form, Loader } from "semantic-ui-react";
import { compose, Dispatch } from "redux";
import { connect } from "react-redux";
import { Link } from "react-router-dom";
import { StoreState, fetchAccounts, Account } from "./../Store";
import { Dictionary } from "./../Types";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30
  },

  loaderContainer: {
    display: "flex",
    justifyContent: "center"
  },

  fetchError: {
    color: "red"
  }
});

interface Props {
  fetchAccounts(): void;
  loadingAccounts: boolean;
  accountsFetchError?: string;
  accounts?: Dictionary<Account>;
}

interface State {}

class _AccountMembershipForm extends React.Component<Props, State> {
  public componentWillMount() {
    this.props.fetchAccounts();
  }

  public render() {
    return (
      <div className={css(style.container)}>
        <Form>
          <Header>Account membership</Header>
          <p>Change which accounts you belong to</p>

          {this.renderAccounts()}
        </Form>
      </div>
    );
  }

  public renderAccounts = (): ReactNode => {
    if (this.props.loadingAccounts) {
      return (
        <div className={css(style.loaderContainer)}>
          <Loader active inline />
        </div>
      );
    } else if (this.props.accountsFetchError) {
      return (
        <div className={css(style.fetchError)}>
          {this.props.accountsFetchError}
        </div>
      );
    } else if (this.props.accounts) {
      return (
        <div>
          {Object.keys(this.props.accounts).map((id: string) => (
            <div key={id}>
              <Link to={`accounts/${id}`}>{this.props.accounts[id].name}</Link>
            </div>
          ))}
        </div>
      );
    } else {
      return <div />;
    }
  };
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  loadingAccounts: store.accounts.loadingAccounts,
  accounts: store.accounts.accounts,
  accountsFetchError: store.accounts.accountsFetchError
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  fetchAccounts: () => dispatch(fetchAccounts())
});

export const AccountMembershipForm = compose(
  connect(mapStoreToProps, mapDispatchToProps)
)(_AccountMembershipForm);
