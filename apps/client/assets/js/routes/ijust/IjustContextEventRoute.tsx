import React, { useCallback, useState } from "react";
import { format, formatDistanceToNow, parseISO } from "date-fns";
import { useParams } from "react-router-dom";

import { MainNav } from "./../../components/MainNav";
import { IjustEventOccurrences } from "./../../components/ijust/IjustEventOccurrences";
import { Constants } from "./../../utils/Constants";
import { QueryLoader } from "./../../utils/QueryLoader";
import { graphql } from "../../gql";
import type { IjustEvent, IjustContext } from "@gql-types";

import Breadcrumbs from "@mui/material/Breadcrumbs";
import Button from "@mui/material/Button";
import { Link } from "react-router-dom";
import { useMutation } from "urql";
import * as yup from "yup";
import { Controller, useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";

import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";
import TextField from "@mui/material/TextField";
import Alert from "@mui/material/Alert";

const QUERY = graphql(`
  query GetEvent($contextId: ID!, $eventId: ID!) {
    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {
      id
      name
      count
      cost {
        amount
        currency
      }
      insertedAt
      updatedAt
      ijustContextId
      ijustContext {
        id
        name
      }
    }
  }
`);

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

export function IjustContextEventRoute() {
  const { contextId, eventId } = useParams();

  return (
    <div>
      <MainNav />
      <div className="m-4 max-w-3xl lg:mx-auto">
        <QueryLoader
          query={QUERY}
          variables={{ contextId, eventId }}
          component={({ data }) => {
            const event = data.getIjustContextEvent;
            const context = data.getIjustContextEvent.ijustContext;
            return <IjustEventComponent event={event} context={context} />;
          }}
        />
      </div>
    </div>
  );
}

interface IjustEventComponentProps {
  event: IjustEvent
  context: IjustContext
}

function IjustEventComponent({ event, context }: IjustEventComponentProps) {

  return (
    <div>
      <div className="flex justify-between">
        <Breadcrumbs className="text-xl" separator="→">
          <Link to="/ijust/contexts">Contexts</Link>
          <Link to={`/ijust/contexts/${context.id}`}>{context.name}</Link>;
          <h1 className="text-xl">{event.name}</h1>
        </Breadcrumbs>
      </div>
      <Header event={event} />
      <IjustEventOccurrences contextId={context.id} eventId={event.id} />
    </div>
  )
};

interface FormInputs {
  cost: number;
  name: string;
  backendError: null;
}

const schema = yup
  .object({
    cost: yup.number().positive().transform((_, value) => {
      return value === "" ? null : Number(value);
    }).nullable(),
    name: yup.string().required(),
  })
  .required();

interface HeaderProps {
  event: IjustEvent
}
function Header({ event }: HeaderProps) {
  const [editing, setEditing] = useState(false);
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
      cost: event.cost?.amount || "",
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
    setEditing(false);
  }

  const onSubmit = useCallback(
    async (form: FormInputs) => {
      clearErrors("backendError");
      const { cost } = form;

      try {
        const { error, data } = await updateEvent({ id: event.id, cost, name });
        console.log(error);
        console.log(data);
        debugger;

        if (error) {
          console.error(error);
          setBackendError(error.message);
        } else {
          reset();
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
    <>
      <Dialog
        open={editing}
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

      <Button onClick={() => setEditing(true)}>Edit</Button>

      <table className="mt-3 w-full">
        <tbody>
          <tr>
            <td className="py-3">Count</td>
            <td className="py-3">{event.count}</td>
          </tr>
          <tr>
            <td className="py-3">First occurred</td>
            <td className="py-3">
              {format(parseISO(event.insertedAt + "Z"), Constants.dateTimeFormat)}
              <span className="ml-3">
                ({formatDistanceToNow(parseISO(event.insertedAt + "Z"))} ago)
              </span>
            </td>
          </tr>
          <tr>
            <td className="py-3">Last occurred</td>
            <td className="py-3">
              {format(parseISO(event.updatedAt + "Z"), Constants.dateTimeFormat)}
              <span className="ml-3">
                ({formatDistanceToNow(parseISO(event.updatedAt + "Z"))} ago)
              </span>
            </td>
          </tr>
          <tr>
            <td>Cost</td>
            <td>{formatMoney(event.cost)}</td>
          </tr>
        </tbody>
      </table>
    </>
  );
}

interface Money {
  amount: number
  currency: string
}

function formatMoney(money?: Money) {
  if (!money) return "-";

  const formatter = new Intl.NumberFormat(
    "en-US",
    { style: "currency", currency: money.currency }
  );

  return formatter.format(money.amount);
}
