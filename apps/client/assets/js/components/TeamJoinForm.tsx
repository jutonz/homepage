import { yupResolver } from "@hookform/resolvers/yup";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import { css, StyleSheet } from "aphrodite";
import React, { useCallback } from "react";
import { useForm, ErrorOption } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import { useMutation } from "urql";
import * as yup from "yup";

import { FormBox } from "./FormBox";
import { graphql } from "../gql";
import { ControlledTextField } from "./inputs/ControlledTextField";

const JOIN_TEAM = graphql(`
  mutation JoinTeam($name: String!) {
    joinTeam(name: $name) {
      id
      name
    }
  }
`);

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30,
    display: "flex",
    flexDirection: "column",
    flexGrow: 1,
  },
});

interface FormInputs {
  name: string;
  backendError: ErrorOption | null;
}

const schema = yup
  .object({
    name: yup.string().required(),
    backendError: yup.mixed(),
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

  const [_result, joinTeam] = useMutation(JOIN_TEAM);

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
        <h3 className="text-lg mb-3">Join a team</h3>
        <p>Become a member of an existing team</p>

        {errors.backendError?.message && (
          <Alert color="error">{errors.backendError.message}</Alert>
        )}

        <ControlledTextField
          control={control}
          name="name"
          label="Name"
          errors={errors}
          fullWidth
        />

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
