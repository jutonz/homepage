import * as React from "react";
import { compose } from "redux";
import { connect, Dispatch } from "react-redux";
import { RouteComponentProps } from "react-router-dom";
import { MainNav, ActiveItem } from "./../components/MainNav";
import { Account, fetchAccount, StoreState, Action } from "./../Store";
import { Loader } from "semantic-ui-react";

interface RouteParams {
  // included in URL or query params
  id: string;
}

interface Props extends RouteComponentProps<RouteParams> {
  account?: Account;
  fetchAccount(id: string): Promise<Action>;
}

class _AccountRoute extends React.Component<Props, {}> {
  public componentWillMount() {
    if (!this.props.account) {
      const { fetchAccount, match } = this.props;
      fetchAccount(match.params.id);
    }
  }

  public render() {
    const { account } = this.props;
    return (
      <div>
        <MainNav activeItem={ActiveItem.Settings} />
        <Loader active={!!!account} />
        {account && account.name}
      </div>
    );
  }
}

const getAccount = (state: StoreState, props: Props) => {
  const accounts = state.accounts.accounts;
  const targetId = props.match.params.id;
  return accounts[targetId];
};

const mapStoreToProps = (store: StoreState, props: Props): Partial<Props> => ({
  account: getAccount(store, props)
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  fetchAccount: (id: string) => dispatch(fetchAccount(id))
});

export const AccountRoute = compose(
  connect(mapStoreToProps, mapDispatchToProps)
)(_AccountRoute);
