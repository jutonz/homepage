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
}

const schema = yup
  .object({
    name: yup.string().required()
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
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const [_result, joinTeam] = useMutation(JOIN_TEAM);

  const setBackendError = useCallback(
    (message: string) => {
      setError("root.serverError", { type: "custom", message });
    },
    [setError],
  );

  const onSubmit = useCallback(
    async (form: FormInputs) => {
      clearErrors("root.serverError");
      const { name } = form;
      const { data, error } = await joinTeam({ name });

      try {
        if (error) {
          console.error(error);
          setBackendError(error.message);
        } else {
          const teamId = data?.joinTeam?.id;
          navigate(`/teams/${teamId}`);
          return;
        }
      } catch (e) {
        console.error(e);
        setBackendError("Something went wrong. Please try again.");
      }
    },
    [clearErrors, setError, joinTeam],
  );

  return (
    <form className={css(style.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h3 className="text-lg mb-3">Join a team</h3>
        <p>Become a member of an existing team</p>

        {errors.root?.serverError && (
          <Alert color="error">{errors.root.serverError.message}</Alert>
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
