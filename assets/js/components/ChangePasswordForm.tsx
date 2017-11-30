import * as React from 'react';
import { StyleSheet, css } from 'aphrodite';
import { Button, Header, Form, InputOnChangeData, Message } from 'semantic-ui-react';
import { ApolloClient } from 'apollo-client';
import { HttpLink } from 'apollo-link-http';
import { InMemoryCache } from 'apollo-cache-inmemory';
import gql from 'graphql-tag';

const styles = StyleSheet.create({
  container: {
    marginTop: 30,
    maxWidth: 300
  },

  submit: {
    marginTop: 30
  }
});

const client = new ApolloClient({
  // By default, this client will send queries to the
  //  `/graphql` endpoint on the same host
  link: new HttpLink({
    uri: `${window.location.origin}/graphql`,
    credentials: 'same-origin'
  }),
  cache: new InMemoryCache()
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

export default class ChangePasswordForm extends React.Component<Props, State> {
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

          {this.state.formState === FormState.Success &&
            <Message success header="Success" content="Password updated" />}

          {this.state.formState === FormState.Error &&
            <Message error header="Error" content={this.state.errorMessage} />}

          <Form.Field>
            <Form.Input
              name="current_password"
              label="Current password"
              type="password"
              autoFocus={true}
              onChange={this.oldPasswordChanged} />
          </Form.Field>

          <Form.Field>
            <Form.Input
              label="New password"
              type="password"
              name="new_password"
              error={this.state.confirmBad}
              onChange={this.newPasswordChanged} />
          </Form.Field>

          <Form.Field>
            <Form.Input
              type="password"
              label="Confirm new password"
              name="new_password_confirm"
              error={this.state.confirmBad}
              onChange={this.newPasswordConfirmChanged} />
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

  private oldPasswordChanged = (_event: React.SyntheticEvent<HTMLInputElement>, data: InputOnChangeData) => {
    let oldPassword = data.value;
    this.setState({ oldPassword: oldPassword });
  }

  private newPasswordChanged = (_event: React.SyntheticEvent<HTMLInputElement>, data: InputOnChangeData) => {
    let newPassword = data.value;
    this.setState({ newPassword: newPassword });
    this.comparePasswords(newPassword, this.state.newPasswordConfirm);
  }

  private newPasswordConfirmChanged = (_event: React.SyntheticEvent<HTMLInputElement>, data: InputOnChangeData) => {
    let newPasswordConfirm = data.value;
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
    client.mutate({ mutation: mutation }).then((_response: Response) => {
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
