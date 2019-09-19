defmodule Client.Factory do
  use ExMachina.Ecto, repo: Client.Repo

  def user_factory(attrs) do
    pw = Map.get(attrs, :password, "password123")
    {:ok, pw_hash} = Auth.hash_password(pw)

    user = %Client.User{
      email: sequence(:email, &"email-#{&1}@t.co"),
      password: pw,
      password_hash: pw_hash
    }

    merge_attributes(user, attrs)
  end

  def api_token_factory do
    %Client.ApiTokens.ApiToken{
      token: Client.ApiTokens.ApiToken.gen_token(),
      description: sequence(:description, &"description-#{&1}"),
      user_id: insert(:user).id
    }
  end
end
