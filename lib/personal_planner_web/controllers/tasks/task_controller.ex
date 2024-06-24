defmodule PersonalPlannerWeb.TaskController do
  use PersonalPlannerWeb, :controller

  alias PersonalPlanner.Task
  alias PersonalPlanner.TaskService

  plug :logged_in_user when action in [:index, :show, :edit, :update]
  plug :is_user_admin when action in [:new, :delete]

  def index(conn, params) do
    with {:ok, {tasks, meta}} <- TaskService.list_tasks(params) do
      render(conn, :index, meta: meta, task: tasks, page_title: "Task List")
    end
  end

  def new(conn, _params) do
    changeset = TaskService.change_task(%Task{})
    render(conn, :new, changeset: changeset, page_title: "Create Task")
  end

  def create(conn, %{"task" => task_params}) do

    #modify the user input slighly to morph it into the database schema better.
    task_params = Map.put(task_params, "creator_id", conn.assigns.current_user.id)
    corrected_date = task_params["due_date"] <> " 00:00"
    task_params = Map.put(task_params, "due_date", corrected_date)

    case TaskService.create_task(task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: ~p"/tasks")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    task = TaskService.get!(id)
    changeset = TaskService.change_task(task)
    render(conn, :edit, task: task, changeset: changeset, page_title: "Update Task | "  <> task.number)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = TaskService.get!(id)
    corrected_date = task_params["due_date"] <> " 00:00"
    task_params = Map.put(task_params, "due_date", corrected_date)

    case TaskService.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/tasks")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit,  task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = TaskService.get!(id)
    {:ok, _task} = TaskService.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: ~p"/tasks")
  end

  # def signup(conn, _params) do
  #   changeset = Accounts.change_user(%User{})
  #   render(conn, :signup, changeset: changeset, page_title: "Sign up")
  # end
end
