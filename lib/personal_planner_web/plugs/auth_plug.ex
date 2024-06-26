defmodule PersonalPlannerWeb.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller

  alias PersonalPlanner.Accounts
  use Phoenix.VerifiedRoutes,
  endpoint: PersonalPlannerWeb.Endpoint,
  router: PersonalPlannerWeb.Router

  @cookie_max_age 604800

  def init(opts), do: opts

  # def call(conn, _opts) do
  #   user_id = get_session(conn, :user_id)
  #   user = user_id && Accounts.get_user!(user_id)
  #   assign(conn, :current_user, user)
  # end

  def call(conn, _opts) do
    cond do
      conn.assigns[:current_user] -> conn
      user_id = get_session(conn, :user_id) ->
        assign(conn, :current_user, Accounts.get_user!(user_id))

      token = conn.cookies["remember_token"] ->
        case PersonalPlanner.Token.verify_remember_token(token) do
          {:ok, user_id} ->
            if user = Accounts.get_user!(user_id) do
              login(conn, user, true) #since we have a remember token when we login we of course want to remember it.
            else
              logout(conn)
            end

          {:error, _reason} ->
            logout(conn)
        end

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user, remember_login) do
    conn
    |> assign(:current_user, user)
    |> remember(user, remember_login) #i do not know how to do if else with pipe so i pass it along to the remember function.
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> delete_resp_cookie("remember_token")
    |> configure_session(drop: true)
    |> assign(:current_user, nil)
  end

  def remember(conn, user, remember_login) do
    #if we want to remember our login with a cookie then we generate the token.
    #otherwise we want to just return the con to continue the chain above
    if remember_login do
      token = PersonalPlanner.Token.gen_remember_token(user)
      conn |> put_resp_cookie("remember_token", token, max_age: @cookie_max_age)
    else
      conn
    end
  end

  def set_redirect_url(conn) do
    conn = put_session(conn, :manual_forwarding_url, conn.request_path)
  end

  def manual_redirect_or(conn, default) do
    path =  get_session(conn, :manual_forwarding_url) || default
    conn
    |> delete_session(:manual_forwarding_url)
    |> redirect(to: path)
  end

  def redirect_back_or(conn, default) do
    path = get_session(conn, :forwarding_url) || default

    conn
    |> delete_session(:forwarding_url)
    |> redirect(to: path)
  end

  def store_location(conn) do
    case conn do
      %Plug.Conn{method: "GET"} ->
        put_session(conn, :forwarding_url, conn.request_path)

        _ ->
          IO.inspect("not storing")
          conn
    end
  end

  def logged_in_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> store_location()
      |> put_flash(:error, "Please log in.")
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end

  def is_user_admin(conn, _opts) do
    if conn.assigns.current_user.admin do
      conn
    else
      conn
      |> put_flash(:error, "You are not admin, please contact admin if you need something changed.")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end

  def is_user_updating_themselves_or_admin(conn, _opts) do
    user_id = String.to_integer(conn.params["id"])
    if conn.assigns.current_user.id == user_id || conn.assigns.current_user.admin do
      conn
    else
      conn
      |> put_flash(:error, "You are not admin, you cannot update other users.")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
