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
    marginBottom: '30%',
    padding: '10px',
    boxShadow: '4px 8px rgba(172, 23, 198, 0.4)'
  },

  header: {
    fontSize: '1rem'
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
        <TextField value="username" onChange={this.usernameChanged} />
        <TextField value="password" onChange={this.usernameChanged} />
        <Button text="Login" onClick={this.submit}/>
      </div>
    );
  }
}
