import { from, Subject } from "rxjs";
import { filter, debounceTime, switchMap } from "rxjs/operators";
import gql from "graphql-tag";

import { GraphqlClient } from "@app/index";

const SEARCH_EVENTS = gql`
  query IjustEventsSearch($ijustContextId: ID!, $eventName: String!) {
    ijustEventsSearch(ijustContextId: $ijustContextId, name: $eventName) {
      id
      name
      count
      insertedAt
      updatedAt
      ijustContextId
    }
  }
`;

export class IjustEventTypeahead {
  callback: (results: Array<any>) => void;
  ijustContextId: string;
  subject: any;
  latestSearch: string | undefined;

  constructor(callback: (results: Array<any>) => void, ijustContextId: string) {
    this.callback = callback;
    this.ijustContextId = ijustContextId;
    this.subject = this.setupSubject();
    this.latestSearch = undefined;
  }

  search = (eventName: string) => {
    this.subject.next(eventName);
    this.latestSearch = eventName;
  };

  getLatestSearch = () => this.latestSearch;

  //////////////////////////////////////////////////////////////////////////////
  // Private
  //////////////////////////////////////////////////////////////////////////////

  setupSubject = () => {
    const subj = new Subject<any>().pipe(
      debounceTime(500),
      filter(n => n.length && n.length >= 2),
      switchMap(this.queryRemote)
    );

    subj.subscribe((results: Array<any>) => {
      this.callback(results);
    });

    return subj;
  };

  private queryRemote = (eventName: string) => {
    return new Promise((resolve, _reject) => {
      const { ijustContextId } = this;
      GraphqlClient.query({
        query: SEARCH_EVENTS,
        variables: { eventName, ijustContextId }
      }).then((data: any) => {
        const results = data.data.ijustEventsSearch;
        resolve(results);
      });
    });
  };
}
