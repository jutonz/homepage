import React, { useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import { gql, useMutation } from "urql";
import Alert from "@mui/material/Alert";
import Autocomplete from "@mui/material/Autocomplete";
import TextField from "@mui/material/TextField";

import { IjustEventTypeahead } from "./../../utils/IjustEventTypeahead";
import type { IjustEvent } from "@types";

const CREATE_EVENT = gql`
  mutation CreateIjustEvent($ijustContextId: ID!, $eventName: String!) {
    createIjustEvent(ijustContextId: $ijustContextId, name: $eventName) {
      id
      name
      count
      insertedAt
      updatedAt
      ijustContextId
    }
  }
`;

interface CreateEventType {
  createIjustEvent: IjustEvent;
}

interface Props {
  ijustContextId: string;
}

export function IjustEventInput({ ijustContextId }: Props) {
  const [searchResults, setSearchResults] = useState<IjustEvent[]>([]);
  const [result, createEvent] = useMutation<CreateEventType>(CREATE_EVENT);
  const navigate = useNavigate();

  const typeahead = useMemo(() => {
    return new IjustEventTypeahead(setSearchResults, ijustContextId);
  }, [ijustContextId, setSearchResults]);

  const redirectToEvent = (eventId: string) => {
    const pathname = `/ijust/contexts/${ijustContextId}/events/${eventId}`;
    navigate(pathname);
  };

  return (
    <div className="my-5">
      <form
        onSubmit={(event) => {
          event.preventDefault();
          const eventName = typeahead.getLatestSearch();
          createEvent({ eventName, ijustContextId }).then((data) => {
            const newEventId = data?.data?.createIjustEvent?.id;
            if (newEventId) {
              redirectToEvent(newEventId);
            }
          });
        }}
      >
        <Autocomplete
          autoComplete
          options={searchResults}
          filterOptions={(x) => x}
          onInputChange={(_ev, value) => typeahead.search(value)}
          getOptionLabel={(option) => option.name}
          onChange={(_ev, value) => {
            if (value?.id) {
              return redirectToEvent(value.id)
            }
          }}
          noOptionsText="Press enter to create"
          renderInput={(params) => (
            <TextField
              {...params}
              label="Search for an event, or create a new one"
              fullWidth
            />
          )}
        />
        {result.error && <Alert color="error">{result.error}</Alert>}
      </form>
    </div>
  );
}
