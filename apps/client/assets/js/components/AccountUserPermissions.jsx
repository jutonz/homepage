import { Form, Header } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";
import React from "react";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30,
    display: "flex",
    flexDirection: "column",
    flexGrow: 1
  }
});

const _AccountUserPermissions = ({ user, perms, fetchPerms, save }) => {
  if (!perms) {
    fetchPerms(user.id);
  }

  return (
    <div className={css(style.container)}>
      <Form>
        <Header>User permissions</Header>
        <p>This user is allowed to:</p>
        <Form.Checkbox
          label="Rename the account"
          value="rename_account"
          onChange={(_ev, data) => save(user.id, data)}
        />
        <Form.Checkbox
          label="Delete the account"
          value="delete_account"
          onChange={(_ev, data) => save(user.id, data.checked)}
        />
      </Form>
    </div>
  );
};

export const AccountUserPermissions = connect(
  state => ({
    isLoading: false
  }),
  dispatch => ({
    save: (userId, { value, checked }) => {
      debugger;
    },
    fetchPerms: () => dispatch({ type: "" })

    //save: id => dispatch({ type: "SAVE_ACCOUNT_USER_PERMS", id })
  })
)(_AccountUserPermissions);
