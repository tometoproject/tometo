defmodule AphWeb.PageController do
  use AphWeb, :controller
  plug :put_layout, false

  def index(conn, attrs \\ %{}) do
    render(conn, "index.html")
  end

  def admin(conn, attrs \\ %{}) do
    render(conn, "admin.html")
  end
end
