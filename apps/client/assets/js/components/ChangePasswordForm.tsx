import { css, StyleSheet } from "aphrodite";
import gql from "graphql-tag";
import React, { useState } from "react";
import {
  Button,
  Form,
  Header,
  InputOnChangeData,
  Message,
} from "semantic-ui-react";
import { useMutation } from "urql";

import { FormBox } from "./FormBox";

const styles = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
  },
  submit: {
    marginTop: 30,
  },
});

const ChangePassword = gql`
  mutation ($currentPassword: String!, $newPassword: String!) {
    changePassword(
      currentPassword: $currentPassword
      newPassword: $newPassword
    ) {
      id
    }
  }
`;

export function ChangePasswordForm() {
  const [loading, setLoading] = useState<boolean>(false);
  const [oldPassword, setOldPassword] = useState<string>("");
  const [newPassword, setNewPassword] = useState<string>("");
  const [newPasswordConfirm, setNewPasswordConfirm] = useState<string>("");
  const [formState, setFormState] = useState<string>("pending");
  const [errorMessage, setErrorMessage] = useState<string>("");
  const [confirmBad, setConfirmBad] = useState<boolean>(false);
  const [_changePasswordResult, changePassword] = useMutation(ChangePassword);

  function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setErrorMessage("");
    setFormState("pending");
    setLoading(true);

    const vars = { currentPassword: oldPassword, newPassword };
    changePassword(vars).then((result) => {
      setLoading(false);

      if (result.error) {
        setFormState("error");
        console.error(result.error);
        setErrorMessage(result.error.message || "Failed to update password");
      } else {
        setOldPassword("");
        setNewPassword("");
        setNewPasswordConfirm("");
        setFormState("success");
      }
    });
  }

  function renderStatusMessage() {
    switch (formState) {
      case "success":
        return (
          <Message success={true} header="Success" content="Password updated" />
        );
      case "error":
        return <Message error={true} header="Error" content={errorMessage} />;
      default:
        return null;
    }
  }

  function comparePasswords(newPasswordConfirm: string) {
    if (newPasswordConfirm === "" || newPassword === "") {
      return;
    } else if (newPassword !== newPasswordConfirm) {
      setConfirmBad(true);
    } else {
      setConfirmBad(false);
    }
  }

  return (
    <div className={css(styles.container)}>
      <FormBox>
        <Form className={formState} onSubmit={submit}>
          <Header>Change password</Header>

          {renderStatusMessage()}

          <Form.Field>
            <Form.Input
              name="current_password"
              label="Current password"
              type="password"
              autoFocus={true}
              value={oldPassword}
              onChange={(_event, { value }: InputOnChangeData) => {
                setOldPassword(value);
              }}
            />
          </Form.Field>

          <Form.Field>
            <Form.Input
              label="New password"
              type="password"
              name="new_password"
              error={confirmBad}
              value={newPassword}
              onChange={(_event, { value }: InputOnChangeData) => {
                setNewPassword(value);
                setConfirmBad(false);
              }}
            />
          </Form.Field>

          <Form.Field>
            <Form.Input
              type="password"
              label="Confirm new password"
              name="new_password_confirm"
              error={confirmBad}
              value={newPasswordConfirm}
              onChange={(_event, { value }: InputOnChangeData) => {
                setNewPasswordConfirm(value);
                comparePasswords(value);
              }}
            />
          </Form.Field>

          <Button
            primary
            active
            fluid
            type="submit"
            className={css(styles.submit)}
            loading={loading}
          >
            Change password
          </Button>
        </Form>
      </FormBox>
    </div>
  );
}
