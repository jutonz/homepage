import { yupResolver } from "@hookform/resolvers/yup";
import { css, StyleSheet } from "aphrodite";
import React, { useCallback } from "react";
import { ErrorOption, SubmitHandler, useForm } from "react-hook-form";
import { useClient, useMutation, useQuery } from "urql";
import { Link, useNavigate } from "react-router-dom";
import * as yup from "yup";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";

import { FormBox } from "./../components/FormBox";
import { graphql } from "../gql";
import { ControlledTextField } from "./inputs/ControlledTextField";
import { setTokens } from "js/utils/auth";

const SIGNUP_MUTATION = graphql(`
  mutation Signup($email: String!, $password: String!) {
    signup(email: $email, password: $password) {
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
      successful
    }
  }
`);

const GET_CURRENT_USER = graphql(`
  query GetCurrentUser {
    getCurrentUser {
      id
      email
    }
  }
`);

const styles = StyleSheet.create({
  container: {
    width: "300px",
    position: "absolute",
    top: "calc(50% - 150px)",
    right: "calc(50% - 150px)",
  },
});

interface FormInputs {
  email: string;
  password: string;
}

const schema = yup
  .object({
    email: yup.string().email().required(),
    password: yup.string().required().min(8),
  })
  .required();

export function SignupForm() {
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

  const [_result, signup] = useMutation(SIGNUP_MUTATION);
  const navigate = useNavigate();

  const client = useClient();

  const onSubmit: SubmitHandler<FormInputs> = async (data) => {
    const result = await signup(data);

    if (result.data?.signup?.messages) {
      const messages = result.data.signup.messages.map(
        ({ message }) => message,
      );
      if (messages.length > 0) {
        setError("root.serverError", { message: messages.join(", ") });
      }
    }

    const token = result.data?.signup?.result?.accessToken;
    const refreshToken = result.data?.signup?.result?.refreshToken;

    if (token && refreshToken) {
      setTokens(token, refreshToken);

      // bust cache by re-running check_session with network-only requestPolicy
      await client
        .query(GET_CURRENT_USER, {}, { requestPolicy: "network-only" })
        .toPromise();

      navigate("/");
    } else {
      setError("root.serverError", { message: "Something went wrong" });
    }
  };

  return (
    <form className={css(styles.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h1>Signup</h1>
        {errors.root?.serverError?.message && (
          <Alert color="error">{errors.root?.serverError.message}</Alert>
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
          Signup
        </Button>

        <Link to="/login" className="flex justify-center mt-3">
          Or login
        </Link>
      </FormBox>
    </form>
  );
}
