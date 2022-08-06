import * as React from "react";
import { Divider } from "semantic-ui-react";

import { IjustBreadcrumbs } from "./IjustBreadcrumbs";
import { IjustEventInput } from "./IjustEventInput";
import { IjustRecentEvents } from "./IjustRecentEvents";

export const IjustContext = ({ context }) => (
  <div className="m-5">
    <IjustBreadcrumbs context={context} viewing={context} />
    <div className="mb-5" />
    <IjustEventInput ijustContextId={context.id} />
    <Divider hidden />
    <IjustRecentEvents context={context} />
  </div>
);
