import React from "react";
import { ChangePasswordForm } from "./../components/ChangePasswordForm";
import { IntegrateWithTwitchForm } from "./../components/IntegrateWithTwitchForm";
import { MainNav } from "./../components/MainNav";
import { OneTimeLoginLink } from "./../components/OneTimeLoginLink";
import { TeamCreationForm } from "./../components/TeamCreationForm";
import { TeamJoinForm } from "./../components/TeamJoinForm";
import { TeamMembershipForm } from "./../components/TeamMembershipForm";

export const SettingsRoute = () => (
  <div>
    <MainNav activeItem={"settings"} />

    <div className="m-5 flex flex-row flex-wrap max-w-full">
      <div className="mr-5 pb-5">
        <div className="text-xl font-bold">User settings</div>
        <div className="flex flex-row flex-wrap sm:space-x-4">
          <ChangePasswordForm />
          <OneTimeLoginLink />
          <IntegrateWithTwitchForm />
        </div>
      </div>

      <div>
        <div className="text-xl font-bold">Team settings</div>
        <div className="flex flex-row flex-wrap sm:space-x-4">
          <TeamMembershipForm />
          <TeamCreationForm />
          <TeamJoinForm />
        </div>
      </div>
    </div>
  </div>
);
