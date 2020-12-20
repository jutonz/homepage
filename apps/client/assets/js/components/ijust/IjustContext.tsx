import * as React from "react";
import { Divider } from "semantic-ui-react";

import { IjustEventInput } from "@components/ijust/IjustEventInput";
import { IjustRecentEvents } from "@components/ijust/IjustRecentEvents";
import { IjustBreadcrumbs } from "@components/ijust/IjustBreadcrumbs";

export const IjustContext = ({ context }) => (
  <div className="m-5">
    <IjustBreadcrumbs context={context} viewing={context} />
    <IjustEventInput ijustContextId={context.id} />
    <Divider hidden />
    <IjustRecentEvents context={context} />
  </div>
);
