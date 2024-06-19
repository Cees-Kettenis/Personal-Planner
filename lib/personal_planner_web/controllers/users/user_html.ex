defmodule PersonalPlannerWeb.UserHTML do
  use PersonalPlannerWeb, :html

  embed_templates "user_html/*"

  @doc """
  Renders a user form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :current_user_admin, :boolean, required: false

  def user_form(assigns)
end
