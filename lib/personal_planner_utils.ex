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

  defp md5_hexdigest(str) do
    :crypto.hash(:md5, str)
    |> Base.encode16(case: :lower)
  end

  def gravatar_for(user) do
    if user do
      #TODO implement user image logic so that images can be stored in house instead on gravatar
      gravatar_id = String.downcase(user.email) |> md5_hexdigest()
      ["https://secure.gravatar.com/avatar/", gravatar_id]
    else
      PersonalPlannerWeb.Endpoint.url() <> "/images/default-user.png"
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
