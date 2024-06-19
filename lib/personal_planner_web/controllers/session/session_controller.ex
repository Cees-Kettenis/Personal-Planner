defmodule PersonalPlannerWeb.SessionController do
  use PersonalPlannerWeb, :controller

  alias PersonalPlanner.Accounts
  alias PersonalPlannerWeb.AuthPlug

  def new(conn, _params) do

    render(conn, :new, page_title: "Log In", form: %{})
  end

  def create(conn, %{"session" => session_params}) do
    #make sure that the remember me option is enabled and pass it to the login function
    remember_me = String.to_atom(session_params["rememberme"])

    case Accounts.authenticate_by_email_and_pass(
           String.downcase(session_params["email"]),
           session_params["password"]
         ) do
      {:ok, user} ->
        #if the user is active we want to log in.
        if user.activated do
          conn
          |> AuthPlug.login(user, remember_me)
          |> put_flash(:info, "Welcome to PlanCraft " <> user.name)
          |> AuthPlug.redirect_back_or(~p"/users/#{user}")
        else
          #we want to redirect them to the home page with a message to activate thier account.
          conn |> put_flash(:error, "Hello #{user.name}, Please activate your account before trying to log. Please check your email!" )
               |> redirect(to: ~p"/")
        end
        {:error, _reason} ->
          conn
          |> put_flash(:error, "Invalid email/password combination")
          |> redirect(to: ~p"/")
    end
  end

  def delete(conn, _params) do
    conn |> AuthPlug.logout() |> redirect(to: ~p"/")

  end
end
