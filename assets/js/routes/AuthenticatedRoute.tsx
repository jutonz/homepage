import * as React from 'react';
import { Route, RouteComponentProps, withRouter } from 'react-router-dom';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { StoreState } from './../Store';

interface Props extends RouteComponentProps<{}> {
  sessionAuthenticated?: boolean;
}

interface State {
}

class _AuthenticatedRoute extends React.Component<Props, State> {
  public componentWillMount() {
    if (!this.props.sessionAuthenticated) {
      console.log('unauthenticated. redirecting to login');
      this.props.history.push("/login");
    }
  }

  public render() {
    return (
      <Route {...this.props} />
    );
  }
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  sessionAuthenticated: store.sessionEstablished
});

export const AuthenticatedRoute = compose(
  withRouter,
  connect(mapStoreToProps)
)(_AuthenticatedRoute);
