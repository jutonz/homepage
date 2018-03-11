defmodule ClientWeb.AccountResolver do
  def get_user_accounts(_parent, _args, %{context: context}) do
    with {:ok, user} <- Map.fetch(context, :current_user),
    do: {:ok, [%{name: "Account 1", id: "123"}]},
    else:
      (
        {:error, reason} -> {:error, reason}
        _ -> {:error, "Could not fetch accounts"}
      )
  end

  def create_account(_parent, args, %{context: context}) do
    with {:ok, user} <- Map.fetch(context, :current_user) do
      #{:ok, args}
      name = args.name
      {:ok, %{id: name, name: name}}
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, "Could not create account"}
    end
  end
end
