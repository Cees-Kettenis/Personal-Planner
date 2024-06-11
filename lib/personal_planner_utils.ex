defmodule PersonalPlannerWebUtils do
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
    gravatar_id = String.downcase(user.email) |> md5_hexdigest()
    ["https://secure.gravatar.com/avatar/", gravatar_id]
  end
end
