import * as React from "react";
import { Input } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";

const styles = StyleSheet.create({
  container: {
    display: "flex",
    alignItems: "center",
  },

  spacer: {
    margin: "0 10px",
  },
});

interface Props {}
interface State {
  floz: number;
  focusedInput: string;
  grams: number;
}
export class Coffeemaker extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      floz: 0,
      grams: 0,
      focusedInput: "left",
    };
  }

  render() {
    const { floz, grams } = this.state;
    const flozStr = floz ? floz.toString() : "";
    const gramsStr = grams ? grams.toString() : "";

    return (
      <div className={css(styles.container)}>
        <Input
          label="floz brewed coffee"
          labelPosition="right"
          autoFocus={true}
          onFocus={() => this.setState({ focusedInput: "left" })}
          {...(this.state.focusedInput === "left"
            ? { onChange: (_ev, data) => this.flozChanged(data.value) }
            : { value: flozStr })}
        />

        <div className={css(styles.spacer)}>{"<=>"}</div>

        <Input
          label="grams of beans"
          labelPosition="right"
          onFocus={() => this.setState({ focusedInput: "right" })}
          {...(this.state.focusedInput === "right"
            ? { onChange: (_ev, data) => this.gramsChanged(data.value) }
            : { value: gramsStr })}
        />
      </div>
    );
  }

  flozChanged(newValue) {
    const floz = parseInt(newValue);
    const grams = gramsForWater(floz);
    this.setState({ floz, grams });
  }

  gramsChanged(newValue) {
    const grams = parseInt(newValue);
    const floz = flozForGrams(grams);
    this.setState({ floz, grams });
  }
}

const FLOZ_PER_CUP = 6.0;
const GRAMS_PER_CUP = 10.0;

const round = (a) => Math.round(a * 100) / 100;

const flozForGrams = (grams) => {
  const floz = (grams / GRAMS_PER_CUP) * FLOZ_PER_CUP;
  return round(floz);
};

const gramsForWater = (floz) => {
  const cups = floz / FLOZ_PER_CUP;
  const grams = cups * GRAMS_PER_CUP;
  return round(grams);
};
