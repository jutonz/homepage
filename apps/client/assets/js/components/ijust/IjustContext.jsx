import React from "react";
import { Divider } from "semantic-ui-react";

import { IjustEventInput } from "@components/ijust/IjustEventInput";
import { IjustRecentEvents } from "@components/ijust/IjustRecentEvents";

const _IjustContext = ({ context }) => (
  <div>
    Using {context.name} context
    <IjustEventInput context={context} />
    <Divider hidden />
    <IjustRecentEvents context={context} />
  </div>
);

export const IjustContext = _IjustContext;
