import * as React from "react";
import { ReactNode } from "react";
import { connect } from "react-redux";
import { Input, InputOnChangeData } from "semantic-ui-react";
import { CoffeemakerStoreState } from "./../store/reducers/coffeemaker";
import { StoreState, setCoffeemakerAction } from "./../Store";
import { Dispatch } from "react-redux";

interface Props extends CoffeemakerStoreState {
  setFloz(floz: number): any;
}

interface State {}

class _Coffeemaker extends React.Component<Props, State> {
  public render() {
    return (
      <div>
        How much coffee would you like to make?
        <Input
          onChange={this.flozChanged}
          autoFocus={true}
          error={!!this.props.errorMessage}
        />
        fl. oz.
        {this.renderError()}
        {this.renderResult()}
      </div>
    );
  }

  private renderError = (): ReactNode | null => {
    if (this.props.errorMessage) {
      return <div>{this.props.errorMessage}</div>;
    } else {
      return null;
    }
  };

  private renderResult = (): ReactNode | null => {
    if (this.props.grounds) {
      return <div>You will need {this.props.grounds} grams of coffee</div>;
    } else {
      return null;
    }
  };

  public flozChanged = (
    _event: React.SyntheticEvent<HTMLInputElement>,
    data: InputOnChangeData
  ) => {
    const floz = parseInt(data.value);
    this.props.setFloz(floz);
  };
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  grounds: store.coffeemaker.grounds,
  errorMessage: store.coffeemaker.errorMessage
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  setFloz: (floz: number) => dispatch(setCoffeemakerAction(floz))
});

export const Coffeemaker = connect(mapStoreToProps, mapDispatchToProps)(
  _Coffeemaker
);
