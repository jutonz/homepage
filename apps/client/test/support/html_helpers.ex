defmodule ClientWeb.HtmlHelpers do
  import ExUnit.Assertions, only: [assert: 1]

  def assert_contains_selector(parsed_html, css_selector) do
    parsed_html =
      case parsed_html do
        string when is_binary(string) ->
          Floki.parse_document!(parsed_html)

        _ ->
          parsed_html
      end

    ele = Floki.find(parsed_html, css_selector)

    assert [ele] = ele
    ele
  end

  def parsed_html_response(conn, status) do
    conn |> Phoenix.ConnTest.html_response(status) |> Floki.parse_document!()
  end
end
