defmodule Twitch.Eventpub.Subscriptions do
  alias Twitch.{
    Eventpub.Subscriptions.Create,
    Eventpub.Subscriptions.MakeRequest,
    Util.Interactor
  }

  @spec create(MakeRequest.options()) :: {:ok, any()} | {:error, any()}
  def create(options) do
    Interactor.perform(%{}, [
      {Create, []},
      {MakeRequest, [options]}
    ])
  end
end
