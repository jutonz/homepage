defmodule Twitch.TwitchResolver do
  def get_current_user(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         twitch_user <- Twitch.User |> Twitch.Repo.get_by(user_id: to_string(user.id)),
         do: {:ok, twitch_user}
  end

  def remove_integration(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, twitch_user} <- Twitch.User.delete_by_user_id(user.id),
         do: {:ok, twitch_user},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to remove integration"}
           )
  end
end
