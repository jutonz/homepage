defmodule ClientWeb.Schema do
  use Absinthe.Schema

  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :inserted_at, non_null(:string)
    field :updated_at, non_null(:string)
  end

  query do
    field :get_user, :user do
      arg :id, :id
      arg :email, :string
      resolve &ClientWeb.UserResolver.get_user/3
    end

    field :check_session, :boolean do
      resolve &ClientWeb.SessionResolver.check_session/3
    end

    field :get_one_time_login_link, :string do
      resolve &ClientWeb.SessionResolver.get_one_time_login_link/3
    end
  end

  mutation do
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :email, :string
      arg :password, :string

      resolve &ClientWeb.UserResolver.update_user/3
    end

    field :change_password, :user do
      arg :current_password, non_null(:string)
      arg :new_password, non_null(:string)

      resolve &ClientWeb.UserResolver.change_password/3
    end
  end
end
