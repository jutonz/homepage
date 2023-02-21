import { yupResolver } from "@hookform/resolvers/yup";
import { css, StyleSheet } from "aphrodite";
import React, { useCallback } from "react";
import { Controller, SubmitHandler, useForm } from "react-hook-form";
import { gql, useMutation } from "urql";
import { Link } from "react-router-dom";
import * as yup from "yup";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";

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
        <h1>Signup</h1>
        {errors.backendError?.message && (
          <Alert color="error">{errors.backendError.message}</Alert>
        )}
        <Controller
          control={control}
          name="email"
          render={({ field }) => (
            <TextField
              {...field}
              label="Email"
              error={!!errors.email?.message}
              fullWidth
            />
          )}
        />
        {errors.email?.message && (
          <Alert color="error">{errors.email.message}</Alert>
        )}
        <Controller
          control={control}
          name="password"
          render={({ field }) => (
            <TextField
              {...field}
              className="mt-3"
              type="password"
              label="Password"
              error={!!errors.password?.message}
              fullWidth
            />
          )}
        />
        {errors.password?.message && (
          <Alert color="error">{errors.password.message}</Alert>
        )}

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
