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

  @cj_shared_project_id "2295573986"
  def create_laundry_task do
    due_at =
      DateTime.utc_now()
      |> DateTime.add(120, :minute)
      |> DateTime.to_iso8601()

    body = %{
      content: "Finish laundry",
      project_id: @cj_shared_project_id,
      due_datetime: due_at
    }

    create_task(body)
  end
end
