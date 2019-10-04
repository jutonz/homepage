defmodule Twitch.Util.Interactible do
  @callback up(any()) :: {:ok, any()} | {:error, any()}
  @callback down(any()) :: {:ok, any()} | {:error, any()}
end
