defmodule Client.Todoist do
  alias Client.{
    Todoist,
    Todoist.Request
  }

  def get_projects do
    Todoist.Projects.list()
    |> Request.request()
  end

  def create_task(body \\ %{}) do
    Todoist.Tasks.create(body)
    |> Request.request()
  end

  def create_laundry_task do
    due_at =
      DateTime.utc_now()
      |> DateTime.add(90, :minute)
      |> DateTime.to_iso8601()

    body = %{
      content: "Finish laundry",
      due_datetime: due_at
    }

    create_task(body)
  end
end
