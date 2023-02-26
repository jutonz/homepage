import { yupResolver } from "@hookform/resolvers/yup";
import { css, StyleSheet } from "aphrodite";
import React, { useCallback } from "react";
import { Controller, SubmitHandler, useForm } from "react-hook-form";
import { Button, Header, Input, Message } from "semantic-ui-react";
import { gql, useMutation } from "urql";
import { Link } from "react-router-dom";
import * as yup from "yup";

import { FormBox } from "./../components/FormBox";

const SIGNUP_MUTATION = gql`
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

type SignupDataType = {
  signup: string;
};

interface FormInputs {
  email: string;
  password: string;
  backendError: null;
}

const schema = yup
  .object({
    email: yup.string().email().required(),
    password: yup.string().required().min(8),
  })
  .required();

export function SignupForm() {
  const {
    clearErrors,
    control,
    formState: { errors },
    handleSubmit,
    setError,
  } = useForm<FormInputs>({
    defaultValues: {
      email: "",
      password: "",
      backendError: null,
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const [_result, signup] = useMutation<SignupDataType>(SIGNUP_MUTATION);

  const onSubmit: SubmitHandler<FormInputs> = useCallback(
    async (form: FormInputs) => {
      clearErrors("backendError");
      const { email, password } = form;
      const { data, error } = await signup({ email, password });

      try {
        if (error) {
          console.error(error);
          setError("backendError", { type: "custom", message: error.message });
        } else {
          const redirectUrl = data.signup;
          (window as any).location = redirectUrl;
        }
      } catch (e) {
        console.error(e);
        setError("backendError", {
          type: "custom",
          message: "Something went wrong, please try again",
        });
      }
    },
    [clearErrors, setError, signup]
  );

  return (
    <form className={css(styles.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <Header className={css(styles.header)}>Signup</Header>
        {errors.backendError?.message && (
          <Message error>{errors.backendError.message}</Message>
        )}
        <Controller
          control={control}
          name="email"
          render={({ field }) => (
            <Input
              {...field}
              fluid
              label="Email"
              error={!!errors.email?.message}
            />
          )}
        />
        {errors.email?.message && (
          <Message error>{errors.email.message}</Message>
        )}
        <Controller
          control={control}
          name="password"
          render={({ field }) => (
            <Input
              {...field}
              input={{ type: "password" }}
              label="Password"
              fluid
              error={!!errors.password?.message}
              className={css(styles.inputLast)}
            />
          )}
        />
        {errors.password?.message && (
          <Message error>{errors.password.message}</Message>
        )}
        <Button
          primary
          fluid
          disabled={false}
          loading={false}
          className={css(styles.submit)}
        >
          Signup
        </Button>

        <Link to="/login" className="flex justify-center mt-3">
          Or login
        </Link>
      </FormBox>
    </form>
  );
}
