import * as React from 'react';
import Home from './../routes/Home';
import Signup from './../routes/Signup';
import Login from './../routes/Login';
import Settings from './../routes/Settings';
import { HashRouter as Router, Route } from 'react-router-dom';

interface Props {
}

interface State {
}

export default class App extends React.Component<Props, State> {
  public render() {
    return (
      <Router>
        <div>
          <Route path="/" exact={true} component={Home} />
          <Route path="/login" component={Login} />
          <Route path="/signup" component={Signup} />
          <Route path="/settings" component={Settings} />
        </div>
      </Router>
    );
  }
}
