import React from "react";
import { ReactNode } from "react";
import { Route, Redirect, withRouter } from "react-router-dom";
import { compose } from "redux";
import { connect } from "react-redux";

// Ensures a session is active before allowing users to visit the specified
// route, redirecting to /login if not.
class _AuthenticatedRoute extends React.Component {
  render() {
    const { sessionEstablished, ...rest } = this.props;

    if (sessionEstablished) {
      return <Route {...rest} />;
    } else {
      // Cannot pass both component and render props to Route, so strip
      // component before currying props.
      const { component, ...restWithoutComponent } = rest;
      return <Route {...restWithoutComponent} render={this.redirectToLogin} />;
    }
  }

  redirectToLogin = (props) => {
    const location = { pathname: "/login", state: props.location };
    return <Route render={() => <Redirect to={location} />} />;
  };
}

const mapStoreToProps = (store) => ({
  sessionEstablished: store.session.established,
});

export const AuthenticatedRoute = compose(
  withRouter,
  connect(mapStoreToProps)
)(_AuthenticatedRoute);
