defmodule PersonalPlannerWeb.UserController do
  use PersonalPlannerWeb, :controller

  alias PersonalPlanner.Accounts
  alias PersonalPlanner.Accounts.User

  plug :logged_in_user when action in [:index, :show]
  plug :is_user_admin when action in [:new, :delete]
  plug :is_user_updating_themselves_or_admin when action in [:edit, :update]

  def index(conn, params) do
    with {:ok, {users, meta}} <- Accounts.list_users(params) do
      render(conn, :index, meta: meta, users: users, page_title: "User Management")
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset, page_title: "Create User")
  end



  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/login")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user, page_title: "View user | " <> user.name)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, :edit, user: user, changeset: changeset, page_title: "Update User | "  <> user.name)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end

  def signup(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :signup, changeset: changeset, page_title: "Sign up")
  end
end
