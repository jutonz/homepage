import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import { css, StyleSheet } from "aphrodite";
import { enqueueSnackbar } from "notistack";
import React, { useCallback } from "react";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import { gql, useMutation } from "urql";

import { FormBox } from "./FormBox";

const DELETE_TEAM = gql`
  mutation DeleteTeam($id: ID!) {
    deleteTeam(id: $id) {
      id
    }
  }
`;

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30,
  },
});

type Team = {
  id: string;
  name: string;
};

type DeleteTeamType = {
  deleteTeam: Team;
};

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
    formState: { isValid, errors, isSubmitting },
    handleSubmit,
    setError,
  } = useForm<FormInputs>({
    defaultValues: { backendError: null },
    mode: "onBlur",
  });

  const [_result, deleteTeam] = useMutation<DeleteTeamType>(DELETE_TEAM);

  const setBackendError = useCallback(
    (message: string) => {
      setError("backendError", { type: "custom", message });
    },
    [setError]
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
    <form className={css(style.container)} onSubmit={handleSubmit(onSubmit)}>
      <FormBox>
        <h3>Delete team</h3>

        {errors.backendError?.message && (
          <Alert color="error">{errors.backendError.message}</Alert>
        )}

        <p>Everyone else will be removed from the team.</p>

        <Button type="submit" fullWidth disabled={isSubmitting || !isValid}>
          Delete
        </Button>
      </FormBox>
    </form>
  );
}
