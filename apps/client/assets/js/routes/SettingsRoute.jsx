import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Grid, Header } from "semantic-ui-react";
import { MainNav } from "@components/MainNav";
import { ChangePasswordForm } from "@components/ChangePasswordForm";
import { OneTimeLoginLink } from "@components/OneTimeLoginLink";
import { AccountMembershipForm } from "@components/AccountMembershipForm";
import { AccountCreationForm } from "@components/AccountCreationForm";
import { AccountJoinForm } from "@components/AccountJoinForm";

const style = StyleSheet.create({
  routeContainer: {
    margin: "0 30px"
  }
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
        <Header>User settings</Header>
        <Grid columns={2} relaxed stackable>
          <ChangePasswordForm />
          <OneTimeLoginLink />
        </Grid>
      </Grid.Column>

      <Grid.Column>
        <Header>Account settings</Header>
        <Grid columns={2} relaxed stackable>
          <AccountMembershipForm />
          <AccountCreationForm />
          <AccountJoinForm />
        </Grid>
      </Grid.Column>
    </Grid>
  </div>
);
