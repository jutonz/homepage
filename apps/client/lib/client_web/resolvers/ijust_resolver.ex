defmodule ClientWeb.IjustResolver do
  alias Client.{Ijust, Repo}

  def get_ijust_default_context(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, context} <- user |> Ijust.Context.get_default_context(),
         do: {:ok, context},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to update password"}
           )
  end

  def create_ijust_event(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, context_id} <- args |> Map.fetch(:context_id),
         {:ok, event} <- context_id |> Ijust.Event.add_for_user(user, args),
         do: {:ok, event},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to update password"}
           )
  end

  def get_recent_events(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, context_id} <- args |> Map.fetch(:context_id),
         {:ok, events} <- context_id |> Ijust.Context.recent_events(),
         do: {:ok, events},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch recent events"}
           )
  end
end
