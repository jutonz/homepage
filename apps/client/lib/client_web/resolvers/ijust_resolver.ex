defmodule ClientWeb.IjustResolver do
  alias Client.{IjustContext, IjustEvent}

  def get_ijust_default_context(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, context} <- user |> IjustContext.get_default_context(),
         do: {:ok, context},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to update password"}
           )
  end

  def get_ijust_context(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, context_id} <- args |> Map.fetch(:id),
         {:ok, context} <- context_id |> IjustContext.get_for_user(user.id),
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
         {:ok, event} <- context_id |> IjustEvent.add_for_user(user, args),
         do: {:ok, event},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to update password"}
           )
  end

  def get_recent_events(_parent, args, %{context: context}) do
    with {:ok, _user} <- context |> Map.fetch(:current_user),
         {:ok, context_id} <- args |> Map.fetch(:context_id),
         {:ok, events} <- context_id |> IjustContext.recent_events(),
         do: {:ok, events},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch recent events"}
           )
  end

  def get_context_event(_parent, args, %{context: context}) do
    with {:ok, _user} <- context |> Map.fetch(:current_user),
         {:ok, context_id} <- args |> Map.fetch(:context_id),
         {:ok, event_id} <- args |> Map.fetch(:event_id),
         {:ok, event} <- context_id |> IjustEvent.get_for_context(event_id),
         do: {:ok, event},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch event"}
           )
  end
end
