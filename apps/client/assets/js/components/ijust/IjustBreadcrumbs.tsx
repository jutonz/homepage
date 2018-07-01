import * as React from "react";
import { Breadcrumb } from "semantic-ui-react";
import { Link } from "react-router-dom";

interface Props {
  context?: any;
  event?: any;
  viewing: any | "contexts";
}

export const IjustBreadcrumbs = ({ context, event, viewing }: Props) => (
  <Breadcrumb>
    <Breadcrumb.Section>{contextsLinkOrNot(viewing)}</Breadcrumb.Section>
    {context && <Breadcrumb.Divider />}
    {context && (
      <Breadcrumb.Section>
        {contextLinkOrNot(context, viewing)}
      </Breadcrumb.Section>
    )}
    {event && <Breadcrumb.Divider />}
    {event && <Breadcrumb.Section>Events</Breadcrumb.Section>}
    {event && <Breadcrumb.Divider />}
    {event && <Breadcrumb.Section>{event.name}</Breadcrumb.Section>}
  </Breadcrumb>
);

const contextsLinkOrNot = viewing => {
  if (viewing === "contexts") {
    return "Contexts";
  } else {
    return <Link to="/ijust/contexts">Contexts</Link>;
  }
};

const contextLinkOrNot = (context, viewing) => {
  if (viewing === context) {
    return context.name;
  } else {
    return <Link to={`/ijust/contexts/${context.id}`}>{context.name}</Link>;
  }
};
