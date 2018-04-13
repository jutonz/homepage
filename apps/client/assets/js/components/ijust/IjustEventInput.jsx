import { Button, Input } from "semantic-ui-react";
import { connect } from "react-redux";
import React from "react";

const _IjustEventInput = ({
  context,
  name,
  setName,
  createEvent,
  isCreating,
  createErrors
}) => (
  <div>
    <Input value={name} onChange={(_ev, data) => setName(data.value)} />
    {createErrors}
    <Button
      primary
      onClick={() => createEvent(context.id, name)}
      loading={isCreating}
    >
      Create
    </Button>
  </div>
);

export const IjustEventInput = connect(
  state => ({
    name: state.ijust.get("newEventName") || "",
    isCreating: state.ijust.get("creatingEvent"),
    createErrors: state.ijust.get("createErrors")
  }),
  dispatch => ({
    setName: name => dispatch({ type: "SET_IJUST_NEW_EVENT_NAME", name }),
    createEvent: (contextId, name) =>
      dispatch({ type: "IJUST_CREATE_EVENT", contextId, name })
  })
)(_IjustEventInput);
