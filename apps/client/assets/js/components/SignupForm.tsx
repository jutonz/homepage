import * as React from "react";
import { StyleSheet, css } from "aphrodite";
import {
  Button,
  Form,
  FormProps,
  Input,
  InputOnChangeData
} from "semantic-ui-react";
import { StoreState } from "./../Store";
import { connect } from "react-redux";
import { compose } from "redux";
import { withRouter, RouteComponentProps } from "react-router";

const styles = StyleSheet.create({
  container: {
    border: "1px solid #ccc",
    width: "300px",
    padding: "10px",
    position: "absolute",
    top: "calc(50% - 150px)",
    right: "calc(50% - 150px)",
    background: "black"
  },

  header: {
    fontSize: "1.1rem",
    marginBottom: "20px"
  },

  inputLast: {
    marginTop: "20px"
  },

  submit: {
    marginTop: "30px"
  },

  signup: {
    fontSize: "0.875rem",
    display: "flex",
    justifyContent: "center",
    marginTop: "20px"
  }
});

interface Props extends RouteComponentProps<{}> {
  csrfToken: string;
}

interface State {
  password: string;
  username: string;
  canSubmit: boolean;
  signingUp: boolean;
}

class _SignupForm extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      password: "",
      username: "",
      canSubmit: false,
      signingUp: false
    };
    this.passwordChanged = this.passwordChanged.bind(this);
    this.usernameChanged = this.usernameChanged.bind(this);
    this.submit = this.submit.bind(this);
  }

  usernameChanged(
    _event: React.SyntheticEvent<HTMLInputElement>,
    data: InputOnChangeData
  ) {
    let username = data.value;
    this.setState({
      username: username,
      canSubmit: this.validateInputs(username, this.state.password)
    });
  }

  passwordChanged(
    _event: React.SyntheticEvent<HTMLInputElement>,
    data: InputOnChangeData
  ) {
    let password = data.value;
    this.setState({
      password: password,
      canSubmit: this.validateInputs(this.state.username, password)
    });
  }

  validateInputs(username: string, password: string): boolean {
    return (
      window.Utils.isValidEmail(username) &&
      window.Utils.isValidPassword(password)
    );
  }

  submit(event: React.FormEvent<HTMLElement>, _data: FormProps) {
    event.preventDefault();

    if (!this.state.canSubmit) {
      console.log("error yo");
      return;
    }

    this.setState({ signingUp: true });

    fetch("/api/signup", {
      method: "POST",
      credentials: "same-origin",
      body: new FormData(event.target as HTMLFormElement),
      headers: new Headers({ "X-CSRF-Token": this.props.csrfToken })
    })
      .then((resp: Response) => {
        if (resp.ok && resp.status === 200) {
          window.location.hash = "#/";
          //this.props.history.push("/");
        } else {
          return resp.json();
        }
      })
      .then((json: any) => {
        if (json && json.error) {
          console.error(json.messages);
        }
      });
  }

  render() {
    return (
      <Form
        className={css(styles.container)}
        action="signup"
        method="POST"
        onSubmit={this.submit}
      >
        <div className={css(styles.header)}>Signup</div>

        <Form.Field>
          <label>Email</label>
          <Input
            name="email"
            autoFocus={true}
            onChange={this.usernameChanged}
          />
        </Form.Field>

        <Form.Field>
          <label>Password</label>
          <Input
            type="password"
            name="password"
            onChange={this.passwordChanged}
          />
        </Form.Field>

        <Button
          primary={true}
          active={true}
          fluid={true}
          type="submit"
          loading={this.state.signingUp}
          className={css(styles.submit)}
        >
          Signup
        </Button>
      </Form>
    );
  }
}

const mapStoreToProps = (store: StoreState): Partial<Props> => ({
  csrfToken: store.csrfToken
});

export const SignupForm = compose(withRouter, connect(mapStoreToProps))(
  _SignupForm
);
