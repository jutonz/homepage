defmodule ClientWeb.SessionResolver do
  def check_session(_parent, _args, %{context: context}) do
    with {:ok, _user} <- Map.fetch(context, :current_user),
         do: {:ok, %{authenticated: true}},
         else: (_ -> {:ok, %{authenticated: false}})
  end

  def get_one_time_login_link(_parent, _args, %{context: context}) do
    with {:ok, user} <- Map.fetch(context, :current_user),
         {:ok, token, _claims} <- Auth.single_use_jwt(user.id),
         do: {:ok, "#{ClientWeb.Endpoint.url()}/api/login?token=#{token}"},
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Could not generate link"}
           )
  end
end
