import * as React from 'react';
import { HashRouter as Router, Route } from 'react-router-dom';
import { connect } from 'react-redux';
import { StoreState } from './../Store';

// Routes
import { AuthenticatedRoute } from './../routes/AuthenticatedRoute';
import { HomeRoute } from './../routes/HomeRoute';
import { SignupRoute } from './../routes/SignupRoute';
import { LoginRoute } from './../routes/LoginRoute';
import { SettingsRoute } from './../routes/SettingsRoute';

interface Props {
  sessionEstablished: boolean;
}

interface State {
}

class _App extends React.Component<Props, State> {
  public render() {
    return (
      <Router>
        <div>
          <Route path="/login" component={LoginRoute}/>
          <Route path="/signup" component={SignupRoute} />

          <AuthenticatedRoute path="/" exact={true} component={HomeRoute} />
          <AuthenticatedRoute path="/settings" component={SettingsRoute} />
        </div>
      </Router>
    );
  }
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  sessionEstablished: store.sessionEstablished
});

export const App = connect(
  mapStoreToProps
)(_App);
