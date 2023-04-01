import { setup, insert, User } from "./../support/utils";

describe("Ijust", () => {
  it("allows me to create an event", () => {
    cy.initSession();
    cy.findByRole("link", { name: "Ijust" }).click();

    cy.findByRole("combobox", {
      name: "Search for an event, or create a new one",
    }).type("An event{enter}");

    cy.findByRole("heading", { name: "An event" });
  });

  it("entering an existing event name adds a new occurrence", () => {
    setup(createEventWithOccurrence).then(({ initUrl, event }) => {
      cy.visit(initUrl);
      cy.findByRole("link", { name: "Ijust" }).click();

      cy.findByRole("combobox", {
        name: "Search for an event, or create a new one",
      }).type(`${event.name}{enter}`);
    });
  });

  it("allows adding and deleting of occurrences", () => {
    setup(createEventWithOccurrence).then(({ initUrl, event }) => {
      cy.visit(initUrl);
      cy.findByRole("link", { name: "Ijust" }).click();

      cy.contains("a", event.name).click();
      cy.get("[data-role=ijust-occurrence]").should("have.length", 1);

      cy.findByRole("button", { name: "Add Occurrence" }).click();
      cy.get("[data-role=ijust-occurrence]").should("have.length", 2);

      cy.get("[data-role=ijust-occurrence]")
        .findAllByRole("button", { name: "Delete" })
        .click();
      cy.findByRole("dialog", { name: "Are you sure?" }).within(() => {
        cy.findByRole("button", { name: "Delete" }).click();
      });

      cy.get("[data-role=ijust-occurrence]").should("have.length", 1);
    });
  });
});

async function createEventWithOccurrence(user: User) {
  const context = await insert("ijust_context", {
    user_id: user.id,
    name: "default",
  });
  const event = await insert("ijust_event", {
    ijust_context_id: context.id,
  });
  const occurrence = await insert("ijust_occurrence", {
    ijust_event_id: event.id,
    user_id: user.id,
  });

  return { context, event, occurrence };
}
