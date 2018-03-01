import * as React from "react";
import { Input, InputOnChangeData } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { CoffeemakerStoreState } from "./../store/reducers/coffeemaker";
import {
  StoreState,
  setCoffeemakerFlozAction,
  setCoffeemakerGramsAction
} from "./../Store";
import { connect, Dispatch } from "react-redux";

const styles = StyleSheet.create({
  container: {
    display: "flex",
    alignItems: "center"
  },

  spacer: {
    margin: "0 10px"
  },

  inputContainer: {}
});

interface Props extends CoffeemakerStoreState {
  setFloz(floz: number): any;
  setGrams(g: number): any;
}

interface State {
  focusedInput: string;
}

class _Coffeemaker extends React.Component<Props, State> {
  public constructor(props: Props) {
    super(props);
    this.state = {
      focusedInput: "left"
    };
  }

  public render() {
    const { floz, grams } = this.props;
    const flozStr = floz ? floz.toString() : "";
    const gramsStr = grams ? grams.toString() : "";

    return (
      <div className={css(styles.container)}>
        <div className={css(styles.inputContainer)}>
          <Input
            label="floz brewed coffee"
            labelPosition="right"
            autoFocus={true}
            onFocus={() => this.setState({ focusedInput: "left" })}
            {...(this.state.focusedInput === "left"
              ? { onChange: this.flozChanged }
              : { value: flozStr })}
          />
        </div>

        <div className={css(styles.spacer)}>{"<=>"}</div>

        <div className={css(styles.inputContainer)}>
          <Input
            label="grams of beans"
            labelPosition="right"
            onFocus={() => this.setState({ focusedInput: "right" })}
            {...(this.state.focusedInput === "right"
              ? { onChange: this.gramsChanged }
              : { value: gramsStr })}
          />
        </div>
      </div>
    );
  }

  public flozChanged = (
    _event: React.SyntheticEvent<HTMLInputElement>,
    data: InputOnChangeData
  ) => {
    const floz = parseInt(data.value);
    this.props.setFloz(floz);
  };

  public gramsChanged = (
    _event: React.SyntheticEvent<HTMLInputElement>,
    data: InputOnChangeData
  ) => {
    const grams = parseInt(data.value);
    this.props.setGrams(grams);
  };
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  grams: store.coffeemaker.grams,
  floz: store.coffeemaker.floz,
  errorMessage: store.coffeemaker.errorMessage
});

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  setFloz: (floz: number) => dispatch(setCoffeemakerFlozAction(floz)),
  setGrams: (g: number) => dispatch(setCoffeemakerGramsAction(g))
});

export const Coffeemaker = connect(mapStoreToProps, mapDispatchToProps)(
  _Coffeemaker
);
