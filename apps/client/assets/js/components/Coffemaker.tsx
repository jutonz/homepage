import * as React from 'react';
import { connect } from 'react-redux';
import { Input, InputOnChangeData } from 'semantic-ui-react';
import { CoffeemakerStoreState } from './../store/reducers/coffeemaker';
import { StoreState, setCoffeemakerAction } from './../Store';
import { Dispatch } from 'react-redux';

interface Props extends CoffeemakerStoreState {
  setFloz(floz: number): any;
}

interface State {
}

class _Coffeemaker extends React.Component<Props, State> {
  public render() {
    return (
      <div>
        How much coffee would you like to make?
        <Input onChange={this.inputChanged} autoFocus error={!!this.props.errorMessage}/>
        fl. oz.

        {this.props.errorMessage &&
          <div>{this.props.errorMessage}</div>
        }

        {this.props.grounds &&
          <div>You will need {this.props.grounds} grams of coffee</div>
        }
      </div>
    );
  }

  public inputChanged = (_event: React.SyntheticEvent<HTMLInputElement>, data: InputOnChangeData) => {
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

export const Coffeemaker = connect(
  mapStoreToProps,
  mapDispatchToProps
)(_Coffeemaker);
