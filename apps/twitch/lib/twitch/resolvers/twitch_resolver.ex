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
         else: (
           {:error, reason} -> {:error, reason}
           _ -> {:error, "Failed to remove integration"}
         )
  end

  def channel_subscribe(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, channel} <- args |> Map.fetch(:channel),
         {:ok, twitch_user} <- user.id |> Twitch.User.get_by_user_id(),
         {:ok, channel} <- Twitch.Channel.subscribe(channel, twitch_user),
         do: {:ok, channel},
         else: (
           {:error, reason} -> {:error, reason}
           _ -> {:error, "Failed to subscribe"}
         )
  end

  def channel_unsubscribe(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, name} <- args |> Map.fetch(:name),
         {:ok, twitch_user} <- user.id |> Twitch.User.get_by_user_id(),
         {:ok, channel} <- Twitch.Channel.unsubscribe(name, twitch_user),
         do: {:ok, channel},
         else: (
           {:error, reason} -> {:error, reason}
           _ -> {:error, "Failed to unsubscribe"}
         )
  end

  def get_channels(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, twitch_user} <- user.id |> Twitch.User.get_by_user_id(),
         {:ok, channels} <- twitch_user.id |> Twitch.Channel.all_by_user_id(),
         do: {:ok, channels},
         else: (
           {:error, reason} -> {:error, reason}
           _ -> {:error, "Failed to get channels"}
         )
  end

  def get_channel(_parent, args, %{context: context}) do
    with {:ok, channel_name} <- args |> Map.fetch(:channel_name),
         {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, twitch_user} <- user.id |> Twitch.User.get_by_user_id(),
         {:ok, channel} <- twitch_user.id |> Twitch.Channel.get_by_user_id(channel_name),
         do: {:ok, channel},
         else: (
           {:error, reason} -> {:error, reason}
           _ -> {:error, "Failed to get channel"}
         )
  end
end
