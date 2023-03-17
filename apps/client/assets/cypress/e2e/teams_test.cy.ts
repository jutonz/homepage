import { randString } from "../support/utils";

describe("teams", () => {
  it("allows me to create a team", () => {
    const teamName = `team-${randString()}`;
    cy.initSession();

    cy.findByRole("link", { name: "Settings" }).click();

    cy.contains("form", "Create a team").within(() => {
      cy.findByLabelText("Name").type(teamName);
      cy.findByRole("button", { name: "Create Team" }).click();
    });

    cy.location("hash").should("include", "#/teams")
    cy.findByRole("heading", { name: teamName });
  });

  it("allows me to join an existing team", () => {
    cy.initSession();
    cy.findByRole("link", { name: "Settings" }).click();

    cy.insert("team").then(({ id, name }) => {
      cy.contains("form", "Join a team").within(() => {
        cy.findByLabelText("Name").type(name);
        cy.findByRole("button", { name: "Join Team" }).click();
      });

      cy.findByRole("heading", { name });
      cy.location("hash").should("eql", `#/teams/${id}`);
    });
  });
});
