defmodule Client.Ijust.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Client.{Ijust}

  schema "ijust_events" do
    field(:name, :string)
    field(:count, :integer)
    timestamps()
    belongs_to :ijust_context, Ijust.Context
    has_many :ijust_occurrences, Ijust.Occurrence
  end

  def changeset(%Ijust.Event{} = event, attrs \\ %{}) do
    event
    |> cast(attrs, [])
  end
end
