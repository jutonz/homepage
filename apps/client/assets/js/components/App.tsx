import * as React from 'react';
import { HashRouter as Router, Route } from 'react-router-dom';

// Routes
import { AuthenticatedRoute } from './../routes/AuthenticatedRoute';
import { HomeRoute } from './../routes/HomeRoute';
import { SignupRoute } from './../routes/SignupRoute';
import { LoginRoute } from './../routes/LoginRoute';
import { SettingsRoute } from './../routes/SettingsRoute';
import { CoffeemakerRoute } from './../routes/CoffeemakerRoute';

class _App extends React.Component {
  public render() {
    return (
      <Router>
        <div>
          <Route path="/login" component={LoginRoute}/>
          <Route path="/signup" component={SignupRoute} />
          <Route path="/coffeemaker" component={CoffeemakerRoute} />

          <AuthenticatedRoute path="/" exact={true} component={HomeRoute} />
          <AuthenticatedRoute path="/settings" component={SettingsRoute} />
        </div>
      </Router>
    );
  }
}

export const App = _App;
