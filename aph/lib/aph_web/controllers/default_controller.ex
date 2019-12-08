defmodule AphWeb.DefaultController do
  use AphWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "Hello world!"})
  end
end
