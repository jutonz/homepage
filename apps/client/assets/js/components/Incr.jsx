import React from "react";
import { Button } from "semantic-ui-react";
import { connect } from "react-redux";

class _Incr extends React.Component {
  render() {
    return (
      <div>
        Count: {this.props.count}
        <Button onClick={this.props.incCount}>Inc</Button>
        <Button onClick={this.props.decCount}>Dec</Button>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  count: state.count.count
});

const mapDispatchToProps = dispatch => ({
  incCount: () => dispatch({ type: "INC" }),
  decCount: () => dispatch({ type: "DEC" })
});

export const Incr = connect(
  mapStateToProps,
  mapDispatchToProps
)(_Incr);
