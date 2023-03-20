import * as React from "react";
import { Link } from "react-router-dom";
import Breadcrumbs from "@mui/material/Breadcrumbs";

interface Props {
  context?: any;
  event?: any;
  viewing: any | "contexts";
}

export const IjustBreadcrumbs = ({ context, event, viewing }: Props) => (
  <Breadcrumbs className="text-xl" separator="→">
    {contextsLinkOrNot(viewing)}
    {context && contextLinkOrNot(context, viewing)}
    {event && <h1 className="text-xl">{event.name}</h1>}
  </Breadcrumbs>
);

const contextsLinkOrNot = (viewing: String) => {
  if (viewing === "contexts") {
    return "Contexts";
  } else {
    return <Link to="/ijust/contexts">Contexts</Link>;
  }
};

const contextLinkOrNot = (context: any, viewing: String) => {
  if (viewing === context) {
    return context.name;
  } else {
    return <Link to={`/ijust/contexts/${context.id}`}>{context.name}</Link>;
  }
};
