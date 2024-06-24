defmodule PersonalPlannerWeb.TaskHTML do
  use PersonalPlannerWeb, :html

  alias PersonalPlanner.Task

  embed_templates "task_html/*"

  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :current_user_admin, :boolean, required: false

  def task_form(assigns)

  # def mount(_params, socket) do
  #   {:ok, assign(socket, :task, %Task{})}
  # end
end
