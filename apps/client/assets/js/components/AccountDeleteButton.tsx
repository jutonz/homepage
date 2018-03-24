import * as React from "react";
import { Button, Header, Form, Message } from "semantic-ui-react";
import { connect, Dispatch } from "react-redux";
import { StyleSheet, css } from "aphrodite";
import { Account } from "./../Store";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30
  }
});

interface Props {
  account: Account;
  deleteAccount?(id: string): Promise<any>;
  onDelete(): void;
}

interface State {
  isDeleting: boolean;
  errors: Array<string>;
}

class _AccountDeleteButton extends React.Component<Props, State> {
  public constructor(props: Props) {
    super(props);
    this.state = { isDeleting: false, errors: null };
  }

  public render() {
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

  private deleteAccount = (id: string) => {
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

const mapDispatchToProps = (dispatch: Dispatch<{}>): Partial<Props> => ({
  deleteAccount: (id: string) => {
    // antipattern but worth it?
    return new Promise((resolve, reject) => {
      dispatch({ type: "DELETE_ACCOUNT", id, resolve, reject });
    });
  }
});

export const AccountDeleteButton = connect<{}, {}, Props>(
  undefined,
  mapDispatchToProps
)(_AccountDeleteButton);
