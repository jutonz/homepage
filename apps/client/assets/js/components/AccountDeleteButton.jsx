import React from "react";
import { Button, Header, Form, Message } from "semantic-ui-react";
import { connect, Dispatch } from "react-redux";
import { StyleSheet, css } from "aphrodite";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30
  }
});

class _AccountDeleteButton extends React.Component {
  constructor(props) {
    super(props);
    this.state = { isDeleting: false, errors: null };
  }

  render() {
    const { account } = this.props;
    const { errors, isDeleting } = this.state;
    return (
      <Form error={!!errors} className={css(style.container)}>
        <Header>Delete account</Header>
        <p>Existing users will be removed from the account</p>
        <Message error>{errors}</Message>
        <Button
          primary
          fluid
          onClick={() => this.deleteAccount(account.id)}
          loading={isDeleting}
        >
          Delete Account
        </Button>
      </Form>
    );
  }

  deleteAccount = id => {
    this.setState({ isDeleting: true, errors: null });
    this.props
      .deleteAccount(id)
      .then(() => {
        this.setState({ isDeleting: false });
        this.props.onDelete();
      })
      .catch((errors: Array<string>) => {
        this.setState({ isDeleting: false, errors });
      });
  };
}

const mapDispatchToProps = dispatch => ({
  deleteAccount: id => {
    // antipattern but worth it?
    return new Promise((resolve, reject) => {
      dispatch({ type: "DELETE_ACCOUNT", id, resolve, reject });
    });
  }
});

export const AccountDeleteButton = connect(undefined, mapDispatchToProps)(
  _AccountDeleteButton
);
