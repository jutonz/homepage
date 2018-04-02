import { Loader } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { compose } from "redux";
import { connect } from "react-redux";
import React from "react";

import { AccountDeleteButton } from "@components/AccountDeleteButton";
import { AccountName } from "@components/AccountName";
import { AccountRenameForm } from "@components/AccountRenameForm";
import { AccountUsersForm } from "@components/AccountUsersForm";
import { AccountLeaveForm } from "@components/AccountLeaveForm";
import { MainNav } from "@components/MainNav";
import { fetchAccount, showFlash } from "@store";

const style = StyleSheet.create({
  routeContainer: {
    margin: "30px"
  }
});

class _AccountRoute extends React.Component {
  componentWillMount() {
    if (!this.props.account) {
      const { fetchAccount, match } = this.props;
      fetchAccount(match.params.id);
    }
  }

  render() {
    const { account, isLoading } = this.props;
    return (
      <div>
        <MainNav activeItem={"settings"} />
        <Loader active={isLoading} />
        <div className={css(style.routeContainer)}>
          {account && this.renderAccount()}
        </div>
      </div>
    );
  }

  renderAccount = () => {
    const { account } = this.props;
    switch (account.fetchStatus) {
      case "failure":
        return (
          <div>
            <div>Failed to load account:</div>
            {account.errors.map((error, index) => (
              <div key={index}>{error}</div>
            ))}
            {account.name}
          </div>
        );
      case "success":
        return (
          <div>
            <AccountName account={account} />
            <AccountRenameForm account={account} />
            <AccountUsersForm account={account} />
            <AccountDeleteButton account={account} onDelete={this.onDelete} />
            <AccountLeaveForm account={account} />
          </div>
        );
      default:
        return <div />;
    }
  };

  onDelete = () => {
    this.props.showFlash("Account deleted", "success");
    this.props.history.push("/settings");
  };
}

const getAccount = (state, props) => {
  const accounts = state.accounts.accounts;
  const targetId = props.match.params.id;
  return accounts[targetId];
};

const isStatus = (status, state, props): boolean => {
  const accountId = props.match.params.id;
  const account = state.accounts.accounts[accountId];
  return account && account.fetchStatus === status;
};

const mapStoreToProps = (store, props) => ({
  account: getAccount(store, props),
  isLoading: isStatus("in_progress", store, props)
});

const mapDispatchToProps = dispatch => ({
  fetchAccount: id => dispatch(fetchAccount(id)),
  showFlash: (message, tone) => dispatch(showFlash(message, tone))
});

export const AccountRoute = compose(
  connect(mapStoreToProps, mapDispatchToProps)
)(_AccountRoute);
