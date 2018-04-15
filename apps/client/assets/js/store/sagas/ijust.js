import { put, takeEvery } from "redux-saga/effects";

import { createIjustEventMuation } from "@store/mutations";
import {
  getIjustDefaultContextQuery,
  getIjustRecentEventsQuery
} from "@store/queries";

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

function* createEvent({ contextId, name }) {
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

function* storeEvent({ event }) {
  yield put({ type: "IJUST_STORE_EVENTS", events: [event] });
}

function* fetchRecentEvents({ contextId }) {
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

export default function*() {
  yield takeEvery("IJUST_FETCH_DEFAULT_CONTEXT", fetchDefaultContext);
  yield takeEvery("IJUST_CREATE_EVENT", createEvent);
  yield takeEvery("IJUST_STORE_EVENT", storeEvent);
  yield takeEvery("IJUST_FETCH_RECENT_EVENTS", fetchRecentEvents);
}
