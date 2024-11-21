defmodule CbtestWeb.Controllers.Landing.LandingController do
  use CbtestWeb, :controller

  def index(conn, _params) do
    render(conn, :index, layout: false)
  end
end
