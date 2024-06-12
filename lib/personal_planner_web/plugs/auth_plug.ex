defmodule PersonalPlannerWeb.AuthPlug do
  import Plug.Conn

  alias PersonalPlanner.Accounts

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
              login(conn, user)
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

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> remember(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> delete_resp_cookie("remember_token")
    |> configure_session(drop: true)
    |> assign(:current_user, nil)
  end

  def remember(conn, user) do
    token = PersonalPlanner.Token.gen_remember_token(user)
    put_resp_cookie(conn, "remember_token", token, max_age: @cookie_max_age)
  end

end
