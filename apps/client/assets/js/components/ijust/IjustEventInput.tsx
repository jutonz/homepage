import * as React from "react";
import { Message, Form, Search, SearchResultProps } from "semantic-ui-react";
import { Mutation } from "react-apollo";
import gql from "graphql-tag";
import { css, StyleSheet } from "aphrodite";
import { Route, Redirect } from "react-router-dom";

import collectGraphqlErrors from "./../../utils/collectGraphqlErrors";
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

interface State {
  eventName: string;
  typeahead: any;
  searchResults?: Array<any>;
  selectedEventId?: string;
}

export class IjustEventInput extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    const typeahead = new IjustEventTypeahead(
      this.onTypeheadResult,
      props.ijustContextId
    );
    this.state = { eventName: "", typeahead };
  }

  onTypeheadResult = (rawResults: Array<any>) => {
    const transformed = rawResults.map((raw) => {
      return {
        id: raw.id,
        title: raw.name,
        description: `${raw.count} existing occurrence${
          raw.count !== 1 ? "s" : ""
        }`,
      };
    });
    console.dir(transformed);
    this.setState({ searchResults: transformed });
  };

  renderSearchResults = (props: SearchResultProps): React.ReactElement<any> => {
    const rendered = (
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

    return rendered;
  };

  renderNoResultsMessage = () => {
    if (this.state.searchResults) {
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

  render() {
    const { selectedEventId } = this.state;
    const { ijustContextId } = this.props;

    if (selectedEventId) {
      const to = {
        pathname: `/ijust/contexts/${ijustContextId}/events/${selectedEventId}`
      };
      return <Route render={() => <Redirect to={to} />} />;
    }

    return (
      <Mutation mutation={CREATE_EVENT}>
        {(createEvent, result) => (
          <div className={css(styles.container)}>
            <Form
              onSubmit={() => {
                const { ijustContextId } = this.props;
                const eventName = this.state.typeahead.getLatestSearch();
                createEvent({
                  variables: { eventName, ijustContextId },
                }).then((data: any) => {
                  const newEventId = data.data.createIjustEvent.id;
                  this.setState({ selectedEventId: newEventId });
                });
              }}
            >
              <Search
                fluid
                selectFirstResult
                onSearchChange={(_ev, { value }) =>
                  this.state.typeahead.search(value)
                }
                onResultSelect={(_ev, data) => {
                  const selectedEventId = data.result.id;
                  this.setState({ selectedEventId });
                }}
                results={this.state.searchResults}
                resultRenderer={this.renderSearchResults}
                noResultsMessage={this.renderNoResultsMessage()}
              />
              {result.error && (
                <Message error>{collectGraphqlErrors(result.error)}</Message>
              )}
            </Form>
          </div>
        )}
      </Mutation>
    );
  }

  setName = (eventName: string) => {
    this.setState({ eventName });
    this.state.typeahead.search(eventName);
  };
}
