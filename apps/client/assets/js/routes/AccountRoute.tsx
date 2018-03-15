import * as React from "react";
import { compose } from "redux";
import { connect, Dispatch } from "react-redux";
import { RouteComponentProps } from "react-router-dom";
import { MainNav, ActiveItem } from "./../components/MainNav";
import { Account, fetchAccount, StoreState } from "./../Store";

interface RouteParams {
  id: string;
}

interface Props extends RouteComponentProps<RouteParams> {
  account?: Account
  fetchAccount(id: string): void;
};

class _AccountRoute extends React.Component<Props, {}> {
  public componentWillMount() {
    const { account, fetchAccount, match } = this.props;
    if (!account) {
      fetchAccount(match.params.id);
    } else {
    }
    this.props.fetchAccount(this.props.match.params.id);
  };

  public render() {
    return (
      <div>
        <MainNav activeItem={ActiveItem.Settings} />
      </div>
    );
  }
}

const mapStoreToProps = (_store: StoreState): Partial<Props> => ({
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  fetchAccount: (id: string) => dispatch(fetchAccount(id))
});

export const AccountRoute = compose(connect(mapStoreToProps, mapDispatchToProps))(_AccountRoute);
