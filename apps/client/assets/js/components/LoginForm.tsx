import { yupResolver } from "@hookform/resolvers/yup";
import * as yup from "yup";
import { SubmitHandler, useForm } from "react-hook-form";
import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Link } from "react-router-dom";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";

import { FormBox } from "./../components/FormBox";
import { ControlledTextField } from "./inputs/ControlledTextField";
import { graphql } from "./../gql";
import { useMutation } from "urql";
import { setTokens } from "js/utils/auth";

const styles = StyleSheet.create({
  container: {
    width: "300px",
    position: "absolute",
    top: "calc(50% - 150px)",
    right: "calc(50% - 150px)",
  },
});

const LOGIN_MUTATION = graphql(`
  mutation Login($email: String!, $password: String!) {
    login(email: $email, password: $password) {
      messages {
        message
      }
      result {
        user {
          id
          email
        }
        accessToken
        refreshToken
      }
    }
  }
`);

interface FormInputs {
  email: string;
  password: string;
}

const schema = yup
  .object({
    email: yup.string().email().required(),
    password: yup.string().required(),
  })
  .required();

interface Props {
  onLogin: () => void;
}

export function LoginForm({ onLogin }: Props) {
  const {
    control,
    formState: { errors, isSubmitting },
    handleSubmit,
    setError,
  } = useForm<FormInputs>({
    defaultValues: {
      email: "",
      password: "",
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const [_result, login] = useMutation(LOGIN_MUTATION);

  const onSubmit: SubmitHandler<FormInputs> = async (data) => {
    const result = await login(data);

    if (result.data?.login?.messages) {
      const messages = result.data.login.messages.map(
        (message) => message?.message,
      );
      if (messages.length > 0) {
        setError("root.serverError", { message: messages.join(", ") });
      }
    }

    const accessToken = result?.data?.login?.result?.accessToken;
    const refreshToken = result?.data?.login?.result?.refreshToken;

    if (accessToken && refreshToken) {
      setTokens(accessToken, refreshToken);
      onLogin();
    } else {
      setError("root.serverError", { message: "Something went wrong" });
    }
  };

  return (
    <form className={css(styles.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h1>Login</h1>
        {errors.root?.serverError && (
          <Alert severity="error" className="mb-2">
            {errors.root.serverError.message}
          </Alert>
        )}
        <ControlledTextField
          control={control}
          name="email"
          label="Email"
          errors={errors}
          fullWidth
          className="mt-3"
        />

        <ControlledTextField
          control={control}
          name="password"
          label="Password"
          errors={errors}
          fullWidth
          type="password"
          className="mt-3"
        />

        <Button
          type="submit"
          fullWidth
          className="mt-5"
          disabled={isSubmitting}
        >
          Login
        </Button>

        <Link to="/signup" className="flex justify-center mt-3">
          Or signup
        </Link>
      </FormBox>
    </form>
  );
}
