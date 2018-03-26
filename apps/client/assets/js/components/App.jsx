import React from "react";
import { HashRouter as Router, Route } from "react-router-dom";
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
      <div>
        <Route path="/login" component={LoginRoute} />
        <Route path="/signup" component={SignupRoute} />
        <Route path="/coffeemaker" component={CoffeemakerRoute} />
        <Route path="/resume" component={ResumeRoute} />

        <AuthenticatedRoute path="/" exact={true} component={HomeRoute} />
        <AuthenticatedRoute path="/settings" component={SettingsRoute} />
        <AuthenticatedRoute path="/accounts/:id" component={AccountRoute} />
      </div>
    </Router>
  </div>
);

const renderFlash = messages => {
  return messages.map(message => <Flash message={message} key={message.id} />);
};

const mapStoreToProps = state => ({ flashMessages: state.flash.messages });

export const App = compose(connect(mapStoreToProps, null))(_App);
