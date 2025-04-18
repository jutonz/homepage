import Alert from "@mui/material/Alert";
import { enqueueSnackbar } from "notistack";
import React, { useCallback } from "react";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import { useMutation } from "urql";

import { ConfirmButton } from "./ConfirmButton";
import { graphql } from "../gql";
import type { Team } from "@gql-types";

const DELETE_TEAM = graphql(`
  mutation DeleteTeam($id: ID!) {
    deleteTeam(id: $id) {
      id
    }
  }
`);

interface FormInputs {
  name: string;
  backendError: null;
}

interface Props {
  team: Team;
}

export function TeamDeleteForm({ team }: Props) {
  const navigate = useNavigate();

  const {
    clearErrors,
    formState: { errors, isSubmitting },
    handleSubmit,
    setError,
  } = useForm<FormInputs>({
    defaultValues: { backendError: null },
    mode: "onBlur",
  });

  const [_result, deleteTeam] = useMutation(DELETE_TEAM);

  const setBackendError = useCallback(
    (message: string) => {
      setError("backendError", { type: "custom", message });
    },
    [setError],
  );

  const onSubmit = useCallback(async () => {
    clearErrors("backendError");
    try {
      const { error } = await deleteTeam({ id: team.id });

      if (error) {
        console.error(error);
        setBackendError(error.message);
      } else {
        enqueueSnackbar("Deleted team.", { variant: "success" });
        navigate("/settings");
        return;
      }
    } catch (e) {
      console.error(e);
      setBackendError("Something went wrong. Please try again.");
    }
  }, [clearErrors, setError, deleteTeam]);

  return (
    <form
      className="w-80 mt-5 p-2.5 border-gray-300 border"
      onSubmit={handleSubmit(onSubmit)}
    >
      <h3 className="text-lg mb-3">Delete team</h3>

      {errors.backendError?.message && (
        <Alert color="error">{errors.backendError.message}</Alert>
      )}

      <p>Everyone else will be removed from the team.</p>

      <ConfirmButton
        className="mt-3"
        type="submit"
        fullWidth
        disabled={isSubmitting}
        onConfirm={handleSubmit(onSubmit)}
        confirmText="All existing members will be removed from the team."
        confirmButtonText="Delete team"
      >
        Delete
      </ConfirmButton>
    </form>
  );
}
