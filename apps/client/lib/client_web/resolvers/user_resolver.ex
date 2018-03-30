defmodule ClientWeb.UserResolver do
  alias Client.{User,UserServer,Repo}

  def get_users(_parent, _args, _context) do
    {:ok, Repo.all(User)}
  end

  def get_user(_parent, args, %{context: context}) do
    with {:ok, user } <- context |> Map.fetch(:current_user),
         {:ok, user_id} <- args |> Map.fetch(:id),
         user = %User{} <- User |> Repo.get(user_id),
      do: {:ok, user },
      else: (
        _ -> {:error, "No users matching criteria"}
      )
  end

  def update_user(_parent, args, context) do
    with {:ok, user} <- Map.fetch(context.context, :current_user),
         changeset <- user |> User.changeset(args),
         {:ok, user} <- Repo.update(changeset),
         do: {:ok, user},
         else: (_ -> {:error, "Could not update user"})
  end

  def change_password(_params, args, %{context: context}) do
    with {:ok, user} <- Map.fetch(context, :current_user),
         {:ok, current_pw} <- Map.fetch(args, :current_password),
         {:ok, new_pw} <- Map.fetch(args, :new_password),
         {:ok, user} <- UserServer.change_password(user, current_pw, new_pw),
         do: {:ok, user},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to update password"}
           )
  end
end
