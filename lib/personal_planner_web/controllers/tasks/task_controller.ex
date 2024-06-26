defmodule PersonalPlannerWeb.TaskController do
  use PersonalPlannerWeb, :controller

  alias PersonalPlanner.Task
  alias PersonalPlanner.TaskService
  alias PersonalPlanner.Accounts
  alias PersonalPlannerWeb.AuthPlug

  plug :logged_in_user when action in [:index, :new, :edit, :update, :delete]

  def index(conn, params) do
    conn = AuthPlug.set_redirect_url(conn)
    with {:ok, {tasks, meta}} <- TaskService.list_tasks(params) do
      render(conn, :index, meta: meta, task: tasks, page_title: "Task List")
    end
  end

  #used for my tasklist
  def show(conn, params) do
    conn = AuthPlug.set_redirect_url(conn)
    with {:ok, {tasks, meta}} <- TaskService.my_list_tasks(params, conn.assigns.current_user.id) do
      render(conn, :my, meta: meta, task: tasks, page_title: "My Task List")
    end
  end

  def new(conn, _params) do
    users = fetch_users_for_dropdown()
    changeset = TaskService.change_task(%Task{})
    back_url = PersonalPlannerWeb.Endpoint.url() <> get_session(conn, :manual_forwarding_url)

    render(conn, :new, changeset: changeset, page_title: "Create Task", users: users, back_url: back_url)
  end

  def create(conn, %{"task" => task_params}) do

    #modify the user input slighly to morph it into the database schema better.
    task_params = Map.put(task_params, "creator_id", conn.assigns.current_user.id)

    case TaskService.create_task(task_params) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> AuthPlug.manual_redirect_or(~p"/tasks/")

      {:error, %Ecto.Changeset{} = changeset} ->
        users = fetch_users_for_dropdown()
        back_url = PersonalPlannerWeb.Endpoint.url() <> get_session(conn, :manual_forwarding_url)

        render(conn, :new, changeset: changeset, page_title: "Create Task", users: users, back_url: back_url)
    end
  end

  def edit(conn, %{"id" => id}) do
    users = fetch_users_for_dropdown()
    back_url = PersonalPlannerWeb.Endpoint.url() <> get_session(conn, :manual_forwarding_url)
    task = TaskService.get!(id)
    changeset = TaskService.change_task(task)
    render(conn, :edit, task: task, changeset: changeset, page_title: "Update Task | "  <> task.number, users: users, back_url: back_url)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = TaskService.get!(id)

    case TaskService.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task " <> task.number <> " updated successfully.")
        |> AuthPlug.manual_redirect_or(~p"/tasks/")

      {:error, %Ecto.Changeset{} = changeset} ->
        users = fetch_users_for_dropdown()
        back_url = PersonalPlannerWeb.Endpoint.url() <> get_session(conn, :manual_forwarding_url)
        render(conn, :edit,  task: task, changeset: changeset, page_title: "Update Task | "  <> task.number, users: users, back_url: back_url)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = TaskService.get!(id)
    {:ok, _task} = TaskService.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> AuthPlug.manual_redirect_or(~p"/tasks/")
  end

  def start(conn, %{"id" => id}) do
    task = TaskService.get!(id)
    task_params = %{
      assigned_to_id: conn.assigns.current_user.id,
      started_at: DateTime.utc_now()
    }
    case TaskService.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task " <> task.number <> " started.")
        |> AuthPlug.manual_redirect_or(~p"/tasks/")

      {:error, _} ->
        conn
        |> put_flash(:error, "Task " <> task.number <> " cannot start.")
        |> AuthPlug.manual_redirect_or(~p"/tasks/")
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
        |> AuthPlug.manual_redirect_or(~p"/tasks/")

      {:error, _} ->
        conn
        |> put_flash(:error, "Task " <> task.number <> " cannot be completed.")
        |> AuthPlug.manual_redirect_or(~p"/tasks/")
    end
  end

  def complete(conn, %{"id" => id}) do
    test = get_session(conn, :manual_forwarding_url)
    conn
    |> AuthPlug.manual_redirect_or(~p"/tasks/")
  end

  defp fetch_users_for_dropdown do
    users = Accounts.list_users_dropdown()
    [{"N/A", nil} | Enum.map(users, fn user -> {user.name, user.id} end)]
  end
end
