import * as React from "react";
import { ReactNode } from "react";
import {
  Route,
  RouteComponentProps,
  Redirect,
  withRouter
} from "react-router-dom";
import { compose } from "redux";
import { connect } from "react-redux";
import { StoreState } from "./../Store";

interface Props extends RouteComponentProps<{}> {
  sessionAuthenticated?: boolean;
  component: React.ComponentType<any>;
}

// Ensures a session is active before allowing users to visit the specified
// route, redirecting to /login if not.
class _AuthenticatedRoute extends React.Component<Props, {}> {
  public render() {
    const { sessionAuthenticated, ...rest } = this.props;

    if (sessionAuthenticated) {
      return <Route {...rest} />;
    } else {
      // Cannot pass both component and render props to Route, so strip
      // component before currying props.
      const { component, ...restWithoutComponent } = rest;
      return <Route {...restWithoutComponent} render={this.redirectToLogin} />;
    }
  }

  private redirectToLogin = (props: Props): ReactNode => {
    const location = { pathname: "/login", state: props.location };
    return <Redirect to={location} />;
  }
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  sessionAuthenticated: store.sessionAuthenticated
});

export const AuthenticatedRoute = compose(withRouter, connect(mapStoreToProps))(
  _AuthenticatedRoute
);
