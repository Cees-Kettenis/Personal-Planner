defmodule PersonalPlannerWeb.Router do
  use PersonalPlannerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PersonalPlannerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PersonalPlannerWeb.AuthPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PersonalPlannerWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/login", SessionController, :new
    post "/login", SessionController, :create, as: :login
    delete "/logout", SessionController, :delete, as: :logout
    get "/signup", UserController, :signup
    resources "/users", UserController
    resources "/account_activations", AccountActivationController
    resources "/password_resets", PasswordResetController, only: [:new, :create, :edit, :update]
    resources "/tasks", TaskController
    post "/tasks/:id/start", TaskController, :start
    post "/tasks/:id/complete", TaskController, :complete
    get "/tasks/mytasks", TaskController, :mytasks
  end

  # Other scopes may use custom stacks.
  # scope "/api", PersonalPlannerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:personal_planner, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PersonalPlannerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
