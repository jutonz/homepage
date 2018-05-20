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

//const _IjustEventInput = ({
//context,
//name,
//setName,
//createEvent,
//isCreating,
//createErrors
//}) => (
//<div>
//<Input value={name} onChange={(_ev, data) => setName(data.value)} />
//{createErrors}
//<Button
//primary
//onClick={() => createEvent(context.id, name)}
//loading={isCreating}
//>
//Create
//</Button>
//</div>
//);

//export const IjustEventInput = connect(
//(state: any) => ({
//name: state.ijust.get("newEventName") || "",
//isCreating: state.ijust.get("creatingEvent"),
//createErrors: state.ijust.get("createErrors")
//}),
//dispatch => ({
//setName: name => dispatch({ type: "SET_IJUST_NEW_EVENT_NAME", name }),
//createEvent: (ijustContextId, name) =>
//dispatch({ type: "IJUST_CREATE_EVENT", ijustContextId, name })
//})
//)(_IjustEventInput);
