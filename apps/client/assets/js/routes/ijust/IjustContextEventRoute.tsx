import { connect } from "react-redux";
import * as React from "react";

import { MainNav } from "@components/MainNav";
import { fetchAndRenderRecord } from "@utils/fetchAndRenderRecord";
import { fetchContextEvent } from "@store/sagas/ijust";

const _IjustContextEventRoute = ({ match, event, fetchContextEvent }) => {
  const { contextId, eventId } = match.params;

  return (
    <div>
      <MainNav activeItem="ijust" />
      {fetchAndRenderRecord({
        record: event,
        fetchRecord: () => fetchContextEvent(contextId, eventId),
        renderRecord: renderEvent
      })}
    </div>
  );
};

const renderEvent = event => <div>{event.name}</div>;

export const IjustContextEventRoute = connect(
  (state: any, props: any) => ({
    event: state.ijust.getIn(["events", props.match.params.eventId])
  }),
  dispatch => ({
    fetchContextEvent: (contextId, eventId) =>
      dispatch(fetchContextEvent(contextId, eventId))
  })
)(_IjustContextEventRoute);
