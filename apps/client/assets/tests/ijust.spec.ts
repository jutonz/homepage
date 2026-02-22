import { test, expect } from "@playwright/test";
import { initSession, insert, BASE_URL } from "./helpers";

test.describe("Ijust", () => {
  test("allows me to create an event", async ({ page }) => {
    await initSession(page);
    await page.getByRole("link", { name: "Ijust" }).click();

    await page
      .getByRole("combobox", {
        name: "Search for an event, or create a new one",
      })
      .fill("An event");
    await page.keyboard.press("Enter");

    await expect(page.getByRole("heading", { name: "An event" })).toBeVisible();
  });

  test("entering an existing event opens that event", async ({ page }) => {
    const user = await insert("user", { password: "password123" });
    const { event } = await createEventWithOccurrence(user);
    await page.goto(BASE_URL + `/?as=${user.id}`);

    await page.getByRole("link", { name: "Ijust" }).click();

    const searchbox = page.getByRole("combobox", {
      name: "Search for an event, or create a new one",
    });
    await searchbox.fill(event.name);

    await expect(page.getByRole("option", { name: event.name })).toBeVisible();

    await searchbox.press("Enter");

    await expect(page.getByRole("heading", { name: event.name })).toBeVisible();
  });

  test("allows adding and deleting of occurrences", async ({ page }) => {
    const user = await insert("user", { password: "password123" });
    const { event } = await createEventWithOccurrence(user);
    await page.goto(BASE_URL + `/?as=${user.id}`);

    await page.getByRole("link", { name: "Ijust" }).click();

    await page.locator("a", { hasText: event.name }).click();
    await expect(page.locator("[data-role=ijust-occurrence]")).toHaveCount(1);

    await page.getByRole("button", { name: "Add Occurrence" }).click();
    await expect(page.locator("[data-role=ijust-occurrence]")).toHaveCount(2);

    await page
      .locator("[data-role=ijust-occurrence]")
      .getByRole("button", { name: "Delete" })
      .first()
      .click();
    await page
      .getByRole("dialog", { name: "Are you sure?" })
      .getByRole("button", { name: "Delete" })
      .click();

    await expect(page.locator("[data-role=ijust-occurrence]")).toHaveCount(1);
  });

  test("can edit an event", async ({ page }) => {
    const user = await insert("user", { password: "password123" });
    const { event } = await createEventWithOccurrence(user);
    await page.goto(BASE_URL + `/?as=${user.id}`);

    await page.getByRole("link", { name: "Ijust" }).click();
    await page.locator("a", { hasText: event.name }).click();

    await page.getByRole("button", { name: "Edit" }).click();
    await page.getByLabel("Name").fill(event.name + "wee");
    await page.getByLabel("Cost").fill("123");
    await page.getByRole("button", { name: "Save" }).click();

    await expect(
      page.getByRole("heading", { name: `${event.name}wee` }),
    ).toBeVisible();
    await expect(page.getByRole("cell", { name: "$123.00" })).toBeVisible();
  });
});

async function createEventWithOccurrence(user: { id: string }) {
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
