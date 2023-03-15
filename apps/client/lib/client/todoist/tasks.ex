defmodule Client.Todoist.Tasks do
  @base_url "https://api.todoist.com"
  @path "/rest/v2/tasks"

  alias Client.Todoist.Request

  # https://developer.todoist.com/rest/v2/#create-a-new-task
  @spec create(map) :: Request.t()
  def create(body) do
    :post
    |> Request.build(@base_url <> @path)
    |> Request.put_auth_header()
    |> Request.put_json_header()
    |> Request.put_json_body(body)
  end
end
