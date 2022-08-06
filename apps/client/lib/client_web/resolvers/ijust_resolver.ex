defmodule ClientWeb.IjustResolver do
  alias Client.{IjustContext, IjustEvent, IjustOccurrence}
  import Ecto.Query, only: [from: 2]

  def get_ijust_default_context(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, context} <- user.id |> IjustContext.get_default_context(),
         do: {:ok, context},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to get default context"}
           )
  end

  def get_ijust_contexts(_parent, _args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, contexts} <- user.id |> IjustContext.get_all_for_user(),
         do: {:ok, contexts},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch contexts"}
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
         event <-
           Client.Repo.preload(event,
             ijust_occurrences: from(o in IjustOccurrence, order_by: [desc: o.inserted_at])
           ),
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
         occurrence <- Client.Repo.preload(occurrence, :ijust_event),
         do: {:ok, occurrence},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch occurrences"}
           )
  end

  def delete_occurrence(_parent, args, %{context: context}) do
    with {:ok, _user} <- context |> Map.fetch(:current_user),
         {:ok, occ_id} <- args |> Map.fetch(:ijust_occurrence_id),
         {:ok, occurrence} <- IjustEvent.delete_occurrence(occ_id),
         do: {:ok, occurrence},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch occurrences"}
           )
  end

  def search_events(_parent, args, %{context: context}) do
    with {:ok, user} <- context |> Map.fetch(:current_user),
         {:ok, context_id} <- args |> Map.fetch(:ijust_context_id),
         {:ok, ijust_context} <- IjustContext.get_for_user(context_id, user.id),
         {:ok, name} <- args |> Map.fetch(:name),
         {:ok, events} <- IjustEvent.search_by_name(ijust_context.id, name),
         do: {:ok, events},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch events"}
           )
  end
end
