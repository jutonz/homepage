import { test, expect } from "@playwright/test";
import { initSession, insert, randString } from "./helpers";

test.describe("teams", () => {
  test("allows me to create a team", async ({ page }) => {
    const teamName = `team-${randString()}`;
    const user = await initSession(page);

    await page.getByRole("link", { name: "Settings" }).click();

    const createForm = page.locator("form", { hasText: "Create a team" });
    await createForm.getByLabel("Name").fill(teamName);
    await createForm.getByRole("button", { name: "Create Team" }).click();

    await expect(page).toHaveURL(/#\/teams/);
    await expect(page.getByRole("heading", { name: teamName })).toBeVisible();

    const teamUsersBox = page.locator("[data-role=box]", {
      hasText: "Team users",
    });
    await expect(
      teamUsersBox.getByRole("link", { name: user.email }),
    ).toBeVisible();
  });

  test("allows me to join an existing team", async ({ page }) => {
    await initSession(page);
    await page.getByRole("link", { name: "Settings" }).click();

    const team = await insert("team");

    const joinForm = page.locator("form", { hasText: "Join a team" });
    await joinForm.getByLabel("Name").fill(team.name);
    await joinForm.getByRole("button", { name: "Join Team" }).click();

    await expect(page.getByRole("heading", { name: team.name })).toBeVisible();
    await expect(page).toHaveURL(new RegExp(`#/teams/${team.id}`));
  });

  test("allows me to rename a team", async ({ page }) => {
    const user = await initSession(page);
    await page.getByRole("link", { name: "Settings" }).click();

    const team = await insert("team");

    const joinForm = page.locator("form", { hasText: "Join a team" });
    await joinForm.getByLabel("Name").fill(team.name);
    await joinForm.getByRole("button", { name: "Join Team" }).click();

    await expect(page.getByRole("heading", { name: team.name })).toBeVisible();
    await expect(page.getByRole("link", { name: user.email })).toBeVisible();

    const newName = team.name + "-new!";
    const renameForm = page.locator("form", { hasText: "Rename team" });
    await renameForm.getByLabel("New name").fill(newName);
    await renameForm.getByRole("button", { name: "Rename team" }).click();

    await expect(page.getByRole("heading", { name: newName })).toBeVisible();
    await expect(page.getByText("Team renamed.")).toBeVisible();
  });

  test("allows me to leave a team", async ({ page }) => {
    await initSession(page);
    await page.getByRole("link", { name: "Settings" }).click();

    const team = await insert("team");

    const joinForm = page.locator("form", { hasText: "Join a team" });
    await joinForm.getByLabel("Name").fill(team.name);
    await joinForm.getByRole("button", { name: "Join Team" }).click();

    await expect(page.getByRole("heading", { name: team.name })).toBeVisible();

    const leaveForm = page.locator("form", { hasText: "Leave team" });
    await leaveForm.getByRole("button", { name: "Leave" }).click();

    await expect(page).toHaveURL(/#\/settings/);

    const membershipSection = page.locator("div", {
      hasText: "Team membership",
    });
    await expect(
      membershipSection.getByRole("link", { name: team.name }),
    ).not.toBeVisible();
  });

  test("allows me to delete a team", async ({ page }) => {
    await initSession(page);
    await page.getByRole("link", { name: "Settings" }).click();

    const team = await insert("team");

    const joinForm = page.locator("form", { hasText: "Join a team" });
    await joinForm.getByLabel("Name").fill(team.name);
    await joinForm.getByRole("button", { name: "Join Team" }).click();

    await expect(page.getByRole("heading", { name: team.name })).toBeVisible();

    const deleteForm = page.locator("form", { hasText: "Delete team" });
    await deleteForm.getByRole("button", { name: "Delete" }).click();

    const dialog = page.getByRole("dialog", { name: "Are you sure?" });
    await dialog.getByRole("button", { name: "Delete team" }).click();

    await expect(page).toHaveURL(/#\/settings/);

    const membershipSection = page.locator("div", {
      hasText: "Team membership",
    });
    await expect(
      membershipSection.getByRole("link", { name: team.name }),
    ).not.toBeVisible();
  });
});
