defmodule HomepageWeb.SessionResolver do
  alias Homepage.Server.SessionServer
  alias Homepage.User

  @doc """
  """
  def check_session(_parent, _args, %{ context: context }) do
    with {:ok, _user} <- Map.fetch(context, :current_user),
      do: {:ok, true},
      else: (_ -> {:ok, false})
  end
end
