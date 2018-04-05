import React from "react";
import { HashRouter as Router, Route, Switch } from "react-router-dom";
import { compose } from "redux";
import { connect } from "react-redux";
import { css, StyleSheet } from "aphrodite";
import { Flash } from "@components/Flash";

// Routes
import { AuthenticatedRoute } from "@routes/AuthenticatedRoute";
import { HomeRoute } from "@routes/HomeRoute";
import { SignupRoute } from "@routes/SignupRoute";
import { LoginRoute } from "@routes/LoginRoute";
import { SettingsRoute } from "@routes/SettingsRoute";
import { CoffeemakerRoute } from "@routes/CoffeemakerRoute";
import { ResumeRoute } from "@routes/ResumeRoute";
import { AccountRoute } from "@routes/AccountRoute";
import { AccountUserRoute } from "@routes/AccountUserRoute";

const style = StyleSheet.create({
  flashContainer: {
    position: "absolute",
    width: "100%",
    top: "10px",
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    flexDirection: "column"
  }
});

const _App = props => (
  <div>
    <div className={css(style.flashContainer)}>
      {renderFlash(props.flashMessages)}
    </div>

    <Router>
      <Switch>
        <Route path="/login" component={LoginRoute} />
        <Route path="/signup" component={SignupRoute} />
        <Route path="/coffeemaker" component={CoffeemakerRoute} />
        <Route path="/resume" component={ResumeRoute} />

        <AuthenticatedRoute path="/" exact={true} component={HomeRoute} />
        <AuthenticatedRoute path="/settings" component={SettingsRoute} />
        <AuthenticatedRoute
          exact
          path="/accounts/:id"
          component={AccountRoute}
        />
        <AuthenticatedRoute
          path="/accounts/:account_id/users/:user_id"
          component={AccountUserRoute}
        />
      </Switch>
    </Router>
  </div>
);

const renderFlash = messages => {
  let comps = [];

  messages.mapEntries(([id, message]) => {
    comps.push(<Flash message={message.get("message")} key={id} />);
  });

  return comps;
};

const mapStoreToProps = state => ({
  flashMessages: state.flash.get("messages")
});

export const App = compose(connect(mapStoreToProps, null))(_App);
