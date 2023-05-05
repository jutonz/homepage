import React, { useCallback, useState } from "react";
import { format, formatDistanceToNow, parseISO } from "date-fns";
import { useParams } from "react-router-dom";
import Breadcrumbs from "@mui/material/Breadcrumbs";
import Button from "@mui/material/Button";
import { Link } from "react-router-dom";

import { MainNav } from "./../../components/MainNav";
import { IjustEventOccurrences } from "./../../components/ijust/IjustEventOccurrences";
import { Constants } from "./../../utils/Constants";
import { QueryLoader } from "./../../utils/QueryLoader";
import { graphql } from "../../gql";
import { IjustEditEventModal } from "./../../components/ijust/IjustEventEditModal";
import type { IjustEvent, IjustContext } from "@gql-types";
import { formatMoney } from "../../utils/money";

const QUERY = graphql(`
  query GetEvent($contextId: ID!, $eventId: ID!) {
    getIjustContextEvent(contextId: $contextId, eventId: $eventId) {
      id
      name
      count
      cost {
        amount
        currency
      }
      insertedAt
      updatedAt
      ijustContextId
      ijustContext {
        id
        name
      }
    }
  }
`);

export function IjustContextEventRoute() {
  const { contextId, eventId } = useParams();

  return (
    <div>
      <MainNav />
      <div className="m-4 max-w-3xl lg:mx-auto">
        <QueryLoader
          query={QUERY}
          variables={{ contextId, eventId }}
          component={({ data }) => {
            const event = data.getIjustContextEvent;
            const context = data.getIjustContextEvent.ijustContext;
            return <IjustEventComponent event={event} context={context} />;
          }}
        />
      </div>
    </div>
  );
}

interface IjustEventComponentProps {
  event: IjustEvent;
  context: IjustContext;
}

function IjustEventComponent({ event, context }: IjustEventComponentProps) {
  const [editing, setEditing] = useState(false);

  return (
    <div>
      <div className="flex justify-between">
        <Breadcrumbs className="text-xl" separator="→">
          <Link to="/ijust/contexts">Contexts</Link>
          <Link to={`/ijust/contexts/${context.id}`}>{context.name}</Link>;
          <h1 className="text-xl">{event.name}</h1>
        </Breadcrumbs>
      </div>
      <IjustEditEventModal
        event={event}
        visible={editing}
        setVisible={setEditing}
      />
      <Button onClick={() => setEditing(true)}>Edit</Button>
      <EventInfo event={event} />
      <IjustEventOccurrences contextId={context.id} eventId={event.id} />
    </div>
  );
}

interface EventInfoProps {
  event: IjustEvent;
}
function EventInfo({ event }: EventInfoProps) {
  return (
    <>
      <table className="mt-3 w-full">
        <tbody>
          <tr>
            <td className="py-3">Count</td>
            <td className="py-3">{event.count}</td>
          </tr>
          <tr>
            <td className="py-3">First occurred</td>
            <td className="py-3">
              {format(
                parseISO(event.insertedAt + "Z"),
                Constants.dateTimeFormat
              )}
              <span className="ml-3">
                ({formatDistanceToNow(parseISO(event.insertedAt + "Z"))} ago)
              </span>
            </td>
          </tr>
          <tr>
            <td className="py-3">Last occurred</td>
            <td className="py-3">
              {format(
                parseISO(event.updatedAt + "Z"),
                Constants.dateTimeFormat
              )}
              <span className="ml-3">
                ({formatDistanceToNow(parseISO(event.updatedAt + "Z"))} ago)
              </span>
            </td>
          </tr>
          <tr>
            <td>Cost</td>
            <td>{formatMoney(event.cost)}</td>
          </tr>
        </tbody>
      </table>
    </>
  );
}
