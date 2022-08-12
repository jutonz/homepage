import React, { useMemo, useState } from "react";
import { Message, Form, Search, SearchResultProps } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";
import { Redirect } from "react-router-dom";
import { gql, useMutation } from "urql";

import { IjustEventTypeahead } from "./../../utils/IjustEventTypeahead";

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

const styles = StyleSheet.create({
  container: {
    margin: "30 0",
  },
  form: {
    minWidth: 300,
    maxWidth: 300,
  },
  input: {
    width: "100%",
  },
  button: {
    marginLeft: "10px",
  },
  searchResultTitle: {
    fontFace: "bold",
  },
  searchResultDescription: {
    color: "#ccc",
  },
  searchResultContainer: {
    display: "flex",
    justifyContent: "space-between",
  },
  searchResultRight: {
    alignItems: "center",
  },
});

interface Props {
  ijustContextId: string;
}

export function IjustEventInput({ ijustContextId }: Props) {
  const [selectedEventId, setSelectedEventId] = useState<string | null>(null);
  const [searchResults, setSearchResults] = useState<any>([]);
  const [result, createEvent] = useMutation(CREATE_EVENT);

  const typeahead = useMemo(() => {
    return new IjustEventTypeahead((rawResults: Array<any>) => {
      const transformed = rawResults.map(({ id, name, count }) => ({
        id,
        title: name,
        description: `${count} existing occurrence${count !== 1 ? "s" : ""}`,
      }));
      setSearchResults(transformed);
    }, ijustContextId);
  }, [ijustContextId, setSearchResults]);

  if (selectedEventId) {
    const pathname = `/ijust/contexts/${ijustContextId}/events/${selectedEventId}`;
    return <Redirect to={{ pathname }} />;
  }

  const renderNoResultsMessage = () => {
    if (searchResults) {
      return (
        <div>
          <div className={css(styles.searchResultTitle)}>
            Press enter to create new event
          </div>
        </div>
      );
    } else {
      return <div>Loading</div>;
    }
  };

  return (
    <div className={css(styles.container)}>
      <Form
        onSubmit={() => {
          const eventName = typeahead.getLatestSearch();
          createEvent({ eventName, ijustContextId }).then((data: any) => {
            const newEventId = data.data.createIjustEvent.id;
            setSelectedEventId(newEventId);
          });
        }}
      >
        <Search
          fluid
          selectFirstResult
          onSearchChange={(_ev, { value }) => typeahead.search(value)}
          onResultSelect={(_ev, data) => setSelectedEventId(data.result.id)}
          results={searchResults}
          resultRenderer={renderSearchResults}
          noResultsMessage={renderNoResultsMessage()}
        />
        {result.error && <Message error>{result.error}</Message>}
      </Form>
    </div>
  );
}

const renderSearchResults = (
  props: SearchResultProps
): React.ReactElement<any> => (
  <div key={props.id} className={css(styles.searchResultContainer)}>
    <div>
      <div className={css(styles.searchResultTitle)}>{props.title}</div>
      <div className={css(styles.searchResultDescription)}>
        {props.description}
      </div>
    </div>
    <div className={css(styles.searchResultRight)}>
      {props.active && <div>Enter to view</div>}
    </div>
  </div>
);
