import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import { enqueueSnackbar } from "notistack";
import React, { useCallback } from "react";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import { useMutation } from "urql";

import { graphql } from "../gql";
import type { Team } from "@gql-types";

const LEAVE_TEAM = graphql(`
  mutation LeaveTeam($id: ID!) {
    leaveTeam(id: $id) {
      id
    }
  }
`);

interface FormInputs {
  backendError: null;
}

interface Props {
  team: Team;
}

export function TeamLeaveForm({ team }: Props) {
  const navigate = useNavigate();

  const {
    clearErrors,
    formState: { isValid, errors, isSubmitting },
    handleSubmit,
    setError,
  } = useForm<FormInputs>({
    defaultValues: { backendError: null },
    mode: "onBlur",
  });

  const [_result, leaveTeam] = useMutation(LEAVE_TEAM);

  const setBackendError = useCallback(
    (message: string) => {
      setError("backendError", { type: "custom", message });
    },
    [setError]
  );

  const onSubmit = useCallback(async () => {
    clearErrors("backendError");
    try {
      const { error } = await leaveTeam({ id: team.id });

      if (error) {
        console.error(error);
        setBackendError(error.message);
      } else {
        enqueueSnackbar("Left team.", { variant: "success" });
        navigate("/settings");
        return;
      }
    } catch (e) {
      console.error(e);
      setBackendError("Something went wrong. Please try again.");
    }
  }, [clearErrors, setError, leaveTeam]);

  return (
    <form
      className="w-80 mt-5 p-2.5 border-gray-300 border"
      onSubmit={handleSubmit(onSubmit)}
    >
      <h3 className="text-lg mb-3">Leave team</h3>

      {errors.backendError?.message && (
        <Alert color="error">{errors.backendError.message}</Alert>
      )}

      <p>You can always rejoin later.</p>

      <Button
        type="submit"
        className="mt-3"
        fullWidth
        disabled={isSubmitting || !isValid}
      >
        Leave
      </Button>
    </form>
  );
}
