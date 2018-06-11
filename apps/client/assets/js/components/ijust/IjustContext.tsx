import * as React from "react";
import { Divider } from "semantic-ui-react";

import { IjustEventInput } from "@components/ijust/IjustEventInput";
import { IjustRecentEvents } from "@components/ijust/IjustRecentEvents";
import { IjustBreadcrumbs } from "@components/ijust/IjustBreadcrumbs";

const _IjustContext = ({ context }) => (
  <div>
    <IjustBreadcrumbs context={context} viewing={context} />
    <IjustEventInput ijustContextId={context.id} />
    <Divider hidden />
    <IjustRecentEvents context={context} />
  </div>
);

export const IjustContext = _IjustContext;
