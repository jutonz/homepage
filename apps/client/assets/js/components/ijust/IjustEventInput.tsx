import * as React from "react";
import { Form, Header, Message } from "semantic-ui-react";
import { Mutation } from "react-apollo";
import gql from "graphql-tag";
import { css, StyleSheet } from "aphrodite";

import collectGraphqlErrors from "@utils/collectGraphqlErrors";

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
  }
});

interface Props {
  ijustContextId: string;
}

interface State {
  eventName: string;
}

export class IjustEventInput extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { eventName: "" };
  }

  render() {
    const { eventName } = this.state;
    const { ijustContextId } = this.props;
    return (
      <Mutation mutation={CREATE_EVENT}>
        {(createEvent, { loading, error }) => (
          <div className={css(styles.container)}>
            <Form
              onSubmit={() => {
                createEvent({
                  variables: { eventName, ijustContextId }
                }).then(() => this.setName(""));
              }}
              className={css(styles.form)}
            >
              <Header>Create event</Header>
              <Message error>{collectGraphqlErrors(error)}</Message>
              <Form.Input
                value={eventName}
                onChange={(_ev, data) => this.setName(data.value)}
              />
              <Form.Button primary fluid type="submit" loading={loading}>
                Create
              </Form.Button>
            </Form>
          </div>
        )}
      </Mutation>
    );
  }

  setName = (eventName: string) => {
    console.log(eventName);
    this.setState({ eventName });
  };
}
