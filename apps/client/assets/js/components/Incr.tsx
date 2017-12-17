import * as React from "react";
import { Button } from "semantic-ui-react";
import { Action, StoreState, incAction, decAction } from "./../Store";
import { connect, Dispatch } from "react-redux";

interface Props {
  count: number;
  incCount(): Action;
  decCount(): Action;
}

interface State {}

class _Incr extends React.Component<Props, State> {
  public render() {
    return (
      <div>
        Count: {this.props.count}
        <Button onClick={this.props.incCount}>Inc</Button>
        <Button onClick={this.props.decCount}>Dec</Button>
      </div>
    );
  }
}

const mapStateToProps = (state: StoreState): Partial<Props> => ({
  count: state.count
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  incCount: () => dispatch(incAction()),
  decCount: () => dispatch(decAction())
});

export const Incr = connect(mapStateToProps, mapDispatchToProps)(_Incr);
