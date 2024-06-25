defmodule PersonalPlannerWeb.TaskHTML do
  use PersonalPlannerWeb, :html

  embed_templates "task_html/*"

  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :current_user_admin, :boolean, required: false
  attr :users, PersonalPlanner.Accounts.User, required: false


  def task_form(assigns)
end
