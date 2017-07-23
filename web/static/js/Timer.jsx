import React from 'react';
import ReactDOM from 'react-dom';
import { StyleSheet, css } from 'aphrodite';

const styles = StyleSheet.create({
  red: {
    color: 'red'
  }
});

class Timer extends React.Component {
  constructor() {
    super(...arguments);
    this.state = { secondsElapsed: 0 };
  }

  tick() {
    this.setState(previousState => ({
      secondsElapsed: previousState.secondsElapsed + 1
    }));
  }

  componentDidMount() {
    this.interval = setInterval(() => {
      this.tick();
    }, 1000);
  }

  componentWillUnmount() {
    clearInterval(this.interval);
  }

  render() {
    return (
      <div className={css(styles.red)}>
        Seconds elapsed: {this.state.secondsElapsed}
      </div>
    )
  }
}

ReactDOM.render(
  <Timer/>,
  document.getElementById('timer')
);
