defmodule HomepageWeb.UserResolver do
  alias Homepage.Repo
  alias Homepage.User
  alias HomepageWeb.Helpers.UserSession

  def get_users(_parent, _args, _context) do
    {:ok, Repo.all(User)}
  end

  def get_user(_parent, args, _context) do
    case Repo.get_by(User, args) do
      user ->
        {:ok, user}
      _ ->
        {:error, "No users matching criteria"}
    end
  end

  def update_user(_parent, args, context) do
    with {:ok, user} <- Map.fetch(context.context, :current_user),
         changeset <- user |> User.changeset(args),
         {:ok, user} <- Repo.update(changeset) do
           {:ok, user}
         else
           _ -> {:error, "Could not update user"}
         end


    #{id, args} = Map.pop(args, :id)
    #changeset = context.context.current_user |> User.changeset(args)

    #changeset = User |> Repo.get!(id) |> User.changeset(args)

    #IO.puts "hi"
    #IO.inspect context.context
    #IO.puts "bye"

    #case Repo.update(changeset) do
      #{:ok, user} -> {:ok, user}
      #{:error, message} -> {:error, message}
    #end
  end

  def login(_parent, %{email: email, password: password}, _context) do
    case UserSession.login_jwt(email, password) do
      {:ok, session} -> {:ok, session}
      {:error, message} -> {:error, message}
    end
  end
end
