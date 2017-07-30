import React from 'react';
import { StyleSheet, css } from 'aphrodite';

const styles = StyleSheet.create({
  button: {
    display: 'inline-block',
    border: 'none',
    borderRadius: '2px',
    padding: '5px 10px',
    marginTop: '10px'
  },

  jumbo: {
    width: '100%',
    padding: '8px 10px',
    fontSize: '1rem'
  }
});

export default class Button extends React.Component {
  constructor(props) {
    super(props);
    this.state = props;
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e) {
    if (this.state.onClick) {
      this.state.onClick(e);
    }
  }

  render() {
    return (
      <div>
        <button
          className={css(styles.button, styles.jumbo, this.state.styles)}
          onClick={this.handleSubmit}
        >
          {this.state.text}
        </button>
      </div>
    );
  }
}
