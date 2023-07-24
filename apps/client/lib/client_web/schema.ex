defmodule ClientWeb.Schema do
  use Absinthe.Schema
  import AbsintheErrorPayload.Payload
  import_types AbsintheErrorPayload.ValidationMessageTypes

  object :user do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
    field(:inserted_at, non_null(:string))
    field(:updated_at, non_null(:string))
  end

  object :login_jwt do
    field(:user, non_null(:user))
    field(:access_token, non_null(:string))
    field(:refresh_token, non_null(:string))
  end
  payload_object(:login_jwt_payload, :login_jwt)

  object :team do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
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
    field(:cost, :money)
    field(:ijust_context_id, non_null(:id))
    field(:inserted_at, non_null(:string))
    field(:updated_at, non_null(:string))
    field(:ijust_occurrences, list_of(:ijust_occurrence))
    field(:ijust_context, non_null(:ijust_context))
  end
  payload_object(:ijust_event_payload, :ijust_event)

  object :ijust_occurrence do
    field(:id, non_null(:id))
    field(:ijust_event, :ijust_event)
    field(:ijust_event_id, non_null(:id))
    field(:inserted_at, non_null(:string))
    field(:updated_at, non_null(:string))
    # virtual
    field(:is_deleted, :boolean)
  end

  object :twitch_user do
    field(:id, non_null(:id))
    field(:display_name, non_null(:string))
    field(:user_id, non_null(:string))
    field(:twitch_user_id, non_null(:string))
    field(:email, non_null(:string))
  end

  object :twitch_channel do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:user_id, non_null(:id))
    field(:inserted_at, non_null(:string))
    field(:updated_at, non_null(:string))
  end

  object :money do
    field(:amount, non_null(:integer))
    field(:currency, non_null(:string))
  end

  query do
    field :get_current_user, :user do
      resolve(&ClientWeb.SessionResolver.current_user/3)
    end

    field :get_user, :user do
      arg(:id, :id)
      arg(:email, :string)
      resolve(&ClientWeb.UserResolver.get_user/3)
    end

    field :get_one_time_login_link, :string do
      resolve(&ClientWeb.SessionResolver.get_one_time_login_link/3)
    end

    field :get_teams, list_of(:team) do
      resolve(&ClientWeb.TeamResolver.get_user_teams/3)
    end

    field :get_team, :team do
      arg(:id, non_null(:id))
      resolve(&ClientWeb.TeamResolver.get_team/3)
    end

    field :get_team_users, list_of(:user) do
      arg(:team_id, non_null(:id))
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

    field :ijust_events_search, list_of(:ijust_event) do
      arg(:name, non_null(:string))
      arg(:ijust_context_id, non_null(:id))
      resolve(&ClientWeb.IjustResolver.search_events/3)
    end

    field :get_twitch_user, :twitch_user do
      resolve(&Twitch.TwitchResolver.get_current_user/3)
    end

    field :get_twitch_channels, list_of(:twitch_channel) do
      resolve(&Twitch.TwitchResolver.get_channels/3)
    end

    field :get_twitch_channel, :twitch_channel do
      arg(:channel_name, non_null(:string))
      resolve(&Twitch.TwitchResolver.get_channel/3)
    end
  end

  mutation do
    field :signup, :login_jwt_payload do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&ClientWeb.UserResolver.signup/3)
      middleware(&build_payload/2)
    end

    field :login, :login_jwt_payload do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&ClientWeb.UserResolver.login/3)
      middleware(&build_payload/2)
    end

    field :refresh_token, :login_jwt_payload do
      arg(:refresh_token, non_null(:string))
      resolve(&ClientWeb.UserResolver.refresh_token/3)
      middleware(&build_payload/2)
    end

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

    field :update_ijust_event, :ijust_event_payload do
      arg(:id, non_null(:id))
      arg(:name, :string)
      arg(:cost, :integer)
      resolve(&ClientWeb.IjustResolver.update_ijust_event/3)
      middleware(&build_payload/2)
    end

    field :ijust_add_occurrence_to_event, :ijust_occurrence do
      arg(:ijust_event_id, non_null(:id))
      resolve(&ClientWeb.IjustResolver.add_occurrence_to_event/3)
    end

    field :ijust_delete_occurrence, :ijust_occurrence do
      arg(:ijust_occurrence_id, non_null(:id))
      resolve(&ClientWeb.IjustResolver.delete_occurrence/3)
    end

    field :twitch_remove_integration, :twitch_user do
      resolve(&Twitch.TwitchResolver.remove_integration/3)
    end

    field :twitch_channel_subscribe, :twitch_channel do
      arg(:channel, non_null(:string))
      resolve(&Twitch.TwitchResolver.channel_subscribe/3)
    end

    field :twitch_channel_unsubscribe, :twitch_channel do
      arg(:name, non_null(:string))
      resolve(&Twitch.TwitchResolver.channel_unsubscribe/3)
    end
  end
end
