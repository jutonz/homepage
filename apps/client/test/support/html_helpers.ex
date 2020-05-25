defmodule ClientWeb.HtmlHelpers do
  import ExUnit.Assertions, only: [assert: 1]

  def assert_contains(html, css_selector) do
    ele =
      html
      |> Floki.parse_document!()
      |> Floki.find(css_selector)

    assert [ele] = ele
    ele
  end
end
