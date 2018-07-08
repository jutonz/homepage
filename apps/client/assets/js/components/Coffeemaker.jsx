import React from "react";
import { Input } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import {
  showFlash,
  setCoffeemakerFlozAction,
  setCoffeemakerGramsAction
} from "@store";
import { connect } from "react-redux";

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

class _Coffeemaker extends React.Component {
  constructor(props) {
    super(props);
    this.state = { focusedInput: "left" };
  }

  render() {
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

  flozChanged = (_event, data) => {
    const floz = parseInt(data.value);
    this.props.setFloz(floz);
  };

  gramsChanged = (_event, data) => {
    const grams = parseInt(data.value);
    this.props.setGrams(grams);
  };
}

const mapStoreToProps = store => ({
  grams: store.coffeemaker.get("grams"),
  floz: store.coffeemaker.get("floz"),
  errorMessage: store.coffeemaker.get("errorMessage")
});

const mapDispatchToProps = dispatch => ({
  setFloz: (floz: number) => dispatch(setCoffeemakerFlozAction(floz)),
  setGrams: (g: number) => dispatch(setCoffeemakerGramsAction(g))
});

export const Coffeemaker = connect(
  mapStoreToProps,
  mapDispatchToProps
)(_Coffeemaker);
