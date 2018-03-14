import * as React from "react";
import { ReactNode } from "react";
import { HashRouter as Router, Route } from "react-router-dom";
import { compose } from "redux";
import { connect, Dispatch } from "react-redux";
import { css, StyleSheet } from "aphrodite";
import { FlashMessage, StoreState } from "./../Store";
import { Flash } from "./Flash";

// Routes
import { AuthenticatedRoute } from "./../routes/AuthenticatedRoute";
import { HomeRoute } from "./../routes/HomeRoute";
import { SignupRoute } from "./../routes/SignupRoute";
import { LoginRoute } from "./../routes/LoginRoute";
import { SettingsRoute } from "./../routes/SettingsRoute";
import { CoffeemakerRoute } from "./../routes/CoffeemakerRoute";
import { ResumeRoute } from "./../routes/ResumeRoute";
import { AccountRoute } from "./../routes/AccountRoute";

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

interface IProps {
  flashMessages: Array<FlashMessage>;
}

const _App = (props: IProps) => (
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
        <AuthenticatedRoute
          path="/accounts/:id"
          render={(props: any) => (
            <AccountRoute {...props} />
          )}
        />
      </div>
    </Router>
  </div>
);

const renderFlash = (messages: Array<FlashMessage>): ReactNode | null => {
  return messages.map(message => <Flash message={message} key={message.id} />);
};

const mapStoreToProps = (state: StoreState): Partial<IProps> => ({
  flashMessages: state.flash.messages
});

const mapDispatchToProps = (_dispatch: Dispatch<{}>): Partial<IProps> => ({});

export const App = compose(connect(mapStoreToProps, mapDispatchToProps))(_App);
