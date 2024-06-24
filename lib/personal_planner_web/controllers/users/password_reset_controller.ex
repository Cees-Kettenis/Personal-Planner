defmodule PersonalPlannerWeb.PasswordResetController do
  use PersonalPlannerWeb, :controller

  alias PersonalPlanner.Accounts
  alias PersonalPlanner.Accounts.User

  plug :valid_user when action in [:edit, :update]

  def new(conn, _params) do
    render(conn, :new, page_title: "Forgot Password", form: %{})
  end

  def create(conn, %{"session" => session_params}) do
    email = session_params["email"]

    with %User{} = user <- Accounts.get_user_by!([email: email]) do
      reset_token = PersonalPlanner.Token.gen_password_reset_token(user)
      PersonalPlanner.SendEmail.password_reset_email(user, reset_token) |> PersonalPlanner.Mailer.deliver()

      conn
      |> put_flash(:info, "Email sent with password reset instructions")
      |> redirect(to: ~p"/")
    else
      _ ->
        conn
        |> put_flash(:error, "Email address not found")
        |> render(:new, page_title: "Forgot Password", form: %{})
    end
  end

  def edit(conn, _params) do
    user = conn.assigns.user
    changeset = PersonalPlanner.Accounts.password_change_user(user)
    render(conn, :edit, page_title: "Reset Password", changeset: changeset)
  end

  def update(conn,   %{"id" => _id, "user" => user_params}) do
    user = conn.assigns.user

    case PersonalPlanner.Accounts.password_change_user(user, user_params) do
      {:ok, user} ->
        conn
        |> PersonalPlannerWeb.AuthPlug.login(user, false)
        |> put_flash(:info, "Password has been reset")
        |> redirect(to: ~p"/users/#{user}/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset, page_title: "Reset Password")
    end
  end

  defp valid_user(conn, _opts) do
    with %{"id" => token} <- conn.params,
         {:ok, user_id} <- PersonalPlanner.Token.verify_password_reset_token(token),
         %User{activated: true} = user <- Accounts.get_user!(user_id) do
      assign(conn, :user, user)
    else
      {:error, :expired} ->
        conn
        |> put_flash(:error, "Password reset has expired.")
        |> redirect(to: ~p"/password_resets/new")
        |> halt()

      _ ->
        conn
        |> redirect(to: ~p"/")
        |> halt()
    end
  end
end
