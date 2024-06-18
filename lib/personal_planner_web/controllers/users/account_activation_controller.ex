defmodule PersonalPlannerWeb.AccountActivationController do
  use PersonalPlannerWeb, :controller

  alias PersonalPlanner.Accounts
  alias PersonalPlanner.Accounts.User
  alias PersonalPlannerWeb.AuthPlug

  def edit(conn, %{"id" => token}) do
    with {:ok, user_id} <- PersonalPlanner.Token.verify_activation_token(token),
        %User{activated: false} = user <- Accounts.get_user!(user_id),
        {:ok, %User{activated: true} = user} <- Accounts.activate_user(user) do
          conn
          |> PersonalPlannerWeb.AuthPlug.login(user, false)
          |> put_flash(:info, "Account Activated!")
          |> redirect(to: ~p"/users/#{user}")
        else
          _ ->
            conn
            |> put_flash(:error, "Invalid activation link")
            |> redirect(to: ~p"/")
        end
  end
end
