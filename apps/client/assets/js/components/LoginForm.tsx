import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Button, Form, Input } from "semantic-ui-react";
import { Link } from "react-router-dom";

const styles = StyleSheet.create({
  container: {
    border: "1px solid #ccc",
    width: "300px",
    padding: "10px",
    position: "absolute",
    top: "calc(50% - 150px)",
    right: "calc(50% - 150px)",
    background: "black",
  },

  header: {
    fontSize: "1.1rem",
    marginBottom: "40px",
  },

  inputLast: {
    marginTop: "20px",
  },

  submit: {
    marginTop: "40px",
  },

  signup: {
    fontSize: "0.875rem",
    display: "flex",
    justifyContent: "center",
    marginTop: "20px",
  },
});

interface Props {
  onLogin: () => void;
}

interface State {
  username: string;
  password: string;
  usernameIsInvalid: boolean;
  passwordIsInvalid: boolean;
  canSubmit: boolean;
  loggingIn: boolean;
}

export class LoginForm extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      username: "",
      password: "",
      usernameIsInvalid: false,
      passwordIsInvalid: false,
      canSubmit: false,
      loggingIn: false,
    };
  }

  usernameChanged = (_event: any, data: any) => {
    let username = data.value;
    let newState: any = {
      username: username,
      canSubmit: this.validateInputs(username, this.state.password),
    };

    if (
      this.state.usernameIsInvalid &&
      (window as any).Utils.isValidEmail(username)
    ) {
      newState.usernameIsInvalid = false;
    }

    this.setState(newState);
  };

  passwordChanged = (_event: any, data: any) => {
    let password = data.value;
    let newState: any = {
      password: password,
      canSubmit: this.validateInputs(this.state.username, password),
    };

    if (
      this.state.passwordIsInvalid &&
      (window as any).Utils.isValidPassword(password)
    ) {
      newState.passwordIsInvalid = false;
    }

    this.setState(newState);
  };

  validateInputs = (username: string, password: string) => {
    return (
      (window as any).Utils.isValidEmail(username) &&
      (window as any).Utils.isValidPassword(password)
    );
  };

  submit = (event: any) => {
    event.preventDefault();

    let isValid = true;

    if (!(window as any).Utils.isValidEmail(this.state.username)) {
      this.setState({ usernameIsInvalid: true });
      isValid = false;
    }

    if (!(window as any).Utils.isValidPassword(this.state.password)) {
      this.setState({ passwordIsInvalid: true });
      isValid = false;
    }

    if (!isValid) {
      console.log("error yo");
      return;
    }

    this.setState({ loggingIn: true });
    fetch("/api/login", {
      method: "POST",
      credentials: "same-origin",
      body: new FormData(event.target),
    })
      .then((resp) => {
        this.setState({ loggingIn: false });
        if (resp.ok && resp.status === 200) {
          this.props.onLogin();
          return;
        } else {
          return resp.json();
        }
      })
      .then((json) => {
        if (json && json.error) {
          console.error(json.messages);
        }
      });
  };

  render() {
    return (
      <Form
        className={css(styles.container)}
        method="POST"
        action="/login"
        onSubmit={this.submit}
      >
        <div className={css(styles.header)}>Login</div>

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
          loading={this.state.loggingIn}
          className={css(styles.submit)}
        >
          Login
        </Button>

        <Link to="/signup" className={css(styles.signup)}>
          Or signup
        </Link>
      </Form>
    );
  }
}
