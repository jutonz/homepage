import * as React from 'react';
import { LoginForm } from './../components/LoginForm';
}

interface State {
  bgGrid: any;
}

export default class Login extends React.Component<any, State> {
  public componentDidMount() {
    var bgGrid = new window.Utils.BgGrid();
    bgGrid.init();
    bgGrid.start();
    this.setState({ bgGrid: bgGrid });
  }

  public componentWillUnmount() {
    this.state.bgGrid.stop();
  }

  public render() {
    return (
      <div>
        <canvas id="gl-canvas">
          Your browser doesn't appear to support the
          <code>&lt;canvas&gt;</code> element.
        </canvas>

        <LoginForm />
      </div>
    );
  }
}
