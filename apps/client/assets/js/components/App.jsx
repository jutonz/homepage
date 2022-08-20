import { HashRouter as Router, Routes, Route } from "react-router-dom";
import { compose } from "redux";
import { connect } from "react-redux";
import { css, StyleSheet } from "aphrodite";
import React from "react";

import { Flash } from "./Flash";
import { AuthenticatedRoute } from "./../routes/AuthenticatedRoute";
import { CoffeemakerRoute } from "./../routes/CoffeemakerRoute";
import { HomeRoute } from "./../routes/HomeRoute";
import { IjustContextEventRoute } from "./../routes/ijust/IjustContextEventRoute";
import { IjustContextRoute } from "./../routes/IjustContextRoute";
import { IjustContextsRoute } from "./../routes/IjustContextsRoute";
import { IjustRoute } from "./../routes/IjustRoute";
import { LoginRoute } from "./../routes/LoginRoute";
import { SettingsRoute } from "./../routes/SettingsRoute";
import { SignupRoute } from "./../routes/SignupRoute";
import { TeamRoute } from "./../routes/TeamRoute";
import { TeamUserRoute } from "./../routes/TeamUserRoute";
import { TwitchRoute } from "./../routes/TwitchRoute";
import { TwitchChannelRoute } from "./../routes/twitch/TwitchChannelRoute";

const style = StyleSheet.create({
  flashContainer: {
    position: "absolute",
    width: "100%",
    top: "10px",
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    flexDirection: "column",
  },
});

const _App = ({ flashMessages }) => (
  <div>
    <div className={css(style.flashContainer)}>
      {renderFlash(flashMessages)}
    </div>

    <Routes>
      <Route path="/login" component={LoginRoute} />
      <Route path="/signup" component={SignupRoute} />
      <Route path="/coffeemaker" component={CoffeemakerRoute} />

      <AuthenticatedRoute path="/" exact={true} component={HomeRoute} />
      <AuthenticatedRoute path="/twitch" exact={true} component={TwitchRoute} />
      <AuthenticatedRoute
        path="/twitch/channels/:channel_name"
        exact={true}
        component={TwitchChannelRoute}
      />
      <AuthenticatedRoute path="/settings" component={SettingsRoute} />
      <AuthenticatedRoute exact path="/teams/:id" component={TeamRoute} />
      <AuthenticatedRoute
        path="/teams/:team_id/users/:user_id"
        component={TeamUserRoute}
      />
      <AuthenticatedRoute exact path="/ijust" component={IjustRoute} />
      <AuthenticatedRoute
        exact
        path="/ijust/contexts"
        component={IjustContextsRoute}
      />
      <AuthenticatedRoute
        exact
        path="/ijust/contexts/:id"
        component={IjustContextRoute}
      />
      <AuthenticatedRoute
        exact
        path="/ijust/contexts/:contextId/events/:eventId"
        component={IjustContextEventRoute}
      />
    </Routes>
  </div>
);

const renderFlash = (messages) => {
  let comps = [];

  messages.mapEntries(([id, message]) => {
    comps.push(<Flash message={message.get("message")} key={id} />);
  });

  return comps;
};

const mapStoreToProps = (state) => ({
  flashMessages: state.flash.get("messages"),
});

export const App = compose(connect(mapStoreToProps, null))(_App);
