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

const CREATE_TEAM = graphql(`
  mutation CreateTeam($name: String!) {
    createTeam(name: $name) {
      id
      name
    }
  }
`);

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
  },
});

interface FormInputs {
  name: string;
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
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const [_result, createTeam] = useMutation(CREATE_TEAM);

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

      try {
        const { data, error } = await createTeam({ name });

        if (error) {
          console.error(error);
          setBackendError(error.message);
        } else {
          navigate(`/teams/${data?.createTeam?.id}`);
          return;
        }
      } catch (e) {
        console.error(e);
        setBackendError("Something went wrong. Please try again.");
      }
    },
    [clearErrors, setError, createTeam],
  );

  return (
    <form className={css(style.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h3 className="text-lg mb-3">Create a team</h3>

        {errors.root?.serverError?.message && (
          <Alert color="error">{errors.root.serverError.message}</Alert>
        )}

        <ControlledTextField
          control={control}
          name="name"
          errors={errors}
          label="Name"
          fullWidth
        />

        <Button
          type="submit"
          fullWidth
          className="mt-5"
          disabled={isSubmitting}
        >
          Create Team
        </Button>
      </FormBox>
    </form>
  );
}
