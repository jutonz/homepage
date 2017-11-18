defmodule HomepageWeb.Schema do
  use Absinthe.Schema

  object :link do
    field :id, non_null(:id)
    field :url, non_null(:string)
    field :description, non_null(:string)
    field :inserted_at, non_null(:string)
    field :updated_at, non_null(:string)
  end

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
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &HomepageWeb.UserResolver.get_users/3
    end

    @desc "Get a specific user by ID or email"
    field :get_user, :user do
      arg :id, :id
      arg :email, :string
      resolve &HomepageWeb.UserResolver.get_user/3
    end

    @desc "Login as a given user"
    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &HomepageWeb.UserResolver.login/3
    end

    field :get_link, :link do
      arg :id, non_null(:id)

      resolve &HomepageWeb.NewsResolver.get_link/3
    end

    field :all_links, non_null(list_of(non_null(:link))) do
      resolve &HomepageWeb.NewsResolver.all_links/3
    end
  end

  mutation do
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :email, :string
      arg :password, :string

      resolve &HomepageWeb.UserResolver.update_user/3
    end
  end

  #field :all_links, non_null(list_of(non_null(:link))) do
    #resolve &HomepageWeb.NewsResolver.all_links/3
  #end

  #object :user do
    #field :id, non_null(:id)
    #field :email, non_null(:string)
  #end

  #query do
    #field :all_users, non_null(list_of(non_null(:user)))
  #end

  #field :all_users, non_null(list_of(non_null(:user))) do
    #resolve &UserResolver.all_users/3
  #end
end
