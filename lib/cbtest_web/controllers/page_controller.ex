defmodule CbtestWeb.Controllers.PageController do
  use CbtestWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
