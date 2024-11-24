defmodule CbtestWeb.Controllers.PageController do
  use CbtestWeb, :controller

  def index(conn, _params) do
    IO.inspect(conn.cookies)
    render(conn, :index)
  end
end
