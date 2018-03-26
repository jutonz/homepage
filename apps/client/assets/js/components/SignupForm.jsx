import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Button, Form, Input } from "semantic-ui-react";
import { connect } from "react-redux";
import { compose } from "redux";
import { withRouter } from "react-router";

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

class _SignupForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      password: "",
      username: "",
      canSubmit: false,
      signingUp: false
    };
  }

  usernameChanged = (_event, data) => {
    let username = data.value;
    this.setState({
      username: username,
      canSubmit: this.validateInputs(username, this.state.password)
    });
  };

  passwordChanged = (_event, data) => {
    let password = data.value;
    this.setState({
      password: password,
      canSubmit: this.validateInputs(this.state.username, password)
    });
  };

  validateInputs = (username, password) => {
    return (
      window.Utils.isValidEmail(username) &&
      window.Utils.isValidPassword(password)
    );
  };

  submit = (event, _data) => {
    event.preventDefault();

    if (!this.state.canSubmit) {
      console.log("error yo");
      return;
    }

    this.setState({ signingUp: true });

    fetch("/api/signup", {
      method: "POST",
      credentials: "same-origin",
      body: new FormData(event.target)
    })
      .then(resp => {
        if (resp.ok && resp.status === 200) {
          window.location.hash = "#/";
          //this.props.history.push("/");
        } else {
          return resp.json();
        }
      })
      .then(json => {
        if (json && json.error) {
          console.error(json.messages);
        }
        this.setState({ signingUp: false });
      })
      .catch(error => {
        console.error(error);
        this.setState({ signingUp: false });
      });
  };

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

const mapStoreToProps = store => ({
  csrfToken: store.csrfToken
});

export const SignupForm = compose(withRouter, connect(mapStoreToProps))(
  _SignupForm
);
