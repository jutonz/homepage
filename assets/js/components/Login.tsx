import * as React from 'react';
import { StyleSheet, css } from 'aphrodite';
import { Button, Form, Input, InputOnChangeData } from 'semantic-ui-react';
import { ErrorResponse } from './../declarations';

const styles = StyleSheet.create({
  container: {
    border: '1px solid #ccc',
    width: '300px',
    padding: '10px',
    position: 'absolute',
    top: 'calc(50% - 150px)',
    right: 'calc(50% - 150px)',
    background: 'black'
  },

  header: {
    fontSize: '1.1rem',
    marginBottom: '40px'
  },

  inputLast: {
    marginTop: '20px'
  },

  submit: {
    marginTop: '40px'
  },

  signup: {
    fontSize: '0.875rem',
    display: 'flex',
    justifyContent: 'center',
    marginTop: '20px'
  }
});

interface Props {
  password: string;
  username: string;
  usernameIsInvalid: boolean;
  passwordIsInvalid: boolean;
  canSubmit: boolean;
  csrf_token: string;
}

interface State {
  password?: string;
  username?: string;
  usernameIsInvalid?: boolean;
  passwordIsInvalid?: boolean;
  canSubmit?: boolean;
  csrf_token?: string;
}

export default class Login extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = props;
    this.passwordChanged = this.passwordChanged.bind(this);
    this.usernameChanged = this.usernameChanged.bind(this);
    this.submit = this.submit.bind(this);
  }

  usernameChanged(_event: React.SyntheticEvent<HTMLInputElement>, data: InputOnChangeData) {
    let username = data.value;
    let newState : State = {
      username: username,
      canSubmit: this.validateInputs(username, this.state.password)
    };

    if (this.state.usernameIsInvalid && window.Utils.isValidEmail(username)) {
      newState.usernameIsInvalid = false;
    }

    this.setState(newState);
  }

  passwordChanged(_event: React.SyntheticEvent<HTMLInputElement>, data: InputOnChangeData) {
    let password = data.value;
    let newState: State = {
      password: password,
      canSubmit: this.validateInputs(this.state.username, password)
    };

    if (this.state.passwordIsInvalid && window.Utils.isValidPassword(password)) {
      newState.passwordIsInvalid = false;
    }

    this.setState(newState);
  }

  validateInputs(username: string, password: string) {
    return window.Utils.isValidEmail(username) && window.Utils.isValidPassword(password);
  }

  submit(event: React.FormEvent<HTMLElement>) {
    event.preventDefault();

    let isValid = true;

    if (!window.Utils.isValidEmail(this.state.username)) {
      this.setState({ usernameIsInvalid: true });
      isValid = false;
    }

    if (!window.Utils.isValidPassword(this.state.password)) {
      this.setState({ passwordIsInvalid: true });
      isValid = false;
    }

    if (!isValid) {
      console.log('error yo');
      return;
    }

    fetch("/login", {
      method: "POST",
      credentials: "same-origin",
      body: new FormData(event.target as HTMLFormElement)
    }).then((resp: Response) => {
      if (resp.ok && resp.status === 200) {
        window.location.pathname = "/home";
      } else {
        return resp.json();
      }
    }).then((json: ErrorResponse) => {
      if (json && json.error) {
        console.error(json.messages);
      }
    });
  }

  render() {
    return (
      <Form className={css(styles.container)} method="POST" action="/login" onSubmit={this.submit}>
        <div className={css(styles.header)}>Login</div>
        <input type="hidden" name="_csrf_token" value={this.state.csrf_token}/>

        <Form.Field>
          <label>Email</label>
          <Input name="email" autoFocus={true} onChange={this.usernameChanged} />
        </Form.Field>

        <Form.Field>
          <label>Password</label>
          <Input type="password" name="password" onChange={this.passwordChanged} />
        </Form.Field>

        <Button
          primary={true}
          active={true}
          fluid={true}
          type="submit"
          className={css(styles.submit)}
        >
          Login
        </Button>

        <a href="/signup" className={css(styles.signup)}>Or signup</a>
      </Form>
    );
  }
}
