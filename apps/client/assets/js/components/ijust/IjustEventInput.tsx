import * as React from "react";
import { Button, Header, Message, Input } from "semantic-ui-react";
import { Mutation } from "react-apollo";
import gql from "graphql-tag";
import { css, StyleSheet } from "aphrodite";

import { FormBox } from "@components/FormBox";
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
  },
  input: {
    width: "100%"
  },
  button: {
    marginTop: "20px"
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
            <FormBox styles={styles.form}>
              <Header>Create event</Header>
              {error && <Message error>{collectGraphqlErrors(error)}</Message>}
              <Input
                value={eventName}
                className={css(styles.input)}
                onChange={(_ev, data) => this.setName(data.value)}
              />
              <Button
                primary
                fluid
                loading={loading}
                className={css(styles.button)}
                onClick={() => {
                  createEvent({
                    variables: { eventName, ijustContextId }
                  }).then(() => this.setName(""));
                }}
              >
                Create
              </Button>
            </FormBox>
          </div>
        )}
      </Mutation>
    );
  }

  setName = (eventName: string) => {
    this.setState({ eventName });
  };
}
