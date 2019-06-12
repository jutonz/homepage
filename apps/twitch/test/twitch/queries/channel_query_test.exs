defmodule Twitch.Queries.ChannelQueryTest do
  use Twitch.DataCase, async: true
  alias Twitch.Queries.ChannelQuery

  describe "persist?/1" do
    test "is true if there's one channel with persist = true" do
      channel = insert(:channel, persist: true)

      assert ChannelQuery.persist?(channel.name)
    end

    test "is true if there are two channels with persist = true" do
      [ch1, _ch2] = insert_list(2, :channel, persist: true)

      assert ChannelQuery.persist?(ch1.name)
    end

    test "is false if there are no channels with persist = true" do
      channel = insert(:channel, persist: false)

      refute ChannelQuery.persist?(channel.name)
    end

    test "is false if the channel name can't be found" do
      refute ChannelQuery.persist?("blah")
    end
  end
end
