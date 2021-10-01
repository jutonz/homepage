import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Grid, Header } from "semantic-ui-react";
import { MainNav } from "@components/MainNav";
import { ChangePasswordForm } from "@components/ChangePasswordForm";
import { OneTimeLoginLink } from "@components/OneTimeLoginLink";
import { TeamMembershipForm } from "@components/TeamMembershipForm";
import { TeamCreationForm } from "@components/TeamCreationForm";
import { TeamJoinForm } from "@components/TeamJoinForm";
import { IntegrateWithTwitchForm } from "@components/IntegrateWithTwitchForm";

const style = StyleSheet.create({
  routeContainer: {
    margin: "0 30px",
  },
});

export const SettingsRoute = () => (
  <div>
    <MainNav activeItem={"settings"} />
    <Grid
      columns={2}
      divided
      relaxed
      stackable
      className={css(style.routeContainer)}
    >
      <Grid.Column>
        <Header className="transform scale-50">User settings</Header>
        <Grid columns={2} relaxed stackable>
          <ChangePasswordForm />
          <OneTimeLoginLink />
          <IntegrateWithTwitchForm />
        </Grid>
      </Grid.Column>

      <Grid.Column>
        <Header>Team settings</Header>
        <Grid columns={2} relaxed stackable>
          <TeamMembershipForm />
          <TeamCreationForm />
          <TeamJoinForm />
        </Grid>
      </Grid.Column>
    </Grid>
  </div>
);
