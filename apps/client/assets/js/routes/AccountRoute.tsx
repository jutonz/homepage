import * as React from "react";
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

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
});

export const AccountRoute = connect(mapStoreToProps, mapDispatchToProps)(_AccountRoute);

//export const AccountRoute = ({ account, match }: Props) => (
  //<div>
    //{match.params.id}
    //<MainNav activeItem={ActiveItem.Settings} />
  //</div>
//);
