import React from 'react';
import ReactDOM from 'react-dom';
import { StyleSheet, css } from 'aphrodite';

export default class Hello extends React.Component {
  constructor(props) {
    super(props);
    this.state = props;
  }

  render() {
    return (
      <div>
        <h3>Hello {this.state.name}!</h3>
      </div>
    );
  }
}
