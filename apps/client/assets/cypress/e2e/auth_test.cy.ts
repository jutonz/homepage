describe("authorization", () => {
  it("allows a user to signup and login", () => {
    cy.signup().then(({ email, password }) => {
      cy.findByRole("link", { name: "Logout" }).click();

      cy.location("hash").should("eql", "#/login");

      cy.findByLabelText("Email").type(email);
      cy.findByLabelText("Password").type(password);
      cy.findByRole("button", { name: "Login" }).click();
    });

    cy.location("pathname").should("eql", "/");
  });
});
