import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import { css, StyleSheet } from "aphrodite";
import { enqueueSnackbar } from "notistack";
import React, { useCallback } from "react";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import { gql, useMutation } from "urql";

import { FormBox } from "./FormBox";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30,
  },
});

const LEAVE_TEAM = gql`
  mutation LeaveTeam($id: ID!) {
    leaveTeam(id: $id) {
      id
    }
  }
`;

type Team = {
  id: string;
  name: string;
};

type LeaveTeamType = {
  leaveTeam: Team;
};

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

  const [_result, leaveTeam] = useMutation<LeaveTeamType>(LEAVE_TEAM);

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
    <form className={css(style.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h3>Leave team</h3>

        {errors.backendError?.message && (
          <Alert color="error">{errors.backendError.message}</Alert>
        )}

        <p>You can always rejoin later.</p>

        <Button type="submit" fullWidth disabled={isSubmitting || !isValid}>
          Leave
        </Button>
      </FormBox>
    </form>
  );
}
