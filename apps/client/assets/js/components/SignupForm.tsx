import { yupResolver } from "@hookform/resolvers/yup";
import { css, StyleSheet } from "aphrodite";
import React, { useCallback } from "react";
import { ErrorOption, SubmitHandler, useForm } from "react-hook-form";
import { useMutation } from "urql";
import { Link } from "react-router-dom";
import * as yup from "yup";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";

import { FormBox } from "./../components/FormBox";
import { graphql } from "../gql";
import { ControlledTextField } from "./inputs/ControlledTextField";

const SIGNUP_MUTATION = graphql(`
  mutation Signup($email: String!, $password: String!) {
    signup(email: $email, password: $password)
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
  backendError: ErrorOption | null;
}

const schema = yup
  .object({
    email: yup.string().email().required(),
    password: yup.string().required().min(8),
    backendError: yup.mixed().nullable(),
  })
  .required();

export function SignupForm() {
  const {
    clearErrors,
    control,
    formState: { errors, isSubmitting },
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

  const [_result, signup] = useMutation(SIGNUP_MUTATION);

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
        <h1>Signup</h1>
        {errors.backendError?.message && (
          <Alert color="error">{errors.backendError.message}</Alert>
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
