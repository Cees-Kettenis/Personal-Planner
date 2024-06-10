defmodule PersonalPlannerWeb.SessionController do
  use PersonalPlannerWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html", page_title: "Log In")
  end

  def create(conn, _params) do
    render(conn, "new.html", page_title: "Log In")
  end

  def delete(conn, _params) do
    render(conn, "new.html", page_title: "Log Out")
  end
end
