import { yupResolver } from "@hookform/resolvers/yup";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import { css, StyleSheet } from "aphrodite";
import React, { useCallback } from "react";
import { Controller, useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import { gql, useMutation } from "urql";
import * as yup from "yup";

import { FormBox } from "./FormBox";

const CREATE_TEAM = gql`
  mutation CreateTeam($name: String!) {
    createTeam(name: $name) {
      id
      name
    }
  }
`;

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
  },
});

type Team = {
  id: string;
  name: string;
};

type CreateTeamType = {
  createTeam: Team;
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

export function TeamCreationForm() {
  const navigate = useNavigate();

  const {
    clearErrors,
    control,
    formState: { isValid, errors, isSubmitting },
    handleSubmit,
    setError,
  } = useForm<FormInputs>({
    defaultValues: {
      name: "",
      backendError: null,
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const [_result, createTeam] = useMutation<CreateTeamType>(CREATE_TEAM);

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
        const { data, error } = await createTeam({ name });

        if (error) {
          console.error(error);
          setBackendError(error.message);
        } else {
          const team = data.createTeam;
          navigate(`/teams/${team.id}`);
          return;
        }
      } catch (e) {
        console.error(e);
        setBackendError("Something went wrong. Please try again.");
      }
    },
    [clearErrors, setError, createTeam]
  );

  return (
    <form className={css(style.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h3>Create a team</h3>

        {errors.backendError?.message && (
          <Alert color="error">{errors.backendError.message}</Alert>
        )}

        <Controller
          control={control}
          name="name"
          render={({ field }) => (
            <TextField
              {...field}
              label="Name"
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
          Create Team
        </Button>
      </FormBox>
    </form>
  );
}
