defmodule PersonalPlannerWeb.PasswordResetHTML do
  use PersonalPlannerWeb, :html

  embed_templates "password_reset_html/*"

  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def password_reset_form(assigns)
end
