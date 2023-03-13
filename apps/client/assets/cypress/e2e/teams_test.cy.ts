import { randString } from "../support/utils";

describe("teams", () => {
  it("allows me to create a team", () => {
    const teamName = `team-${randString()}`;
    cy.signup();
    cy.findByRole("link", { name: "Settings" }).click();

    cy.contains("form", "Create a team").within(() => {
      cy.findByLabelText("Name").type(teamName);
      cy.findByRole("button", { name: "Create Team" }).click();
    });

    cy.location("hash").should("include", "#/teams")
    cy.findByRole("heading", { name: teamName });
  });
});
