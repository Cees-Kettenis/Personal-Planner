defmodule PersonalPlannerWeb.TaskController do
  use PersonalPlannerWeb, :controller

  alias PersonalPlanner.Task
  alias PersonalPlanner.TaskService
  alias PersonalPlanner.Accounts

  plug :logged_in_user when action in [:index, :new, :edit, :update, :delete]

  def index(conn, params) do
    with {:ok, {tasks, meta}} <- TaskService.list_tasks(params) do
      render(conn, :index, meta: meta, task: tasks, page_title: "Task List")
    end
  end

  def new(conn, _params) do
    users = fetch_users_for_dropdown()
    changeset = TaskService.change_task(%Task{})
    render(conn, :new, changeset: changeset, page_title: "Create Task", users: users)
  end

  def create(conn, %{"task" => task_params}) do

    #modify the user input slighly to morph it into the database schema better.
    task_params = Map.put(task_params, "creator_id", conn.assigns.current_user.id)

    case TaskService.create_task(task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: ~p"/tasks")

      {:error, %Ecto.Changeset{} = changeset} ->
        users = fetch_users_for_dropdown()
        render(conn, :new, changeset: changeset, page_title: "Create Task", users: users)
    end
  end

  def edit(conn, %{"id" => id}) do
    users = fetch_users_for_dropdown()

    task = TaskService.get!(id)
    changeset = TaskService.change_task(task)
    render(conn, :edit, task: task, changeset: changeset, page_title: "Update Task | "  <> task.number, users: users)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = TaskService.get!(id)

    case TaskService.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task " <> task.number <> " updated successfully.")
        |> redirect(to: ~p"/tasks")

      {:error, %Ecto.Changeset{} = changeset} ->
        users = fetch_users_for_dropdown()
        render(conn, :edit,  task: task, changeset: changeset, page_title: "Update Task | "  <> task.number, users: users)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = TaskService.get!(id)
    {:ok, _task} = TaskService.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: ~p"/tasks")
  end

  def start(conn, %{"id" => id}) do
    task = TaskService.get!(id)
    task_params = %{
      started_at: DateTime.utc_now()
    }
    case TaskService.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task " <> task.number <> " started.")
        |> redirect(to: ~p"/tasks")

      {:error, _} ->
        conn
        |> put_flash(:error, "Task " <> task.number <> " cannot start.")
        |> redirect(to: ~p"/tasks")
    end
  end

  def complete(conn, %{"id" => id}) do
    task = TaskService.get!(id)
    task_params = %{
      completed_at: DateTime.utc_now()
    }
    case TaskService.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task " <> task.number <> " completed.")
        |> redirect(to: ~p"/tasks")

      {:error, _} ->
        conn
        |> put_flash(:error, "Task " <> task.number <> " cannot be completed.")
        |> redirect(to: ~p"/tasks")
    end
  end

  defp fetch_users_for_dropdown do
    users = Accounts.list_users_dropdown()
    [{"N/A", nil} | Enum.map(users, fn user -> {user.name, user.id} end)]
  end
end
