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

  def food_log_factory do
    %Client.FoodLogs.FoodLog{
      name: sequence(:food_log, &"food-log-#{&1}"),
      owner_id: integer()
    }
  end

  def food_log_entry_factory do
    %Client.FoodLogs.Entry{
      description: sequence(:description, &"food-item-#{&1}"),
      user_id: integer(),
      food_log_id: uuid(),
      occurred_at: DateTime.utc_now()
    }
  end

  def water_log_factory do
    %Client.WaterLogs.WaterLog{
      name: sequence(:name, &"water log #{&1}"),
      user_id: integer()
    }
  end

  def water_log_entry_factory do
    %Client.WaterLogs.Entry{
      ml: integer(),
      user_id: integer(),
      water_log_id: uuid()
    }
  end

  def water_log_filter_factory do
    %Client.WaterLogs.Filter{
      water_log_id: insert(:water_log).id
    }
  end

  def soap_batch_factory do
    %Client.Soap.Batch{
      name: sequence(:name, &"soap batch #{&1}"),
      user_id: integer(),
      amount_produced: 1000
    }
  end

  def soap_order_factory do
    %Client.Soap.Order{
      name: sequence(:name, &"soap order #{&1}"),
      shipping_cost: Money.new(1500),
      tax: Money.new(300),
      user_id: integer()
    }
  end

  def soap_ingredient_factory do
    %Client.Soap.Ingredient{
      name: sequence(:name, &"soap ingredient #{&1}"),
      material_cost: 2000,
      overhead_cost: 500,
      total_cost: 2500,
      order_id: integer(),
      quantity: 200
    }
  end

  def soap_batch_ingredient_factory do
    %Client.Soap.BatchIngredient{
      name: sequence(:name, &"soap batch ingredient #{&1}"),
      amount_used: 100,
      material_cost: Money.new(1000)
    }
  end

  defp integer, do: System.unique_integer([:positive])
  defp uuid, do: Ecto.UUID.generate()
end
