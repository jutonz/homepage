import { test, expect } from "@playwright/test";

const BASE_URL = "http://localhost:4002";

test.describe("Auth", () => {
  test("allows me to sign up", async ({ page }) => {
    await page.goto(BASE_URL);
    await page.getByRole("link", { name: "Or signup" }).click();

    const email = `wee-${Math.random()}@example.com`;
    await page.getByRole("textbox", { name: "Email" }).fill(email);
    await page.getByRole("textbox", { name: "Password" }).fill("password123");
    await page.getByRole("button", { name: "Signup" }).click();

    await expect(page.getByRole("link", { name: "Logout" })).toBeVisible();
  });
});
