defmodule Twitch.Util.Interactible do
  @callback up(any(), any()) :: {:ok, any()} | {:error, any()}
  @callback down(any(), any()) :: {:ok, any()} | {:error, any()}
end
