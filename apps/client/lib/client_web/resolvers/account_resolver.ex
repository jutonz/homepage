defmodule ClientWeb.AccountResolver do
  alias Client.{Account,Repo,User}

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
      else: (
        {:eror, reason} -> {:error, reason}
        _ -> {:error, "Could not find matching account"}
      )
  end

  def create_account(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         changeset <- %Account{} |> Account.changeset(args),
         changeset <- changeset |> Ecto.Changeset.put_assoc(:users, [user]),
         {:ok, account} <- changeset |> Repo.insert do
       {:ok, account}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset |> extract_errors}
      {:error, reason} -> {:error, reason}
      _ -> {:error, "Could not create account"}
    end
  end

  def extract_errors(%Ecto.Changeset{} = changeset) do
    changeset.errors
    |> Enum.map(fn(error) ->
      attr = error |> elem(0) |> to_string |> String.capitalize
      message = error |> elem(1) |> elem(0)
      "#{attr} #{message}"
    end)
  end
end
