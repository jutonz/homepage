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

interface State {}

// Ensures a session is active before allowing users to visit the specified
// route, redirecting to /login if not.
//
// Note: Usage is mostly the same as the vanilla <Route>, except that the
// `render` prop is not valid (you must pass `component`).
class _AuthenticatedRoute extends React.Component<Props, State> {
  public render() {
    // Cannot pass both `component` and `render` to `<Route>`, so strip
    // `component` before currying props.
    let { component: Component, ...rest } = this.props;

    return <Route {...rest} render={this.renderComponent} />;
  }

  private renderComponent = (): ReactNode => {
    if (this.props.sessionAuthenticated) {
      const { component: Component } = this.props;
      return <Component />;
    } else {
      const location = {
        pathname: "/login",
        state: this.props.location
      };
      return <Redirect to={location} />;
    }
  };
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  sessionAuthenticated: store.sessionAuthenticated
});

export const AuthenticatedRoute = compose(withRouter, connect(mapStoreToProps))(
  _AuthenticatedRoute
);
