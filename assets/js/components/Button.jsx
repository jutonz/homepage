import React from 'react';

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
        <button onClick={this.handleSubmit}>{this.state.text}</button>
      </div>
    );
  }
}
