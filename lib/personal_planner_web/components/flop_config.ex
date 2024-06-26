defmodule PersonalPlannerWeb.FlopConfig do

  def pagination_opts do
    [
      page_links: {:ellipsis, 3},
      ellipsis_content: Phoenix.HTML.raw("..."),
      ellipsis_attrs: [
        class: "p-2 mx-1 text-gray-400"
      ]
    ]
  end
end
