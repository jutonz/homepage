import { HashRouter as Router, Routes, Route, useHref } from "react-router-dom";
import React from "react";

import { RequireLogin } from "./login/RequireLogin";
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

const requireLogin = (Route) => (
  <RequireLogin>
    <Route />
  </RequireLogin>
);

export const App = () => (
  <div>
    <Router>
      <Routes>
        <Route path="/login" element={<LoginRoute />} />
        <Route path="/signup" element={<SignupRoute />} />
        <Route path="/coffeemaker" element={<CoffeemakerRoute />} />

        <Route path="/" exact={true} element={requireLogin(HomeRoute)} />
        <Route
          path="/twitch"
          exact={true}
          element={
            <RequireLogin>
              <TwitchRoute />
            </RequireLogin>
          }
        />
        <Route
          path="/twitch/channels/:channel_name"
          exact={true}
          element={
            <RequireLogin>
              <TwitchChannelRoute />
            </RequireLogin>
          }
        />
        <Route
          path="/settings"
          element={
            <RequireLogin>
              <SettingsRoute />
            </RequireLogin>
          }
        />
        <Route
          exact
          path="/teams/:id"
          element={
            <RequireLogin>
              <TeamRoute />
            </RequireLogin>
          }
        />
        <Route
          path="/teams/:team_id/users/:user_id"
          element={
            <RequireLogin>
              <TeamUserRoute />
            </RequireLogin>
          }
        />
        <Route
          exact
          path="/ijust"
          element={
            <RequireLogin>
              <IjustRoute />
            </RequireLogin>
          }
        />
        <Route
          exact
          path="/ijust/contexts"
          element={
            <RequireLogin>
              <IjustContextsRoute />
            </RequireLogin>
          }
        />
        <Route
          exact
          path="/ijust/contexts/:id"
          element={
            <RequireLogin>
              <IjustContextRoute />
            </RequireLogin>
          }
        />
        <Route
          exact
          path="/ijust/contexts/:contextId/events/:eventId"
          element={
            <RequireLogin>
              <IjustContextEventRoute />
            </RequireLogin>
          }
        />
        <Route path="*" element={<RedirectToStatic />} />
      </Routes>
    </Router>
  </div>
);

function RedirectToStatic() {
  React.useEffect(() => {
    const href = window.location.href;
    window.location.href = href.replace("/#", "");
  }, []);

  return null;
}
