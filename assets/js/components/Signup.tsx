import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { StyleSheet, css } from 'aphrodite';
import {
  Button,
  Form,
  FormProps,
  Input,
  InputOnChangeData
} from 'semantic-ui-react';

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
    marginBottom: '20px'
  },

  inputLast: {
    marginTop: '20px'
  },

  submit: {
    marginTop: '30px'
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
  canSubmit: boolean;
  csrf_token: string;
}

interface State {
  password: string;
  username: string;
  canSubmit: boolean;
  csrf_token: string;
}

export default class Signup extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = props;
    this.passwordChanged = this.passwordChanged.bind(this);
    this.usernameChanged = this.usernameChanged.bind(this);
    this.submit = this.submit.bind(this);
  }

  usernameChanged(event: React.SyntheticEvent<HTMLInputElement>, data: InputOnChangeData) {
    let username = data.value;
    this.setState({
      username: username,
      canSubmit: this.validateInputs(username, this.state.password)
    });
  }

  passwordChanged(event: React.SyntheticEvent<HTMLInputElement>, data: InputOnChangeData) {
    let password = data.value;
    this.setState({
      password: password,
      canSubmit: this.validateInputs(this.state.username, password)
    });
  }

  validateInputs(username: string, password: string): boolean {
    return window.Utils.isValidEmail(username) && window.Utils.isValidPassword(password);
  }

  submit(event: React.FormEvent<HTMLElement>, data: FormProps) {
    if (!this.state.canSubmit) {
      event.preventDefault();
      console.log("error yo");
    }
  }

  render() {
    return (
      <Form className={css(styles.container)} action="signup" method="POST" onSubmit={this.submit}>
        <div className={css(styles.header)}>Signup</div>
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
          Signup
        </Button>
      </Form>
    );
  }
}
