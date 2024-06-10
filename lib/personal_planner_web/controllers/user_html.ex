defmodule PersonalPlannerWeb.UserHTML do
  use PersonalPlannerWeb, :html

  embed_templates "user_html/*"

  @doc """
  Renders a user form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def user_form(assigns)

  defp md5_hexdigest(str) do
    :crypto.hash(:md5, str)
    |> Base.encode16(case: :lower)
  end

  def gravatar_for(user) do
    gravatar_id = String.downcase(user.email) |> md5_hexdigest()
    ["https://secure.gravatar.com/avatar/", gravatar_id]
  end
end
