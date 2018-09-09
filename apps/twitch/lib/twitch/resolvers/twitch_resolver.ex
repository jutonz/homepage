defmodule Twitch.TwitchResolver do
  alias Twitch.User

  def get_current_user(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         twitch_user <- Twitch.User |> Twitch.Repo.get_by(user_id: to_string(user.id)),
    do: {:ok, twitch_user}
  end
end
