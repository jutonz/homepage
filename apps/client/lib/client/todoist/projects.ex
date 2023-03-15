defmodule Client.Todoist.Projects do
  @base_url "https://api.todoist.com"
  @path "/rest/v2/projects"

  alias Client.Todoist.Request

  def list do
    :get
    |> Request.build(@base_url <> @path)
    |> Request.put_auth_header()
    |> Request.put_json_header()
  end
end
