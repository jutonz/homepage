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

const JOIN_TEAM = gql`
  mutation JoinTeam($name: String!) {
    joinTeam(name: $name) {
      id
      name
    }
  }
`;

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30,
    display: "flex",
    flexDirection: "column",
    flexGrow: 1,
  },
});

type Team = {
  id: string;
  name: string;
};

type JoinTeamType = {
  joinTeam: Team;
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

export function TeamJoinForm() {
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

  const [_result, joinTeam] = useMutation<JoinTeamType>(JOIN_TEAM);

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
      const { data, error } = await joinTeam({ name });

      try {
        if (error) {
          console.error(error);
          setBackendError(error.message);
        } else {
          const team = data.joinTeam;
          navigate(`/teams/${team.id}`);
          return;
        }
      } catch (e) {
        console.error(e);
        setBackendError("Something went wrong. Please try again.");
      }
    },
    [clearErrors, setError, joinTeam]
  );

  return (
    <form className={css(style.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h3>Join a team</h3>
        <p>Become a member of an existing team</p>

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
          Join Team
        </Button>
      </FormBox>
    </form>
  );
}
