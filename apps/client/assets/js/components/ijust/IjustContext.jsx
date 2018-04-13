import React from "react";

import { IjustEventInput } from "@components/ijust/IjustEventInput";
import { IjustRecentEvents } from "@components/ijust/IjustRecentEvents";

const _IjustContext = ({ context }) => (
  <div>
    Using {context.name} context
    <IjustEventInput context={context} />
    <IjustRecentEvents context={context} />
  </div>
);

export const IjustContext = _IjustContext;
