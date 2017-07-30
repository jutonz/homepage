import React from 'react';
import ReactDOM from 'react-dom';
import { StyleSheet, css } from 'aphrodite';
import TextField from './TextField';
import Button from './Button';

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

  usernameChanged(newValue) {
    console.log('username is now', newValue);
    this.setState({ username: newValue });
  }

  passwordChanged(newValue) {
    console.log('password is now', newValue);
    this.setState({ password: newValue });
  }

  submit(e) {
    console.log('Submit!');
  }

  render() {
    return (
      <div className={css(styles.container)}>
        <div className={css(styles.header)}>Login</div>
        <TextField label="Username" value="" onChange={this.usernameChanged} autofocus/>
        <TextField label="Password" value="" onChange={this.usernameChanged} styles={[styles.inputLast]}/>
        <Button text="Login" onClick={this.submit} styles={[styles.submit]}/>
        <a href="/signup" className={css(styles.signup)}>Or signup</a>
      </div>
    );
  }
}
