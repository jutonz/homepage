defmodule ClientWeb.Schema do
  use Absinthe.Schema

  object :user do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
    field(:inserted_at, non_null(:string))
    field(:updated_at, non_null(:string))
  end

  object :team do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:slug, non_null(:string))
    field(:inserted_at, non_null(:string))
    field(:updated_at, non_null(:string))
  end

  object :ijust_context do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:user_id, non_null(:id))
    field(:account_id, non_null(:id))
    field(:inserted_at, non_null(:string))
    field(:updated_at, non_null(:string))
  end

  object :ijust_event do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:count, non_null(:integer))
    field(:ijust_context_id, non_null(:id))
    field(:inserted_at, non_null(:string))
    field(:updated_at, non_null(:string))
  end

  object :ijust_occurrence do
    field(:id, non_null(:id))
    field(:ijust_event_id, non_null(:id))
    field(:inserted_at, non_null(:string))
    field(:updated_at, non_null(:string))
    # virtual
    field(:is_deleted, :boolean)
  end

  query do
    field :get_user, :user do
      arg(:id, :id)
      arg(:email, :string)
      resolve(&ClientWeb.UserResolver.get_user/3)
    end

    field :check_session, :boolean do
      resolve(&ClientWeb.SessionResolver.check_session/3)
    end

    field :get_one_time_login_link, :string do
      resolve(&ClientWeb.SessionResolver.get_one_time_login_link/3)
    end

    field :get_teams, list_of(:team) do
      resolve(&ClientWeb.TeamResolver.get_user_teams/3)
    end

    field :get_team, :team do
      arg(:slug, non_null(:string))
      resolve(&ClientWeb.TeamResolver.get_team/3)
    end

    field :get_team_users, list_of(:user) do
      arg(:slug, non_null(:string))
      resolve(&ClientWeb.TeamResolver.get_team_users/3)
    end

    field :get_team_user, :user do
      arg(:team_id, non_null(:id))
      arg(:user_id, non_null(:id))
      resolve(&ClientWeb.TeamResolver.get_team_user/3)
    end

    field :get_ijust_default_context, :ijust_context do
      resolve(&ClientWeb.IjustResolver.get_ijust_default_context/3)
    end

    field :get_ijust_contexts, list_of(:ijust_context) do
      resolve(&ClientWeb.IjustResolver.get_ijust_contexts/3)
    end

    field :get_ijust_context, :ijust_context do
      arg(:id, non_null(:id))
      resolve(&ClientWeb.IjustResolver.get_ijust_context/3)
    end

    field :get_ijust_recent_events, list_of(:ijust_event) do
      arg(:context_id, non_null(:id))
      resolve(&ClientWeb.IjustResolver.get_recent_events/3)
    end

    field :get_ijust_context_event, :ijust_event do
      arg(:context_id, non_null(:id))
      arg(:event_id, non_null(:id))
      resolve(&ClientWeb.IjustResolver.get_context_event/3)
    end

    field :get_ijust_event_occurrences, list_of(:ijust_occurrence) do
      arg(:event_id, non_null(:id))
      arg(:offset, :integer, default_value: 0)
      resolve(&ClientWeb.IjustResolver.get_event_occurrences/3)
    end
  end

  mutation do
    field :update_user, :user do
      arg(:id, non_null(:id))
      arg(:email, :string)
      arg(:password, :string)
      resolve(&ClientWeb.UserResolver.update_user/3)
    end

    field :change_password, :user do
      arg(:current_password, non_null(:string))
      arg(:new_password, non_null(:string))
      resolve(&ClientWeb.UserResolver.change_password/3)
    end

    field :create_team, :team do
      arg(:name, non_null(:string))
      resolve(&ClientWeb.TeamResolver.create_team/3)
    end

    field :delete_team, :team do
      arg(:id, non_null(:id))
      resolve(&ClientWeb.TeamResolver.delete_team/3)
    end

    field :rename_team, :team do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))
      resolve(&ClientWeb.TeamResolver.rename_team/3)
    end

    field :join_team, :team do
      arg(:name, non_null(:string))
      resolve(&ClientWeb.TeamResolver.join_team/3)
    end

    field :leave_team, :team do
      arg(:id, non_null(:id))
      resolve(&ClientWeb.TeamResolver.leave_team/3)
    end

    field :create_ijust_event, :ijust_event do
      arg(:ijust_context_id, non_null(:id))
      arg(:name, non_null(:string))
      resolve(&ClientWeb.IjustResolver.create_ijust_event/3)
    end

    field :ijust_add_occurrence_to_event, :ijust_occurrence do
      arg(:ijust_event_id, non_null(:id))
      resolve(&ClientWeb.IjustResolver.add_occurrence_to_event/3)
    end

    field :ijust_delete_occurrence, :ijust_occurrence do
      arg(:ijust_occurrence_id, non_null(:id))
      resolve(&ClientWeb.IjustResolver.delete_occurrence/3)
    end
  end
end
