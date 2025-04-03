import { yupResolver } from "@hookform/resolvers/yup";
import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import { enqueueSnackbar } from "notistack";
import React, { useCallback } from "react";
import { useForm, ErrorOption } from "react-hook-form";
import { useMutation } from "urql";
import * as yup from "yup";

import { FormBox } from "./FormBox";
import { graphql } from "../gql";
import type { Team } from "@gql-types";
import { ControlledTextField } from "./inputs/ControlledTextField";

const RENAME_TEAM = graphql(`
  mutation RenameTeam($id: ID!, $name: String!) {
    renameTeam(id: $id, name: $name) {
      id
      name
    }
  }
`);

const schema = yup
  .object({
    name: yup.string().required(),
    backendError: yup.mixed().nullable(),
  })
  .required();

interface Props {
  team: Team;
}

export function TeamRenameForm({ team }: Props) {
  const {
    clearErrors,
    control,
    formState: { errors, isSubmitting },
    handleSubmit,
    reset,
    setError,
  } = useForm({
    defaultValues: {
      name: "",
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const [_result, renameTeam] = useMutation(RENAME_TEAM);

  const setBackendError = useCallback(
    (message: string) => {
      setError("root.serverError", { message });
    },
    [setError],
  );

  const onSubmit = useCallback(
    async (form: any) => {
      clearErrors("root.serverError");
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
    [clearErrors, setError, renameTeam],
  );

  return (
    <form className="w-80 mt-3" onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h3 className="text-lg mb-3">Rename team</h3>

        {errors.root?.serverError && (
          <Alert severity="error" className="mb-2">
            {errors.root.serverError.message}
          </Alert>
        )}

        <ControlledTextField
          control={control}
          name="name"
          label="New name"
          errors={errors}
          fullWidth
        />

        <Button
          type="submit"
          fullWidth
          className="mt-5"
          disabled={isSubmitting}
        >
          Rename team
        </Button>
      </FormBox>
    </form>
  );
}
