defmodule Twitch.Eventsub.ChannelUpdate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "twitch_channel_updates" do
    field(:twitch_user_id, :string)
    field(:title, :string)
    field(:category_id, :string)
    field(:category_name, :string)
    timestamps()
  end

  @required_attrs ~w[twitch_user_id title category_id category_name]a
  @optional_attrs ~w[]a
  @attrs @required_attrs ++ @optional_attrs
  def changeset(%__MODULE__{} = sub, attrs \\ %{}) do
    sub
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
