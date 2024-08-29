import { yupResolver } from "@hookform/resolvers/yup";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import { enqueueSnackbar } from "notistack";
import React, { useCallback } from "react";
import { useForm } from "react-hook-form";
import { useMutation } from "urql";
import * as yup from "yup";

import { FormBox } from "./FormBox";
import { graphql } from "../gql";
import { ControlledTextField } from "./inputs/ControlledTextField";

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
    formState: { errors, isSubmitting },
    handleSubmit,
    reset,
    setError,
  } = useForm<FormInputs>({
    defaultValues: {
      currentPassword: "",
      newPassword: "",
      newPasswordConfirm: "",
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const [_result, changePassword] = useMutation(CHANGE_PASSWORD);

  const setBackendError = useCallback(
    (message: string) => {
      setError("root.serverError", { message });
    },
    [setError],
  );

  const onSubmit = useCallback(
    async (form: FormInputs) => {
      clearErrors("root.serverError");
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
    [clearErrors, setError, changePassword],
  );

  return (
    <form className="w-80 mt-3" onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h3 className="text-lg mb-3">Change password</h3>

        {errors.root?.serverError?.message && (
          <Alert color="error">{errors.root.serverError.message}</Alert>
        )}

        <ControlledTextField
          control={control}
          name="currentPassword"
          label="Current password"
          errors={errors}
          fullWidth
        />

        <ControlledTextField
          control={control}
          name="newPassword"
          label="New password"
          errors={errors}
          className="mt-3"
          fullWidth
        />

        <ControlledTextField
          control={control}
          name="newPasswordConfirm"
          label="New password (confirm)"
          errors={errors}
          className="mt-3"
          fullWidth
        />

        <Button
          type="submit"
          fullWidth
          className="mt-5"
          disabled={isSubmitting}
        >
          Change password
        </Button>
      </FormBox>
    </form>
  );
}
