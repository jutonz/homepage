import * as React from "react";
import { Breadcrumb } from "semantic-ui-react";
import { Link } from "react-router-dom";
import { StyleSheet, css } from "aphrodite";

interface Props {
  context?: any;
  event?: any;
  viewing: any | "contexts";
}

const style = StyleSheet.create({
  breadcrumb: {
    fontSize: "1.3rem",
    display: "flex",
  },
  sep: {
    fontSize: "0.9rem",
    display: "flex",
    alignItems: "center",
    margin: "0 10px 2px 10px",
  },
});

export const IjustBreadcrumbs = ({ context, event, viewing }: Props) => (
  <Breadcrumb className={css(style.breadcrumb)}>
    <Breadcrumb.Section>{contextsLinkOrNot(viewing)}</Breadcrumb.Section>
    {context && (
      <Breadcrumb.Divider className={css(style.sep)}>></Breadcrumb.Divider>
    )}
    {context && (
      <Breadcrumb.Section>
        {contextLinkOrNot(context, viewing)}
      </Breadcrumb.Section>
    )}
    {event && (
      <Breadcrumb.Divider className={css(style.sep)}>></Breadcrumb.Divider>
    )}
    {event && <Breadcrumb.Section>{event.name}</Breadcrumb.Section>}
  </Breadcrumb>
);

const contextsLinkOrNot = (viewing) => {
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
