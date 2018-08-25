import * as React from "react";
import { Button, Message, Input } from "semantic-ui-react";
import { Mutation } from "react-apollo";
import gql from "graphql-tag";
import { css, StyleSheet } from "aphrodite";
import debounce from "lodash.debounce";

import collectGraphqlErrors from "@utils/collectGraphqlErrors";
import { IjustEventTypeahead } from "@utils/IjustEventTypeahead";

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
    margin: "30 0"
  },
  form: {
    minWidth: 300,
    maxWidth: 300
  },
  input: {
    width: "100%"
  },
  button: {
    marginLeft: "10px"
  }
});

interface Props {
  ijustContextId: string;
}

interface State {
  eventName: string;
  typeahead: any;
}

export class IjustEventInput extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    const typeahead = new IjustEventTypeahead(this.onTypeheadResult, props.ijustContextId);
    this.state = { eventName: "", typeahead };
  }

  onTypeheadResult = (results: Array<any>) => {
    console.dir(results);
  };

  render() {
    const { eventName } = this.state;
    const { ijustContextId } = this.props;
    return (
      <Mutation mutation={CREATE_EVENT}>
        {(createEvent, { loading, error }) => (
          <div className={css(styles.container)}>
            <Input
              value={eventName}
              autoFocus
              className={css(styles.input)}
              onChange={(ev, data) => this.setName(data.value)}
              action={{
                content: "Create Event",
                disabled: !eventName,
                primary: true,
                loading,
                onClick: () => {
                  createEvent({
                    variables: { eventName, ijustContextId }
                  }).then(() => this.setName(""));
                }
              }}
            />
            {error && <Message error>{collectGraphqlErrors(error)}</Message>}
          </div>
        )}
      </Mutation>
    );
  }

  setName = (eventName: string) => {
    this.setState({ eventName });
    this.state.typeahead.search(eventName);
    //this.state.observable.next(eventName);
    //this.typeahead(eventName);
    //debounce(() => { debugger; typeahead(eventName) }, 2000);
  };

  //typeahead = (event: React.SyntheticEvent<HTMLInputElement>) => {
    
  //};

  //typeahead = debounce((eventName: string) => {
    //console.log(eventName);
  //}, 500);

  //typeahead = (name: string) => {
    //debounce(() => {
      //console.log(name);
    //}, 100);
  //}
}
