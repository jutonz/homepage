defmodule ClientWeb.AccountResolver do
  alias Client.{Account, Repo, User}

  def get_user_accounts(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         user <- user |> Repo.preload(:accounts) do
      {:ok, user.accounts}
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, "Could not fetch accounts"}
    end
  end

  def get_account(_parent, args, %{context: %{current_user: current_user}}) do
    with {:ok, account_id} <- args |> Map.fetch(:id),
         {:ok, account} <- current_user |> User.get_account(account_id),
         do: {:ok, account},
         else:
           (
             {:eror, reason} -> {:error, reason}
             _ -> {:error, "Could not find matching account"}
           )
  end

  def create_account(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         changeset <- %Account{} |> Account.changeset(args),
         changeset <- changeset |> Ecto.Changeset.put_assoc(:users, [user]),
         {:ok, account} <- changeset |> Repo.insert() do
      {:ok, account}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset |> extract_errors}

      {:error, reason} ->
        {:error, reason}

      _ ->
        {:error, "Could not create account"}
    end
  end

  def delete_account(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, account_id} <- args |> Map.fetch(:id),
         {:ok, account} <- user |> User.get_account(account_id),
         changeset <- account |> Account.changeset(),
         {:ok, account} <- changeset |> Repo.delete(),
         do: {:ok, account},
         else:
           (
             {:error, %Ecto.Changeset{} = changeset} ->
               {:error, changeset |> extract_errors}

             {:eror, reason} ->
               {:error, reason}

             _ ->
               {:error, "Could not delete account"}
           )
  end

  def rename_account(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, account_id} <- args |> Map.fetch(:id),
         {:ok, account} <- user |> User.get_account(account_id),
         changeset <- account |> Account.changeset(args),
         {:ok, account} <- changeset |> Repo.update(),
         do: {:ok, account},
         else:
           (
             {:error, %Ecto.Changeset{} = changeset} ->
               {:error, changeset |> extract_errors}

             {:eror, reason} ->
               {:error, reason}

             _ ->
               {:error, "Could not rename account"}
           )
  end

  def get_account_users(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, account_id} <- args |> Map.fetch(:id),
         {:ok, account} <- user |> User.get_account(account_id),
         withUsers <- account |> Repo.preload(:users),
         do: {:ok, withUsers.users},
         else:
           (
             {:error, %Ecto.Changeset{} = changeset} ->
               {:error, changeset |> extract_errors}

             {:eror, reason} ->
               {:error, reason}

             _ ->
               {:error, "Could not retrieve users"}
           )
  end

  def get_account_user(_parent, args, %{context: context}) do
    with {:ok, _user} <- context |> Map.fetch(:current_user),
         {:ok, account_id} <- args |> Map.fetch(:account_id),
         {:ok, user_id} <- args |> Map.fetch(:user_id),
         {:ok, user} <- Account.get_account_user(account_id, user_id),
         do: {:ok, user},
         else:
           (
             {:eror, reason} -> {:error, reason}
             _ -> {:error, "Could not retrieve user"}
           )
  end

  def join_account(_parent, args, %{context: context}) do
    with {:ok, user } <- context |> Map.fetch(:current_user),
         {:ok, name} <- args |> Map.fetch(:name),
         {:ok, account} <- name |> Account.get_by_name,
         {:ok, user} <- user |> User.join_account(account),
      do: {:ok, account},
      else: (
        {:error, reason} -> {:error, reason}
        _ -> {:error, "Failed to join account"}
      )
  end

  def extract_errors(%Ecto.Changeset{} = changeset) do
    changeset.errors
    |> Enum.map(fn error ->
      attr = error |> elem(0) |> to_string |> String.capitalize()
      message = error |> elem(1) |> elem(0)
      "#{attr} #{message}"
    end)
  end
end
