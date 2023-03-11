import { randString } from "./../support/utils";


describe("authorization", () => {
  beforeEach(() => {
    //cy.checkoutSession();
    //cy.intercept(`${Cypress.config("baseUrl")}**`, (req) => {
      //req.headers["x-beam-metadata"] = Cypress.env("beamMetadata");
    //}).as("sandbox");
  });

  afterEach(() => {
    //cy.dropSession();
  });

  it("allows a user to signup", () => {
    cy.visit("/");

    cy.findByRole("link", { name: "Or signup" }).click();

    cy.findByLabelText("Email").type(`${randString()}@example.com`);
    cy.findByLabelText("Password").type("password123");

    cy.findByRole("button", { name: "Signup" }).click();

    //cy.reload(true);

    //cy.findByRole("link", { name: "Logout" })

    //cy.url().should("eql", "#/");
  });
});
