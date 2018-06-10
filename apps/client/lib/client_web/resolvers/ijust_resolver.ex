defmodule ClientWeb.IjustResolver do
  alias Client.{IjustContext, IjustEvent, IjustOccurrence}

  def get_ijust_default_context(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, context} <- user.id |> IjustContext.get_default_context(),
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
         {:ok, event} <- user |> IjustEvent.add_for_user(args),
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

  def get_event_occurrences(_parent, args, %{context: context}) do
    with {:ok, _user} <- context |> Map.fetch(:current_user),
         {:ok, event_id} <- args |> Map.fetch(:event_id),
         {:ok, offset} <- args |> Map.fetch(:offset),
         {:ok, occurrences} <- event_id |> IjustOccurrence.get_for_event(offset),
         do: {:ok, occurrences},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch occurrences"}
           )
  end

  def add_occurrence_to_event(_parent, args, %{context: context}) do
    with {:ok, _user} <- context |> Map.fetch(:current_user),
         {:ok, event_id} <- args |> Map.fetch(:ijust_event_id),
         {:ok, occurrence} <- event_id |> IjustEvent.add_occurrence_by_id(),
         do: {:ok, occurrence},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch occurrences"}
           )
  end

  def get_contexts(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, contexts} <- user.id |> IjustContext.get_by_user_id,
      do: {:ok, contexts},
      else: (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch contexts"}
      )
         
  end
end
