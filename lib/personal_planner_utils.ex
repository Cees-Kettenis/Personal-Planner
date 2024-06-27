defmodule PersonalPlannerWebUtils do
  use Phoenix.VerifiedRoutes,
  endpoint: PersonalPlannerWeb.Endpoint,
  router: PersonalPlannerWeb.Router

  def formatDate(date, format \\ "{0D}/{0M}/{YYYY} {h24}:{m}") do
    if date != nil do
      date |> Timex.Timezone.convert(Timex.Timezone.local()) |> Timex.format!(format)
    else
      "Invalid Date"
    end
  end

  def gravatar_for(user \\ nil) do
    if user && user.image_url && String.length(user.image_url) > 0 do
      PersonalPlannerWeb.Endpoint.url() <> user.image_url
    else
      PersonalPlannerWeb.Endpoint.url() <> "/images/uploads/default-user.png"
    end

  end

  def truncate_string(str, cuttoff \\ 30) do
    if String.length(str) <= cuttoff do
      str
    else
      String.slice(str, 0..cuttoff) <> "..."
    end
  end

  def date_status(start_date, end_date) do
    case {start_date, end_date} do
      {nil, nil} -> "Pending"
      {_, nil} -> "In Progress"
      {_, _} -> "Complete"
    end
  end
end
