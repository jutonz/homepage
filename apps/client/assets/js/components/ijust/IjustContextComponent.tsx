import * as React from "react";

import type { IjustContext } from "@types";
import { IjustBreadcrumbs } from "./IjustBreadcrumbs";
import { IjustEventInput } from "./IjustEventInput";
import { IjustRecentEvents } from "./IjustRecentEvents";

interface Props {
  context: IjustContext;
}

export function IjustContextComponent({ context }: Props) {
  return (
    <div className="m-5">
      <IjustBreadcrumbs context={context} viewing={context} />
      <div className="mb-5" />
      <IjustEventInput ijustContextId={context.id} />
      <hr />
      <IjustRecentEvents context={context} />
    </div>
  );
}
