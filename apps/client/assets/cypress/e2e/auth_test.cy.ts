describe("authorization", () => {
  it("allows a user to signup, logout, and login", () => {
    cy.signup().then(({ email, password }) => {
      cy.findByRole("link", { name: "Logout" }).click();

      cy.location("hash").should("eql", "#/login");

      cy.findByLabelText("Email").type(email);
      cy.findByLabelText("Password").type(password);
      cy.findByRole("button", { name: "Login" }).click();
    });

    cy.location("pathname").should("eql", "/");
  });

  it("allows a user to change their password", () => {
    const password = "password123";
    cy.initSession({ password }).then(({ email }) => {
      cy.findByRole("link", { name: "Settings" }).click();

      const newPassword = "abc123";

      cy.contains("form", "Change password").within(() => {
        cy.findByLabelText("Current password").type(password);
        cy.findByLabelText("New password").type(newPassword);
        cy.findByLabelText("New password (confirm)").type(newPassword + "no match");

        cy.findByRole("button", { name: "Change password" }).should("be.disabled");

        cy.findByLabelText("New password (confirm)").clear().type(newPassword);

        cy.findByRole("button", { name: "Change password" }).click();
      });

      cy.findByText("Password changed.").should("exist");

      cy.findByRole("link", { name: "Logout" }).click();
      cy.visit("/");

      cy.login({ email, password: newPassword });
    });
  });

  it("allows a user to generate a one-time login link", () => {
    cy.initSession();
    cy.findByRole("link", { name: "Settings" }).click();

    cy.contains("div", "One-time login link").within(() => {
      cy.findByRole("button", { name: "Generate" }).click();
    });
  });
});
