import { randString } from "../support/utils";

describe("teams", () => {
  it("allows me to create a team", () => {
    const teamName = `team-${randString()}`;
    cy.initSession().then(({ email }) => {
      cy.findByRole("link", { name: "Settings" }).click();

      cy.contains("form", "Create a team").within(() => {
        cy.findByLabelText("Name").type(teamName);
        cy.findByRole("button", { name: "Create Team" }).click();
      });

      cy.location("hash").should("include", "#/teams")
      cy.findByRole("heading", { name: teamName });

      cy.contains("[data-role=box]", "Team users").within(() => {
        cy.findByRole("link", { name: email }).click();
      });
    });
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

  it("allows me to rename a team", () => {
    cy.initSession();
    cy.findByRole("link", { name: "Settings" }).click();

    cy.insert("team").then(({ name }) => {
      cy.contains("form", "Join a team").within(() => {
        cy.findByLabelText("Name").type(name);
        cy.findByRole("button", { name: "Join Team" }).click();
      });

      cy.findByRole("heading", { name });

      const newName = name + "-new!";
      cy.contains("form", "Rename team").within(() => {
        cy.findByLabelText("New name").type(newName);
        cy.findByRole("button", { name: "Rename team" }).click();
      });

      cy.findByRole("heading", { name: newName });
      cy.findByText("Team renamed.").should("exist");
    });
  });

  it("allows me to leave a team", () => {
    cy.initSession();
    cy.findByRole("link", { name: "Settings" }).click();

    cy.insert("team").then(({ name }) => {
      cy.contains("form", "Join a team").within(() => {
        cy.findByLabelText("Name").type(name);
        cy.findByRole("button", { name: "Join Team" }).click();
      });

      cy.findByRole("heading", { name });

      cy.contains("form", "Leave team").within(() => {
        cy.findByRole("button", { name: "Leave" }).click();
      });

      cy.location("hash").should("eql", "#/settings");

      cy.contains("div", "Team membership").within(() => {
        cy.findByRole("link", { name }).should("not.exist");
      });
    });
  });

  it("allows me to delete a team", () => {
    cy.initSession();
    cy.findByRole("link", { name: "Settings" }).click();

    cy.insert("team").then(({ name }) => {
      cy.contains("form", "Join a team").within(() => {
        cy.findByLabelText("Name").type(name);
        cy.findByRole("button", { name: "Join Team" }).click();
      });

      cy.findByRole("heading", { name });

      cy.contains("form", "Delete team").within(() => {
        cy.findByRole("button", { name: "Delete" }).click();
      });

      cy.findByRole("dialog", { name: "Are you sure?" }).within(() => {
        cy.findByRole("button", { name: "Delete team" }).click();
      });

      cy.location("hash").should("eql", "#/settings");

      cy.contains("div", "Team membership").within(() => {
        cy.findByRole("link", { name }).should("not.exist");
      });
    });
  });
});
