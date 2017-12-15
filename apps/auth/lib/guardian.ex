defmodule Auth.Guardian do
  use Guardian, otp_app: :auth
  alias Client.{User,Repo}

  def subject_for_token(resource_id, _claims), do: {:ok, resource_id}

  def resource_from_claims(%{ "sub" => id }) do
    # assumes User resource (problematic?)
    {:ok, Repo.get(User, id)}
  end
end
