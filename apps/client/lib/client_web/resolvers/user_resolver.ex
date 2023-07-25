defmodule ClientWeb.UserResolver do
  alias Client.{Auth, User, Repo, Session}

  def signup(_parent, args, _context) do
    with {:ok, email} <- args |> Map.fetch(:email),
         {:ok, password} <- args |> Map.fetch(:password),
         {:ok, user} <- Session.signup(email, password),
         {:ok, access, _claims} <- Auth.jwt_for_resource(user),
         {:ok, refresh, _claims} <- Auth.jwt_for_resource(user, %{typ: "refresh"}),
         do: {:ok, %{user: user, access_token: access, refresh_token: refresh}},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Signup failed"}
           )
  end

  @one_day_sec 60 * 60 * 24
  def login(_parent, %{email: email, password: password}, _context) do
    with {:ok, user} <- Auth.authenticate(email, password),
         {:ok, access, _claims} <- Auth.jwt_for_resource(user),
         {:ok, refresh, _claims} <- Auth.single_use_jwt(user, @one_day_sec * 30, "refresh"),
         do: {:ok, %{user: user, access_token: access, refresh_token: refresh}},
         else: (
           {:error, reason} -> {:error, reason}
           _ -> {:error, "Something went wrong"}
         )
  end

  def refresh_token(_parent, %{refresh_token: refresh_token}, _context) do
    with {:ok, %{"email" => email}, _claims} <- Auth.resource_for_single_use_jwt(refresh_token),
         {:ok, user} <- User.get_by_email(email),
         {:ok, access, _claims} <- Auth.jwt_for_resource(user),
         {:ok, refresh, _claims} <- Auth.jwt_for_resource(user, %{typ: "refresh"}),
         do: {:ok, %{user: user, access_token: access, refresh_token: refresh}},
         else: (_ -> {:error, "Failed to refresh"})
  end

  def get_users(_parent, _args, _context) do
    {:ok, Repo.all(User)}
  end

  def get_user(_parent, args, %{context: context}) do
    with {:ok, _user} <- context |> Map.fetch(:current_user),
         {:ok, user_id} <- args |> Map.fetch(:id),
         user = %User{} <- User |> Repo.get(user_id),
         do: {:ok, user},
         else: (_ -> {:error, "No users matching criteria"})
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
         {:ok, user} <- User.change_password(user, current_pw, new_pw),
         do: {:ok, user},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to update password"}
           )
  end
end
