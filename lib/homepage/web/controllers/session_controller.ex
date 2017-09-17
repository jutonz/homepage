defmodule Homepage.Web.SessionController do
  use Homepage.Web, :controller
  alias Homepage.User

  def show_login(conn, _params) do
    render conn, :login
  end

  def login(conn, _params) do
    authenticated = true

    if authenticated do
      redirect conn, to: "/hello"
    end
  end

  def show_signup(conn, _params) do
    conn
      |> clear_flash
      |> render(:signup)
  end

  def signup(conn, params) do
    changeset = User.changeset(%User{}, params)
    case Repo.insert(changeset) do
      { :ok, user } ->
        redirect conn, to: "/hello/#{user.email}"
      { _, result } ->
        errors =
          Keyword.keys(result.errors)
            |> Enum.map(fn(key) ->
              message = result.errors[key] |> elem(0)
              to_string(key) <> " " <> message
            end)
            |> Enum.join(", ")

        conn
          |> put_flash(:error, "Failed to signup: " <> errors)
          |> render(:signup)
    end
  end
end
