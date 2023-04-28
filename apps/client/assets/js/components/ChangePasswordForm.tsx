import { yupResolver } from "@hookform/resolvers/yup";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import { enqueueSnackbar } from "notistack";
import React, { useCallback } from "react";
import { Controller, useForm } from "react-hook-form";
import { useMutation } from "urql";
import * as yup from "yup";

import { FormBox } from "./FormBox";
import { graphql } from "../gql";

const CHANGE_PASSWORD = graphql(`
  mutation ChangePassword($currentPassword: String!, $newPassword: String!) {
    changePassword(
      currentPassword: $currentPassword
      newPassword: $newPassword
    ) {
      id
    }
  }
`);

interface FormInputs {
  currentPassword: string;
  newPassword: string;
  newPasswordConfirm: string;
  backendError: null;
}

const schema = yup
  .object({
    currentPassword: yup.string().required(),
    newPassword: yup.string().required(),
    newPasswordConfirm: yup
      .string()
      .required()
      .oneOf([yup.ref("newPassword")], "Passwords don't match"),
  })
  .required();

export function ChangePasswordForm() {
  const {
    clearErrors,
    control,
    formState: { isValid, errors, isSubmitting },
    handleSubmit,
    reset,
    setError,
  } = useForm<FormInputs>({
    defaultValues: {
      currentPassword: "",
      newPassword: "",
      newPasswordConfirm: "",
      backendError: null,
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const [_result, changePassword] = useMutation(CHANGE_PASSWORD);

  const setBackendError = useCallback(
    (message: string) => {
      setError("backendError", { type: "custom", message });
    },
    [setError]
  );

  const onSubmit = useCallback(
    async (form: FormInputs) => {
      clearErrors("backendError");
      const { currentPassword, newPassword } = form;

      try {
        const { error } = await changePassword({
          currentPassword,
          newPassword,
        });

        if (error) {
          console.error(error);
          setBackendError(error.message);
        } else {
          reset();
          enqueueSnackbar("Password changed.", { variant: "success" });
          return;
        }
      } catch (e) {
        console.error(e);
        setBackendError("Something went wrong. Please try again.");
      }
    },
    [clearErrors, setError, changePassword]
  );

  return (
    <form className="w-80 mt-3" onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h3 className="text-lg mb-3">Change password</h3>

        {errors.backendError?.message && (
          <Alert color="error">{errors.backendError.message}</Alert>
        )}

        <Controller
          control={control}
          name="currentPassword"
          render={({ field }) => (
            <TextField
              {...field}
              type="password"
              label="Current password"
              error={!!errors.currentPassword?.message}
              fullWidth
            />
          )}
        />
        {errors.currentPassword?.message && (
          <Alert color="error">{errors.currentPassword.message}</Alert>
        )}

        <Controller
          control={control}
          name="newPassword"
          render={({ field }) => (
            <TextField
              {...field}
              className="mt-3"
              label="New password"
              error={!!errors.newPassword?.message}
              fullWidth
            />
          )}
        />
        {errors.newPassword?.message && (
          <Alert color="error">{errors.newPassword.message}</Alert>
        )}

        <Controller
          control={control}
          name="newPasswordConfirm"
          render={({ field }) => (
            <TextField
              {...field}
              className="mt-3"
              label="New password (confirm)"
              error={!!errors.newPasswordConfirm?.message}
              fullWidth
            />
          )}
        />
        {errors.newPasswordConfirm?.message && (
          <Alert color="error">{errors.newPasswordConfirm.message}</Alert>
        )}

        <Button
          type="submit"
          fullWidth
          className="mt-5"
          disabled={isSubmitting || !isValid}
        >
          Change password
        </Button>
      </FormBox>
    </form>
  );
}
