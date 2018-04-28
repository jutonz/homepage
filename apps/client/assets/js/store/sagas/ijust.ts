import { put, takeEvery } from "redux-saga/effects";

import { createIjustEventMuation } from "@store/mutations";
import {
  getIjustDefaultContextQuery,
  getIjustContextQuery,
  getIjustRecentEventsQuery,
  getIjustContextEventQuery
} from "@store/queries";

interface Action {
  type: string;
}

////////////////////////////////////////////////////////////////////////////////

function* fetchDefaultContext() {
  try {
    yield put({ type: "IJUST_FETCH_DEFAULT_CONTEXT_REQUEST" });
    const context = yield getIjustDefaultContextQuery();
    yield put({ type: "IJUST_STORE_CONTEXT", context });
    yield put({ type: "IJUST_FETCH_DEFAULT_CONTEXT_SUCCESS", context });
  } catch (errors) {
    yield put({ type: "IJUST_FETCH_DEFAULT_CONTEXT_FAILURE", errors });
  }
}

////////////////////////////////////////////////////////////////////////////////

interface FetchContextAction extends Action {
  id: string;
}
export const fetchContext = (id: string): FetchContextAction => ({
  type: "IJUST_FETCH_CONTEXT",
  id
});
function* _fetchContext({ id }: FetchContextAction) {
  try {
    yield put({ type: "IJUST_FETCH_CONTEXT_REQUEST" });
    const context = yield getIjustContextQuery({ id });
    yield put({ type: "IJUST_STORE_CONTEXT", context });
    yield put({ type: "IJUST_FETCH_CONTEXT_SUCCESS", context });
  } catch (errors) {
    yield put({ type: "IJUST_FETCH_CONTEXT_FAILURE", errors, id });
  }
}

////////////////////////////////////////////////////////////////////////////////

interface CreateEventAction extends Action {
  contextId: string;
  name: string;
}
function* createEvent({ contextId, name }: CreateEventAction) {
  try {
    yield put({ type: "IJUST_CREATE_EVENT_REQUEST" });
    const event = yield createIjustEventMuation({
      contextId,
      name
    });
    yield put({ type: "IJUST_STORE_EVENT", event });
    yield put({ type: "IJUST_CREATE_EVENT_SUCCESS", event });
    yield put({ type: "IJUST_FETCH_RECENT_EVENTS", contextId });
  } catch (errors) {
    yield put({ type: "IJUST_CREATE_EVENT_FAILURE", errors });
  }
}

////////////////////////////////////////////////////////////////////////////////

interface FetchContextEventAction extends Action {
  contextId: string;
  eventId: string;
}
export const fetchContextEvent = (
  contextId,
  eventId
): FetchContextEventAction => ({
  type: "IJUST_FETCH_CONTEXT_EVENT",
  contextId,
  eventId
});
function* _fetchContextEvent({ contextId, eventId }: FetchContextEventAction) {
  try {
    yield put({ type: "IJUST_FETCH_CONTEXT_EVENT_REQUEST", eventId });
    const event = yield getIjustContextEventQuery({
      contextId,
      eventId
    });
    yield put({ type: "IJUST_STORE_EVENT", event });
    yield put({ type: "IJUST_FETCH_CONTEXT_EVENT_SUCCESS", event });
  } catch (errors) {
    yield put({ type: "IJUST_FETCH_CONTEXT_EVENT_FAILURE", eventId, errors });
  }
}

////////////////////////////////////////////////////////////////////////////////

interface StoreEventAction extends Action {
  event: any;
}
function* storeEvent({ event }: StoreEventAction) {
  yield put({ type: "IJUST_STORE_EVENTS", events: [event] });
}

////////////////////////////////////////////////////////////////////////////////

interface FetchRecentEventsAction extends Action {
  contextId: string;
}
export const fetchRecentEvents = (
  contextId: string
): FetchRecentEventsAction => ({
  type: "IJUST_FETCH_RECENT_EVENTS",
  contextId
});
function* _fetchRecentEvents({ contextId }: FetchRecentEventsAction) {
  try {
    yield put({ type: "IJUST_FETCH_RECENT_EVENTS_REQUEST", contextId });
    const events = yield getIjustRecentEventsQuery({ contextId });
    yield put({ type: "IJUST_STORE_EVENTS", events, contextId });
    const eventIds = events.map(e => e.id);
    yield put({
      type: "IJUST_FETCH_RECENT_EVENTS_SUCCESS",
      eventIds,
      contextId
    });
  } catch (errors) {
    yield put({ type: "IJUST_FETCH_RECENT_EVENTS_FAILURE", errors });
  }
}

////////////////////////////////////////////////////////////////////////////////

export default function*() {
  yield takeEvery("IJUST_FETCH_DEFAULT_CONTEXT", fetchDefaultContext);
  yield takeEvery("IJUST_FETCH_CONTEXT", _fetchContext);
  yield takeEvery("IJUST_CREATE_EVENT", createEvent);
  yield takeEvery("IJUST_STORE_EVENT", storeEvent);
  yield takeEvery("IJUST_FETCH_RECENT_EVENTS", _fetchRecentEvents);
  yield takeEvery("IJUST_FETCH_CONTEXT_EVENT", _fetchContextEvent);
}
