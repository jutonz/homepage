defmodule ClientWeb.Live.AssignScope do
  @moduledoc """
  `on_mount` hook assigning a `Client.Scope` to routed LiveViews.

  It runs on the initial static render *and* on every websocket connect, so a
  session that has gone stale between the two — or between reconnects on a
  long-lived tab — is caught rather than trusted.

  Nested LiveViews rendered through `live_render/3` do not go through the
  router and so do not run this hook. They receive a serializable user id in
  their session (see `Client.Session.current_user_id/1`), which is what they
  have to build a scope from when they come to need one.
  """

  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [connected?: 1, get_connect_info: 2, redirect: 2]

  alias Client.{Scope, Session}

  def on_mount(:default, _params, session, socket) do
    case Scope.for_user_id(Session.current_user_id(session)) do
      %Scope{} = scope -> {:cont, assign(socket, :scope, scope)}
      nil -> {:halt, redirect(socket, to: login_path(socket))}
    end
  end

  # Mirrors the return path the browser plug preserves, so a session going
  # stale mid-reconnect doesn't cost the user their place.
  defp login_path(socket) do
    with true <- connected?(socket),
         %URI{path: path} when is_binary(path) <- get_connect_info(socket, :uri) do
      "/#/login?to=#{path}"
    else
      _ -> "/#/login"
    end
  end
end
