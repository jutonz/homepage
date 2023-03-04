import { yupResolver } from "@hookform/resolvers/yup";
import * as yup from "yup";
import { Controller, SubmitHandler, useForm } from "react-hook-form";
import React, { useCallback } from "react";
import { StyleSheet, css } from "aphrodite";
import { Link } from "react-router-dom";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";

import { FormBox } from "./../components/FormBox";

const styles = StyleSheet.create({
  container: {
    width: "300px",
    position: "absolute",
    top: "calc(50% - 150px)",
    right: "calc(50% - 150px)",
  },
});

const schema = yup
  .object({
    email: yup.string().email().required(),
    password: yup.string().required(),
  })
  .required();

interface FormInputs {
  email: string;
  password: string;
  backendError: null;
}

interface Props {
  onLogin: () => void;
}

export function LoginForm({ onLogin }: Props) {
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

  const setBackendError = useCallback(
    (message: string) => {
      setError("backendError", { type: "custom", message });
    },
    [setError]
  );

  const onSubmit: SubmitHandler<FormInputs> = useCallback(
    async (_inputs, event) => {
      clearErrors("backendError");
      const opts = {
        method: "POST",
        credentials: "same-origin" as const,
        body: new FormData(event.target),
      };

      try {
        const res = await fetch("/api/login", opts);
        if (res.ok) {
          onLogin();
        } else {
          const json = await res.json();
          if (json.error && json.messages?.length > 0) {
            setBackendError(json.messages.join(", "));
          }
        }
      } catch (e) {
        console.error(e);
        setBackendError("Something went wrong, please try again");
      }
    },
    [clearErrors, setError]
  );
  return (
    <form className={css(styles.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h1>Login</h1>
        {errors.backendError?.message && (
          <Alert severity="error" className="mb-2">
            {errors.backendError.message}
          </Alert>
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
          <Alert severity="error">{errors.email.message}</Alert>
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
          <Alert severity="error">{errors.password.message}</Alert>
        )}

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
