import React from "react";
import { StyleSheet, css } from "aphrodite";
import Globals from "./../style-globals"

const styles = StyleSheet.create({
  container: {
    display: "flex",
    flexDirection: "column"
  },

  label: {
    fontSize: "0.875rem",
    marginBottom: "5px"
  },

  labelInvalid: {
    color: Globals.errorColor
  },

  input: {
    border: "2px solid transparent",
    padding: "5px 7px"
  },

  inputInvalid: {
    border: `2px solid ${Globals.errorColor}`,

    ":focus": {
      outlineColor: Globals.errorColor
    }
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
          <label
            htmlFor={this.id}
            className={css(
              styles.label,
              this.props.isInvalid && styles.labelInvalid,
              this.state.styles
            )}
          >
            {this.props.label}
          </label>
        }
        <input
          id={this.id}
          name={this.state.name}
          className={css(styles.input, this.props.isInvalid && styles.inputInvalid)}
          value={this.state.value}
          onChange={this.handleChange}
          type={this.props.type || "text"}
        />
      </div>
    );
  }
}
