import * as React from "react";
import { ReactNode } from "react";
import { compose } from "redux";
import { connect, Dispatch } from "react-redux";
import { RouteComponentProps } from "react-router-dom";
import { MainNav, ActiveItem } from "./../components/MainNav";
import { AccountName } from "./../components/AccountName.tsx";
import {
  Account,
  fetchAccount,
  StoreState,
  Action,
  FetchStatus
} from "./../Store";
import { Loader } from "semantic-ui-react";

interface RouteParams {
  // included in URL or query params
  id: string;
}

interface Props extends RouteComponentProps<RouteParams> {
  account?: Account;
  fetchAccount(id: string): Promise<Action>;
  isLoading?: boolean;
}

class _AccountRoute extends React.Component<Props, {}> {
  public componentWillMount() {
    if (!this.props.account) {
      const { fetchAccount, match } = this.props;
      fetchAccount(match.params.id);
    }
  }

  public render() {
    const { account, isLoading } = this.props;
    return (
      <div>
        <MainNav activeItem={ActiveItem.Settings} />
        <Loader active={isLoading} />
        {account && this.renderAccount(account)}
      </div>
    );
  }

  private renderAccount = (account: Account): ReactNode => {
    switch (account.fetchStatus) {
      case FetchStatus.Failure:
        return (
          <div>
            <div>Failed to load account:</div>
            {account.errors.map((error, index) => (
              <div key={index}>{error}</div>
            ))}
            {account.name}
          </div>
        );
      case FetchStatus.Success:
        return (
          <div>
            <AccountName account={account} />
          </div>
        );
      default:
        return <div />;
    }
  };
}

const getAccount = (state: StoreState, props: Props) => {
  const accounts = state.accounts.accounts;
  const targetId = props.match.params.id;
  return accounts[targetId];
};

const isStatus = (
  status: FetchStatus,
  state: StoreState,
  props: Props
): boolean => {
  const accountId = props.match.params.id;
  const account = state.accounts.accounts[accountId];
  return account && account.fetchStatus === status;
};

const mapStoreToProps = (store: StoreState, props: Props): Partial<Props> => ({
  account: getAccount(store, props),
  isLoading: isStatus(FetchStatus.InProgress, store, props)
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  fetchAccount: (id: string) => dispatch(fetchAccount(id))
});

export const AccountRoute = compose(
  connect(mapStoreToProps, mapDispatchToProps)
)(_AccountRoute);
