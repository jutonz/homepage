import React from 'react';
import ReactDOM from 'react-dom';
import { StyleSheet, css } from 'aphrodite';
import TextField from './TextField';
import Button from './Button';

const styles = StyleSheet.create({
  container: {
    border: '1px solid #ccc',
    height: '230px',
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

export default class Signup extends React.Component {
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

  submit(ev) {
    let { hasValidEmail, hasValidPassword } = this.state;
    if (!(hasValidEmail && hasValidPassword)) {
      ev.preventDefault();
      console.log('error yo');
    } else {
      console.log('looks okay');
    }
  }

  render() {
    return (
      <form className={css(styles.container)} action="login" method="POST" onSubmit={this.submit}>
        <div className={css(styles.header)}>Signup</div>
        <input type="hidden" name="_csrf_token" value={this.state.csrf_token}/>
        <TextField
          label="Email"
          name="email"
          value=""
          onChange={this.usernameChanged}
          autofocus
        />
        <TextField
          label="Password"
          name="password"
          value=""
          onChange={this.usernameChanged}
          type="password"
          styles={[styles.inputLast]}
        />
        <Button type="submit" text="Signup" styles={[styles.submit]}/>
      </form>
    );
  }
}
