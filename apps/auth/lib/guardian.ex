defmodule Auth.Guardian do
  use Guardian, otp_app: :auth

  def subject_for_token(resource_id, _claims), do: {:ok, resource_id}

  def resource_from_claims(%{"sub" => id}) do
    {:ok, id}
  end
end
