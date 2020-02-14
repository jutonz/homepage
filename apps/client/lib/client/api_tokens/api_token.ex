defmodule Client.ApiTokens.ApiToken do
  use Ecto.Schema
  alias Client.ApiTokens.ApiToken

  @type t :: %__MODULE__{
    token: String.t(),
    description: String.t() | nil,
    user_id: integer
  }

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "api_tokens" do
    field(:token, :string)
    field(:description, :string)
    field(:user_id, :integer)
    timestamps()
  end

  def changeset(%ApiToken{} = token, attrs \\ %{}) do
    token
    |> Ecto.Changeset.cast(attrs, ~w[token description user_id]a)
    |> maybe_gen_token()
    |> Ecto.Changeset.validate_required(~w[token user_id]a)
    |> Ecto.Changeset.unique_constraint(:token, name: :api_tokens_user_id_token_index)
    |> Ecto.Changeset.unique_constraint(:description, name: :api_tokens_user_id_description_index)
  end

  def maybe_gen_token(changeset) do
    case Ecto.Changeset.get_field(changeset, :token) do
      nil -> Ecto.Changeset.put_change(changeset, :token, gen_token())
      _ -> changeset
    end
  end

  def gen_token, do: Ecto.UUID.generate()
end
