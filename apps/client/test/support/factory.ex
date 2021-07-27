defmodule Client.Factory do
  use ExMachina.Ecto, repo: Client.Repo

  def user_factory(attrs) do
    pw = Map.get(attrs, :password, "password123")
    {:ok, pw_hash} = Auth.hash_password(pw)

    user = %Client.User{
      email: "email-#{rand_string()}@t.co",
      password: pw,
      password_hash: pw_hash
    }

    merge_attributes(user, attrs)
  end

  def team_factory do
    %Client.Team{
      name: "team-#{rand_string()}"
    }
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
      name: "food-log-#{rand_string()}",
      owner_id: rand_int()
    }
  end

  def food_log_entry_factory do
    %Client.FoodLogs.Entry{
      description: sequence(:description, &"food-item-#{&1}"),
      user_id: rand_int(),
      food_log_id: uuid(),
      occurred_at: DateTime.utc_now()
    }
  end

  def water_log_factory do
    %Client.WaterLogs.WaterLog{
      name: sequence(:name, &"water log #{&1}"),
      user_id: rand_int()
    }
  end

  def water_log_entry_factory do
    %Client.WaterLogs.Entry{
      ml: rand_int(),
      user_id: rand_int(),
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
      user_id: rand_int(),
      amount_produced: 1000
    }
  end

  def soap_order_factory do
    %Client.Soap.Order{
      name: sequence(:name, &"soap order #{&1}"),
      shipping_cost: Money.new(1500),
      tax: Money.new(300),
      user_id: rand_int()
    }
  end

  def soap_ingredient_factory do
    %Client.Soap.Ingredient{
      name: sequence(:name, &"soap ingredient #{&1}"),
      material_cost: 2000,
      overhead_cost: 500,
      total_cost: 2500,
      order_id: rand_int(),
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

  def train_engine_factory do
    %Client.Trains.Engine{
      number: rand_int()
    }
  end

  def train_sighting_factory do
    now = DateTime.utc_now() |> DateTime.shift_zone!("America/New_York")

    %Client.Trains.Sighting{
      sighted_date: DateTime.to_date(now),
      sighted_time: DateTime.to_time(now),
      direction: "South",
      cars: 10
    }
  end

  def train_log_factory do
    %Client.Trains.Log{
      location: "Location #{rand_string()}"
    }
  end

  def storage_context_factory do
    %Client.Storage.Context{
      name: "Context #{rand_string()}"
    }
  end

  def storage_item_factory do
    %Client.Storage.Item{
      name: "Item #{rand_string()}",
      location: "Location #{rand_string()}"
    }
  end

  def rand_string(length \\ 16) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
  end

  def rand_int, do: System.unique_integer([:positive])
  defp uuid, do: Ecto.UUID.generate()
end
