defmodule Homepage.GuardianSerializer do
  use Guardian, otp_app: :homepage
  alias Homepage.Repo
  alias Homepage.User

  def subject_for_token(resource, _claims \\ %{}) do
    case resource do
      %User{} -> {:ok, "User:#{resource.id}"}
      _ -> {:error, "Unknown resource type: #{resource}"}
    end
  end

  def resource_from_claims(claims) do
    with {:ok, sub} <- claims |> Map.fetch("sub"),
         [resource_type, id] <- sub |> String.split(":"),
         {:ok, resource} <- resource_from_subject(resource_type, id),
      do: ({:ok, resource})
    #else: (_ -> {:error, "Could not lookup resource from claims"})
  end

  defp resource_from_subject(resource_type, id) when resource_type == "User" do
    case User |> Repo.get(id) do
      user -> {:ok, user}
      _ -> {:error, "Could not find User with id #{id}"}
    end
  end
end
