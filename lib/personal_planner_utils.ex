defmodule PersonalPlannerWebUtils do
  def formatDate(date, format \\ "{0D}/{0M}/{YYYY} {h24}:{m}") do
    if date != nil do
      date |> Timex.Timezone.convert(Timex.Timezone.local()) |> Timex.format!(format)
    else
      "Invalid Date"
    end
  end
end
