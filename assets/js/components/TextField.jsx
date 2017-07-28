import React from 'react';

export default class Input extends React.Component {
  constructor(props) {
    super(props);
    this.state = props;
    this.handleChange = this.handleChange.bind(this);
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
      <div>
        <input
          value={this.state.value}
          onChange={this.handleChange}
        />
      </div>
    );
  }
}
