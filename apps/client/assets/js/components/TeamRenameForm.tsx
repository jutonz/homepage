import { yupResolver } from "@hookform/resolvers/yup";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import { css, StyleSheet } from "aphrodite";
import React, { useCallback } from "react";
import { Controller, useForm } from "react-hook-form";
import { gql, useMutation } from "urql";
import * as yup from "yup";
import { enqueueSnackbar } from "notistack";

import { FormBox } from "./FormBox";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30,
    marginBottom: 0,
  },
});

const RENAME_TEAM = gql`
  mutation RenameTeam($id: ID!, $name: String!) {
    renameTeam(id: $id, name: $name) {
      id
      name
    }
  }
`;

type Team = {
  id: string;
  name: string;
};

type RenameTeamType = {
  renameTeam: Team;
};

interface FormInputs {
  name: string;
  backendError: null;
}

const schema = yup
  .object({
    name: yup.string().required(),
  })
  .required();

interface Props {
  team: Team;
}

export function TeamRenameForm({ team }: Props) {
  const {
    clearErrors,
    control,
    formState: { isValid, errors, isSubmitting },
    handleSubmit,
    reset,
    setError,
  } = useForm<FormInputs>({
    defaultValues: {
      name: "",
      backendError: null,
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const [_result, renameTeam] = useMutation<RenameTeamType>(RENAME_TEAM);

  const setBackendError = useCallback(
    (message: string) => {
      setError("backendError", { type: "custom", message });
    },
    [setError]
  );

  const onSubmit = useCallback(
    async (form: FormInputs) => {
      clearErrors("backendError");
      const { name } = form;

      try {
        const { error } = await renameTeam({ id: team.id, name });

        if (error) {
          console.error(error);
          setBackendError(error.message);
        } else {
          reset();
          enqueueSnackbar("Team renamed.", { variant: "success" });
          return;
        }
      } catch (e) {
        console.error(e);
        setBackendError("Something went wrong. Please try again.");
      }
    },
    [clearErrors, setError, renameTeam]
  );

  return (
    <form className={css(style.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h3>Rename team</h3>

        {errors.backendError?.message && (
          <Alert color="error">{errors.backendError.message}</Alert>
        )}

        <Controller
          control={control}
          name="name"
          render={({ field }) => (
            <TextField
              {...field}
              label="New name"
              error={!!errors.name?.message}
              fullWidth
            />
          )}
        />
        {errors.name?.message && (
          <Alert color="error">{errors.name.message}</Alert>
        )}

        <Button
          type="submit"
          fullWidth
          className="mt-5"
          disabled={isSubmitting || !isValid}
        >
          Rename team
        </Button>
      </FormBox>
    </form>
  );
}
