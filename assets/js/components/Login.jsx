import React from 'react';
import ReactDOM from 'react-dom';
import { StyleSheet, css } from 'aphrodite';
import TextField from './TextField.jsx';
import Button from './Button.jsx';

const styles = StyleSheet.create({
  container: {
    border: '1px solid #ccc',
    height: '300px',
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

export default class Login extends React.Component {
  constructor(props) {
    super(props);
    this.state = props;
    this.passwordChanged = this.passwordChanged.bind(this);
    this.usernameChanged = this.usernameChanged.bind(this);
    this.submit = this.submit.bind(this);
  }

  usernameChanged(username) {
    let newState = {
      username: username,
      canSubmit: this.validateInputs(username, this.state.password)
    };

    if (this.state.usernameIsInvalid && Utils.IsValidEmail(username)) {
      newState.usernameIsInvalid = false;
    }

    this.setState(newState);
  }

  passwordChanged(password) {
    let newState = {
      password: password,
      canSubmit: this.validateInputs(this.state.username, password)
    };

    if (this.state.passwordIsInvalid && Utils.IsValidPassword(password)) {
      newState.passwordIsInvalid = false;
    }

    this.setState(newState);
  }

  validateInputs(username, password) {
    return Utils.IsValidEmail(username) && Utils.IsValidPassword(password);
  }

  submit(event) {
    let isValid = true;

    if (!Utils.IsValidEmail(this.state.username)) {
      this.setState({ usernameIsInvalid: true });
      isValid = false;
    }

    if (!Utils.IsValidPassword(this.state.password)) {
      this.setState({ passwordIsInvalid: true });
      isValid = false;
    }

    if (!isValid) {
      event.preventDefault();
      console.log('error yo');
    }
  }

  render() {
    return (
      <form className={css(styles.container)} action="login" method="POST" onSubmit={this.submit}>
        <div className={css(styles.header)}>Login</div>
        <input type="hidden" name="_csrf_token" value={this.state.csrf_token}/>
        <TextField
          label="Username"
          name="email"
          value=""
          onChange={this.usernameChanged}
          isInvalid={this.state.usernameIsInvalid}
          autofocus
        />
        <TextField
          label="Password"
          name="password"
          type="password"
          value=""
          onChange={this.passwordChanged}
          isInvalid={this.state.passwordIsInvalid}
          styles={[styles.inputLast]}
        />
        <Button text="Login" type="submit" styles={[styles.submit]}/>
        <a href="/signup" className={css(styles.signup)}>Or signup</a>
      </form>
    );
  }
}
