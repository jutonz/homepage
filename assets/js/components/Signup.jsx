import React from 'react';
import ReactDOM from 'react-dom';
import { StyleSheet, css } from 'aphrodite';
import { Button, Form, Input } from 'semantic-ui-react';

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

export default class Signup extends React.Component {
  constructor(props) {
    super(props);
    this.state = props;
    this.passwordChanged = this.passwordChanged.bind(this);
    this.usernameChanged = this.usernameChanged.bind(this);
    this.submit = this.submit.bind(this);
  }

  usernameChanged(event, data) {
    let username = data.value;
    this.setState({
      username: username,
      canSubmit: this.validateInputs(username, this.state.password)
    });
  }

  passwordChanged(event, data) {
    let password = data.value;
    this.setState({
      password: password,
      canSubmit: this.validateInputs(this.state.username, password)
    });
  }

  validateInputs(username, password) {
    return Utils.IsValidEmail(username) && Utils.IsValidPassword(password);
  }

  submit(ev) {
    if (!this.state.canSubmit) {
      ev.preventDefault();
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
