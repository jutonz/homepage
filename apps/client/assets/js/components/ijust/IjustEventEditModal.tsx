import React, { useCallback, useState } from "react";
import Button from "@mui/material/Button";
import { useMutation } from "urql";
import * as yup from "yup";
import { Controller, useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import { enqueueSnackbar } from "notistack";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";
import TextField from "@mui/material/TextField";
import Alert from "@mui/material/Alert";

import { graphql } from "../../gql";
import type { IjustEvent } from "@gql-types";

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

interface FormInputs {
  cost: number;
  name: string;
  backendError: null;
}

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
  } = useForm<FormInputs>({
    defaultValues: {
      cost: event.cost?.amount || ("" as any),
      name: event.name,
      backendError: null,
    },
    mode: "onBlur",
    resolver: yupResolver(schema),
  });

  const setBackendError = useCallback(
    (message: string) => {
      setError("backendError", { type: "custom", message });
    },
    [setError]
  );

  const handleClose = () => {
    reset();
    setVisible(false);
  };

  const onSubmit = useCallback(
    async (form: FormInputs) => {
      clearErrors("backendError");
      const { cost, name } = form;

      try {
        const { error, data } = await updateEvent({ id: event.id, cost, name });

        if (error) {
          console.error(error);
          setBackendError(error.message);
        } else if (!data.updateIjustEvent.successful) {
          const messages = data.updateIjustEvent.messages;
          messages.forEach(({ field, message }) => {
            setError(field as any, { message });
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
    [clearErrors, setError, updateEvent]
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
          {errors.backendError?.message && (
            <Alert color="error">{errors.backendError.message}</Alert>
          )}
          <Controller
            control={control}
            name="name"
            render={({ field }) => (
              <TextField
                {...field}
                className="mt-3"
                label="Name"
                error={!!errors.name?.message}
                fullWidth
              />
            )}
          />
          {errors.name?.message && (
            <Alert color="error">{errors.name.message}</Alert>
          )}

          <Controller
            control={control}
            name="cost"
            render={({ field }) => (
              <TextField
                {...field}
                className="mt-3"
                type="number"
                label="Cost"
                error={!!errors.cost?.message}
                fullWidth
              />
            )}
          />
          {errors.cost?.message && (
            <Alert color="error">{errors.cost.message}</Alert>
          )}
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
