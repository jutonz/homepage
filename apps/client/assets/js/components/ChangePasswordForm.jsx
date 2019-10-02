import React from "react";
import { StyleSheet, css } from "aphrodite";
import gql from "graphql-tag";
import { Button, Header, Form, Message } from "semantic-ui-react";

import { FormBox } from "@components/FormBox";

const styles = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30
  },

  submit: {
    marginTop: 30
  }
});

export class _ChangePasswordForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: false,
      oldPassword: "",
      newPassword: "",
      newPasswordConfirm: "",
      formState: "pending"
    };
  }

  render() {
    return (
      <div className={css(styles.container)}>
        <FormBox>
          <Form className={this.state.formState} onSubmit={this.submit}>
            <Header>Change password</Header>

            {this.renderStatusMessage()}

            <Form.Field>
              <Form.Input
                name="current_password"
                label="Current password"
                type="password"
                autoFocus={true}
                onChange={this.oldPasswordChanged}
              />
            </Form.Field>

            <Form.Field>
              <Form.Input
                label="New password"
                type="password"
                name="new_password"
                error={this.state.confirmBad}
                onChange={this.newPasswordChanged}
              />
            </Form.Field>

            <Form.Field>
              <Form.Input
                type="password"
                label="Confirm new password"
                name="new_password_confirm"
                error={this.state.confirmBad}
                onChange={this.newPasswordConfirmChanged}
              />
            </Form.Field>

            <Button
              primary={true}
              active={true}
              fluid={true}
              type="submit"
              className={css(styles.submit)}
              loading={this.state.loading}
            >
              Change password
            </Button>
          </Form>
        </FormBox>
      </div>
    );
  }

  renderStatusMessage = () => {
    switch (this.state.formState) {
      case "success":
        return (
          <Message success={true} header="Success" content="Password updated" />
        );
      case "error":
        return (
          <Message
            error={true}
            header="Error"
            content={this.state.errorMessage}
          />
        );
      default:
        return null;
    }
  };

  oldPasswordChanged = (_event, data) => {
    const oldPassword = data.value;
    this.setState({ oldPassword: oldPassword });
  };

  newPasswordChanged = (_event, data) => {
    const newPassword = data.value;
    this.setState({ newPassword: newPassword });
    this.comparePasswords(newPassword, this.state.newPasswordConfirm);
  };

  newPasswordConfirmChanged = (_event, data) => {
    const newPasswordConfirm = data.value;
    this.setState({ newPasswordConfirm: newPasswordConfirm });
    this.comparePasswords(this.state.newPassword, newPasswordConfirm);
  };

  comparePasswords(newPassword, newPasswordConfirm) {
    if (newPasswordConfirm === "" || newPassword === "") {
      return;
    } else if (newPassword !== newPasswordConfirm) {
      this.setState({
        confirmBad: true
      });
    } else {
      this.setState({
        confirmBad: undefined
      });
    }
  }

  submit = event => {
    event.preventDefault();
    this.setState({
      errorMessage: null,
      formState: FormState.Pending
    });

    const { oldPassword, newPassword } = this.state;

    const mutation = gql`
    mutation {
      changePassword(currentPassword: "${oldPassword}", newPassword: "${newPassword}") {
        id
      }
    }`;

    this.setState({ loading: true });

    window.grapqlClient
      .mutate({
        mutation: mutation
      })
      .then(_response => {
        this.setState({ loading: false });
        this.onPasswordChangeSuccess();
      })
      .catch(error => {
        this.setState({
          loading: false,
          formState: FormState.Error,
          errorMessage: error.message || "Failed to update password"
        });
      });
  };

  onPasswordChangeSuccess = () => {
    this.setState({
      oldPassword: "",
      newPassword: "",
      newPasswordConfirm: "",
      formState: FormState.Success
    });
  };
}

export const ChangePasswordForm = _ChangePasswordForm;
