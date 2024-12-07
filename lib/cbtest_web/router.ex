defmodule CbtestWeb.Router do
  use CbtestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CbtestWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_session_id
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CbtestWeb do
    pipe_through :browser

    get "/", Controllers.PageController, :index
    live "/test", Live.Test.TestLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", CbtestWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:cbtest, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CbtestWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp assign_session_id(conn, _) do
    if get_session(conn, :session_id) do
      # If the session_id is already set, don't replace it.
      conn
    else
      session_id = Ecto.UUID.generate()
      conn |> put_session(:session_id, session_id)
    end
  end
end
