import React, { useCallback } from "react";
import Button from "@mui/material/Button";
import { useMutation } from "urql";
import * as yup from "yup";
import { useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import { enqueueSnackbar } from "notistack";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";
import Alert from "@mui/material/Alert";

import { graphql } from "../../gql";
import type { IjustEvent } from "@gql-types";
import { ControlledTextField } from "./../inputs/ControlledTextField";

const UPDATE_EVENT = graphql(`
  mutation UpdateIjustEvent($id: ID!, $name: String, $cost: Int) {
    updateIjustEvent(id: $id, name: $name, cost: $cost) {
      successful
      messages {
        message
        field
      }
      result {
        id
        name
        cost {
          amount
          currency
        }
      }
    }
  }
`);

const schema = yup
  .object({
    cost: yup
      .number()
      .positive()
      .transform((_, value) => {
        return value === "" ? null : Number(value);
      })
      .nullable(),
    name: yup.string().required(),
  })
  .required();

interface Props {
  event: IjustEvent;
  visible: boolean;
  setVisible: (visible: boolean) => void;
}

export function IjustEditEventModal({ event, visible, setVisible }: Props) {
  const [_result, updateEvent] = useMutation(UPDATE_EVENT);

  const {
    clearErrors,
    control,
    formState: { isValid, errors, isSubmitting },
    handleSubmit,
    reset,
    setError,
  } = useForm({
    defaultValues: {
      cost: event.cost?.amount || ("" as any),
      name: event.name,
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const setBackendError = useCallback(
    (message: string) => {
      setError("root.serverError", { message });
    },
    [setError],
  );

  const handleClose = () => {
    reset();
    setVisible(false);
  };

  const onSubmit = useCallback(
    async (form: any) => {
      clearErrors("root.serverError");
      const { cost, name } = form;

      try {
        const { error, data } = await updateEvent({ id: event.id, cost, name });

        if (error) {
          console.error(error);
          setBackendError(error.message);
        } else if (!data?.updateIjustEvent?.successful) {
          data?.updateIjustEvent?.messages?.forEach((message) => {
            if (message?.field && message?.message) {
              setError(message.field as any, { message: message.message });
            }
            return;
          });
        } else {
          setVisible(false);
          enqueueSnackbar("Updated event", { variant: "success" });
          return;
        }
      } catch (e) {
        console.error(e);
        setBackendError("Something went wrong. Please try again.");
      }
    },
    [clearErrors, setError, updateEvent],
  );
  return (
    <Dialog
      open={visible}
      onClose={handleClose}
      aria-labelledby="edit-event-title"
    >
      <DialogTitle id="edit-event-title">Edit event</DialogTitle>
      <form onSubmit={handleSubmit(onSubmit)}>
        <DialogContent>
          {errors.root?.serverError?.message && (
            <Alert color="error">{errors.root.serverError.message}</Alert>
          )}
          <ControlledTextField
            control={control}
            name="name"
            label="Name"
            errors={errors}
            className="mt-3"
            fullWidth
          />

          <ControlledTextField
            control={control}
            name="cost"
            label="Cost"
            errors={errors}
            className="mt-3"
            fullWidth
          />
        </DialogContent>
        <DialogActions>
          <Button color="secondary" onClick={handleClose}>
            Cancel
          </Button>
          <Button type="submit" disabled={!isValid && !isSubmitting}>
            Save
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  );
}
