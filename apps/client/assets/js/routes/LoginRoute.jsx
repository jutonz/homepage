import React from "react";
import { compose } from "redux";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import { LoginForm } from "@components/LoginForm";
import { BgGrid } from "./../BgGrid";

class _LoginRoute extends React.Component {
  constructor(props) {
    super(props);
    this.state = { bgGrid: new BgGrid() };
  }

  componentDidMount() {
    if (this.props.sessionAuthenticated) {
      this.props.history.push("/");
    } else {
      this.state.bgGrid.init();
      this.state.bgGrid.start();
    }
  }

  componentWillUnmount() {
    this.state.bgGrid.stop();
  }

  render() {
    return (
      <div>
        <canvas id="gl-canvas">
          Your browser doesn't appear to support the
          <code>&lt;canvas&gt;</code> element.
        </canvas>

        <LoginForm onLogin={this.onLogin} />
      </div>
    );
  }

  onLogin = () => {
    this.props.initSession();
    const query = new URLSearchParams(this.props.location.search);
    const redirectTo = query.get("to");

    if (redirectTo) {
      window.location.replace(redirectTo);
    } else if (this.props.location.state) {
      this.props.history.push(this.props.location.state);
    } else {
      this.props.history.push("/");
    }
  };
}

const mapStoreToProps = (store) => ({
  sessionAuthenticated: store.session.established,
});

const mapDispatchToProps = (dispatch) => ({
  initSession: () =>
    dispatch({ type: "SET_SESSION_ESTABLISHED", established: true }),
});

export const LoginRoute = compose(
  withRouter,
  connect(mapStoreToProps, mapDispatchToProps)
)(_LoginRoute);
