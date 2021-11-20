defmodule Twitch.Eventpub.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "eventpub_subscriptions" do
    field(:twitch_id, :string)
    timestamps()
  end

  @required_attrs ~w[]a
  @optional_attrs ~w[twitch_id]a
  @attrs @required_attrs ++ @optional_attrs
  def changeset(%__MODULE__{} = sub, attrs \\ %{}) do
    sub
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
