defmodule Client.Slug do
  @moduledoc """
  Wrapper for Slugger in case we want to use a different slugging library in the future
  """

  @spec generate(String.t()) :: String.t()
  def generate(string), do: Slugger.slugify(string)
end
