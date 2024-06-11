defmodule PersonalPlannerWeb.SessionController do
  use PersonalPlannerWeb, :controller

  alias PersonalPlanner.Accounts
  alias PersonalPlannerWeb.AuthPlug

  def new(conn, _params) do

    render(conn, :new, page_title: "Log In", form: %{"email" => "", "password" => "", "name" => ""})
  end

  def create(conn, %{"session" => session_params}) do
    IO.inspect(session_params["email"])
    IO.inspect(session_params["password"])

    case Accounts.authenticate_by_email_and_pass(
           String.downcase(session_params["email"]),
           session_params["password"]
         ) do
      {:ok, user} ->
        conn
        |> AuthPlug.login(user)
        |> put_flash(:info, "Welcome to PlanCraft " <> user.name)
        |> redirect(to: ~p"/users/#{user}")
      # Log the user in and redirect to the user's show page.
      {:error, _reason} ->
        conn
        # Create an error message.
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html", page_title: "Log In", form: %{"email" => "", "password" => "", "name" => ""})
    end
  end

  def delete(conn, _params) do
    conn |> AuthPlug.logout() |> redirect(to: ~p"/")

  end
end
