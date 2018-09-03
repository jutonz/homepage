defmodule EventedTest do
  use ExUnit.Case
  doctest Evented

  test "greets the world" do
    assert Evented.hello() == :world
  end
end
