import React from 'react';
import { StyleSheet, css } from 'aphrodite';

const styles = StyleSheet.create({
  container: {
    display: 'flex',
    flexDirection: 'column'
  },

  label: {
    fontSize: '0.875rem',
    marginBottom: '5px'
  },

  input: {
    padding: '5px 7px'
  }
});

export default class Input extends React.Component {
  constructor(props) {
    super(props);
    this.state = props;
    this.id = this.randomId();
    this.handleChange = this.handleChange.bind(this);
  }

  componentDidMount() {
    if (this.props.autofocus) {
      document.getElementById(this.id).focus();
    }
  }

  randomId() {
    return `text-field-${Math.random()}`;
  }

  handleChange(e) {
    let newValue = e.target.value;
    if (this.state.onChange) {
      this.state.onChange(newValue);
    }
    this.setState({ value: newValue });
  }

  render() {
    return (
      <div className={css(styles.container)}>
        { this.props.label &&
          <label htmlFor={this.id} className={css(styles.label, this.state.styles)}>
            {this.props.label}
          </label>
        }
        <input
          id={this.id}
          className={css(styles.input)}
          value={this.state.value}
          onChange={this.handleChange}
        />
      </div>
    );
  }
}
