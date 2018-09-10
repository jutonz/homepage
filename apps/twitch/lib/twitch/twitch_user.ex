defmodule Twitch.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Twitch.{Repo, User}

  @type t :: %__MODULE__{}

  schema "users" do
    field(:email, :string)
    field(:display_name, :string)
    field(:access_token, :map)
    field(:user_id, :string)
    field(:twitch_user_id, :string)

    timestamps()
  end

  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.Changeset.cast(attrs, ~w(email display_name access_token user_id twitch_user_id)a)
    |> Ecto.Changeset.validate_required(
      ~w(email display_name access_token user_id twitch_user_id)a
    )
    |> Ecto.Changeset.unique_constraint(:twitch_user_id)
  end

  def login_from_twitch(user_id, access_token) do
    token = access_token["access_token"]
    {:ok, from_twitch} = token |> Twitch.Auth.current_user()

    attrs = %{
      email: from_twitch["email"],
      display_name: from_twitch["display_name"],
      twitch_user_id: from_twitch["id"],
      access_token: access_token,
      user_id: to_string(user_id)
    }

    case User |> Repo.get_by(twitch_user_id: from_twitch["id"]) do
      user = %User{} ->
        user |> User.changeset(attrs) |> Repo.update()

      _ ->
        %User{} |> User.changeset(attrs) |> Repo.insert()
    end
  end

  @spec delete_by_user_id(String.t()) :: {:ok, User.t()} | {:error, String.t()}
  def delete_by_user_id(user_id) do
    User |> Repo.get_by(user_id: to_string(user_id)) |> Repo.delete()
  end
end
