import * as React from "react";
import { compose } from "redux";
import { connect, Dispatch } from "react-redux";
import { RouteComponentProps } from "react-router-dom";
import { MainNav, ActiveItem } from "./../components/MainNav";
import { Account, fetchAndViewAccount, StoreState } from "./../Store";
import { Loader } from "semantic-ui-react";

interface RouteParams {
  // included in URL or query params
  id: string;
}

interface Props extends RouteComponentProps<RouteParams> {
  account?: Account;
  loadingAccount?: boolean;
  fetchAndViewAccount(id: string): void;
}

class _AccountRoute extends React.Component<Props, {}> {
  public componentWillMount() {
    const { fetchAndViewAccount, match } = this.props;
    fetchAndViewAccount(match.params.id);
  }

  public render() {
    const { account, loadingAccount } = this.props;
    return (
      <div>
        <MainNav activeItem={ActiveItem.Settings} />
        <Loader active={!loadingAccount} />
        {account && account.name}
      </div>
    );
  }
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  account: store.accounts.viewAccount.account,
  loadingAccount: store.accounts.viewAccount.loading
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  fetchAndViewAccount: (id: string) => dispatch(fetchAndViewAccount(id))
});

export const AccountRoute = compose(
  connect(mapStoreToProps, mapDispatchToProps)
)(_AccountRoute);
