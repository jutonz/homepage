import * as React from 'react';
import { ReactNode } from 'react';
import { StyleSheet, css } from 'aphrodite';
import gql from 'graphql-tag';
import {
  Button,
  Header,
  Form,
  InputOnChangeData,
  Message
} from 'semantic-ui-react';

const styles = StyleSheet.create({
  container: {
    marginTop: 30,
    maxWidth: 300
  },

  submit: {
    marginTop: 30
  }
});

interface Props {
}

enum FormState {
  Success = 'success',
  Error = 'error',
  Warning = 'warning',
  Pending = 'pending'
}

interface State {
  loading: boolean;
  oldPassword: string;
  newPassword: string;
  newPasswordConfirm: string;
  formState: FormState;
  errorMessage?: string;
  confirmBad?: boolean;
}

interface GraphqlError {
  message: string;
  name: string;
}

export class _ChangePasswordForm extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);

    this.state = {
      loading: false,
      oldPassword: '',
      newPassword: '',
      newPasswordConfirm: '',
      formState: FormState.Pending
    };
  }

  render() {
    return (
      <div className={css(styles.container)}>
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
      </div>
    );
  }

  private renderStatusMessage = (): ReactNode | null => {
    switch (this.state.formState) {
      case FormState.Success:
        return (
          <Message
            success={true}
            header="Success"
            content="Password updated"
          />
        );
      case FormState.Error:
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
  }

  private oldPasswordChanged = (
    _event: React.SyntheticEvent<HTMLInputElement>,
    data: InputOnChangeData
  ) => {
    const oldPassword = data.value;
    this.setState({ oldPassword: oldPassword });
  }

  private newPasswordChanged = (
    _event: React.SyntheticEvent<HTMLInputElement>,
    data: InputOnChangeData
  ) => {
    const newPassword = data.value;
    this.setState({ newPassword: newPassword });
    this.comparePasswords(newPassword, this.state.newPasswordConfirm);
  }

  private newPasswordConfirmChanged = (
    _event: React.SyntheticEvent<HTMLInputElement>,
    data: InputOnChangeData
  ) => {
    const newPasswordConfirm = data.value;
    this.setState({ newPasswordConfirm: newPasswordConfirm });
    this.comparePasswords(this.state.newPassword, newPasswordConfirm);
  }

  private comparePasswords(newPassword: string, newPasswordConfirm: string) {
    if (newPasswordConfirm === '' || newPassword === '') {
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

  private submit = (event: React.FormEvent<HTMLElement>) => {
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

    window.grapqlClient.mutate({
      mutation: mutation
    }).then((_response: Response) => {
      this.setState({ loading: false });
      this.onPasswordChangeSuccess();
    }).catch((error: GraphqlError) => {
      this.setState({
        loading: false,
        formState: FormState.Error,
        errorMessage: error.message || "Failed to update password"
      });
    });
  }

  private onPasswordChangeSuccess = ()  => {
    this.setState({
      oldPassword: '',
      newPassword: '',
      newPasswordConfirm: '',
      formState: FormState.Success
   });
  }
}

export const ChangePasswordForm = _ChangePasswordForm;
