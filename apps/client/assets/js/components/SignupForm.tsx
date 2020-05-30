import * as React from "react";
import { Button, Header, Input, Message } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { Mutation } from "react-apollo";
import gql from "graphql-tag";

import { FormBox } from "@components/FormBox";
import IsValidEmail from "@utils/isValidEmail";
import IsValidPassword from "@utils/isValidPassword";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

const SIGNUP = gql`
  mutation Signup($email: String!, $password: String!) {
    signup(email: $email, password: $password)
  }
`;

const styles = StyleSheet.create({
  container: {
    width: "300px",
    position: "absolute",
    top: "calc(50% - 150px)",
    right: "calc(50% - 150px)",
  },

  header: {
    marginBottom: 30,
  },

  inputLast: {
    marginTop: "20px",
  },

  submit: {
    marginTop: 30,
  },
});

interface State {
  email: String;
  password: String;
  emailIsValid: boolean;
  passwordIsValid: boolean;
  formIsValid: boolean;
}
interface Props {}

export class SignupForm extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      email: "",
      password: "",
      emailIsValid: false,
      passwordIsValid: false,
      formIsValid: false,
    };
  }

  render() {
    const { email, password, formIsValid } = this.state;

    return (
      <div className={css(styles.container)}>
        <Mutation mutation={SIGNUP}>
          {(signup, result) => (
            <FormBox>
              <Header className={css(styles.header)}>Signup</Header>
              {result.error && (
                <Message error>{collectGraphqlErrors(result.error)}</Message>
              )}
              <Input
                fluid
                label="email"
                value={email}
                onChange={(_ev, { value }) => this.setEmail(value)}
              />
              <Input
                fluid
                label="password"
                input={{ type: "password" }}
                value={password}
                onChange={(_ev, { value }) => this.setPassword(value)}
                className={css(styles.inputLast)}
              />
              <Button
                primary
                fluid
                disabled={!formIsValid}
                loading={result.loading}
                className={css(styles.submit)}
                onClick={() => {
                  signup({
                    variables: { email, password },
                  }).then((response: any) => {
                    const redirectLink = response.data.signup;
                    window.location.href = redirectLink;
                  });
                }}
              >
                Signup
              </Button>
            </FormBox>
          )}
        </Mutation>
      </div>
    );
  }

  setEmail(email: String) {
    const emailIsValid = IsValidEmail(email);
    const { passwordIsValid } = this.state;
    const formIsValid = emailIsValid && passwordIsValid;
    this.setState({ email, emailIsValid, formIsValid });
  }

  setPassword(password: String) {
    const passwordIsValid = IsValidPassword(password);
    const { emailIsValid } = this.state;
    const formIsValid = emailIsValid && passwordIsValid;
    this.setState({ password, passwordIsValid, formIsValid });
  }
}
