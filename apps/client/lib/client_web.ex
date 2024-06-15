defmodule ClientWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ClientWeb, :controller
      use ClientWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def static_paths do
    ~w(
      assets
      fonts
      images
      favicon.ico
      robots.txt
      css
      js
      static-css
      static-js
    )
  end

  def controller do
    quote do
      use Phoenix.Controller,
        namespace: ClientWeb

      import Plug.Conn
      import ClientWeb.Gettext
      import Phoenix.LiveView.Controller, only: [live_render: 2, live_render: 3]
      alias ClientWeb.Router.Helpers, as: Routes

      unquote(verified_routes())
    end
  end

  # Same as `controller` but for the new phoenix viewless controller format.
  def viewless_controller do
    quote do
      use Phoenix.Controller,
        namespace: ClientWeb,
        # this line is the only difference
        formats: ~w[html json]a

      import Plug.Conn
      import ClientWeb.Gettext
      import Phoenix.LiveView.Controller, only: [live_render: 2, live_render: 3]
      alias ClientWeb.Router.Helpers, as: Routes

      unquote(verified_routes())
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/client_web/templates",
        namespace: ClientWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [
          get_csrf_token: 0,
          view_module: 1,
          view_template: 1
        ]

      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView
      alias ClientWeb.Live.LiveHelpers

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ClientWeb.Gettext
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(view_helpers())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: ClientWeb.Endpoint,
        router: ClientWeb.Router,
        statics: ClientWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defp view_helpers do
    quote do
      import Phoenix.HTML
      import Phoenix.HTML.Form
      use PhoenixHTMLHelpers

      import Phoenix.View
      import Phoenix.Component
      import ClientWeb.CoreComponents

      import ClientWeb.ErrorHelpers
      import ClientWeb.Gettext

      alias ClientWeb.Router.Helpers, as: Routes

      unquote(verified_routes())
    end
  end
end
