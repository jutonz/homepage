defmodule ClientWeb.WaterLogChannelTest do
  use ClientWeb.ChannelCase, async: true

  import Client.Factory

  alias Client.Repo
  alias Client.WaterLogs.Entry
  alias ClientWeb.UserSocket
  alias ClientWeb.WaterLogChannel

  setup do
    user = insert(:user)
    api_token = insert(:api_token, user_id: user.id)
    log = insert(:water_log, user_id: user.id)

    {:ok, socket} = connect(UserSocket, %{"token" => api_token.token})

    %{socket: socket, user: user, log: log}
  end

  describe "join/3" do
    test "joins the user's own log", %{socket: socket, log: log} do
      assert {:ok, _reply, joined} =
               subscribe_and_join(socket, WaterLogChannel, "water_log:#{log.id}")

      assert joined.assigns.water_log_id == log.id
    end

    test "refuses another user's log without raising", %{socket: socket} do
      other_log = insert(:water_log)

      assert {:error, %{"reason" => "no such water log"}} =
               subscribe_and_join(socket, WaterLogChannel, "water_log:#{other_log.id}")
    end

    test "refuses a log that doesn't exist", %{socket: socket} do
      assert {:error, %{"reason" => "no such water log"}} =
               subscribe_and_join(
                 socket,
                 WaterLogChannel,
                 "water_log:#{Ecto.UUID.generate()}"
               )
    end
  end

  describe "commit" do
    test "creates an entry owned by the scope", %{socket: socket, user: user, log: log} do
      {:ok, _reply, joined} =
        subscribe_and_join(socket, WaterLogChannel, "water_log:#{log.id}")

      :ok = Phoenix.PubSub.subscribe(Client.PubSub, "water_log_internal:#{log.id}")

      push(joined, "commit", %{"ml" => 250})

      assert_receive(:saved, 1000)

      assert [entry] = Repo.all(Entry)
      assert entry.ml == 250
      assert entry.user_id == user.id
      assert entry.water_log_id == log.id
    end

    test "replies with an error when the entry is invalid", %{socket: socket, log: log} do
      {:ok, _reply, joined} =
        subscribe_and_join(socket, WaterLogChannel, "water_log:#{log.id}")

      ref = push(joined, "commit", %{"ml" => nil})

      assert_reply(ref, :error, %{"error" => _})
      assert Repo.all(Entry) == []
    end
  end
end
