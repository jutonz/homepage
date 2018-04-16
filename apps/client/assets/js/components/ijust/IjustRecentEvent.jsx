import React from "react";

const _IjustRecentEvent = ({ event }) => (
  <div>
    <div>{event.name}</div>
    <div>{event.insertedAt}</div>
    <div>{event.count}</div>
  </div>
);

export const IjustRecentEvent = _IjustRecentEvent;
