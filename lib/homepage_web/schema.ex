defmodule HomepageWeb.Schema do
  use Absinthe.Schema

  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :inserted_at, non_null(:string)
    field :updated_at, non_null(:string)
  end

  object :session do
    field :token, non_null(:string)
  end

  query do
    @desc "Get a specific user by ID or email"
    field :get_user, :user do
      arg :id, :id
      arg :email, :string
      resolve &HomepageWeb.UserResolver.get_user/3
    end
  end

  mutation do
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :email, :string
      arg :password, :string

      resolve &HomepageWeb.UserResolver.update_user/3
    end

    field :change_password, :user do
      arg :current_password, non_null(:string)
      arg :new_password, non_null(:string)

      resolve &HomepageWeb.UserResolver.change_password/3
    end
  end
end
