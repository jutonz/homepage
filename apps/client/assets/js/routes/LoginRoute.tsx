import * as React from 'react';
import { LoginForm } from './../components/LoginForm';
import { connect } from 'react-redux';
import { StoreState } from './../Store';
import { compose } from 'redux';
import { withRouter, RouteComponentProps } from 'react-router-dom';

interface Props extends RouteComponentProps<{}> {
  sessionAuthenticated: boolean;
}

interface State {
  bgGrid: any;
}

class _LoginRoute extends React.Component<Props, State> {
  public constructor(props: Props) {
    super(props);
    this.state = {
      bgGrid: new window.Utils.BgGrid()
    };
  }

  public componentDidMount() {
    if (this.props.sessionAuthenticated) {
      console.log('Already authenticatd.');
      this.props.history.push("/");
    } else {
      this.state.bgGrid.init();
      this.state.bgGrid.start();
    }
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

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  sessionAuthenticated: store.sessionAuthenticated
});

export const LoginRoute = compose(
  withRouter,
  connect(mapStoreToProps)
)(_LoginRoute);
