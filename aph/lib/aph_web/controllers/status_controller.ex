defmodule AphWeb.StatusController do
  use AphWeb, :controller

  alias Aph.Main
  alias Aph.Repo
  alias Aph.Main.Status
  alias AphWeb.Guardian

  action_fallback AphWeb.FallbackController

  def index(conn, _params) do
    statuses = Main.list_statuses()
    render(conn, "index.json", statuses: statuses)
  end

  def create(conn, %{"content" => content, "id" => id}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    with other_status when is_nil(other_status) == false <- Repo.get(Status, id) do
      if !other_status.related_status_id do
        with {:ok, status} <-
               Main.create_status(user_id, %{content: content, related_status_id: id}) do
          conn
          |> put_status(:created)
          |> render(:show, status: status)
        end
      else
        conn
        |> put_status(:bad_request)
        |> put_view(AphWeb.ErrorView)
        |> render(:"400", message: "You can't comment on a comment!")
      end
    else
      nil ->
        conn
        |> put_status(:bad_request)
        |> put_view(AphWeb.ErrorView)
        |> render(:"400", message: "Nonexistent related status ID!")
    end
  end

  def create(conn, %{"content" => content}) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    with {:ok, %Status{} = status} <- Main.create_status(user_id, %{content: content}) do
      conn
      |> put_status(:created)
      |> render(:show, status: status)
    else
      {:error, err} ->
        conn
        |> put_status(:internal_server_error)
        |> put_view(AphWeb.ErrorView)
        |> render(:"500", message: err)
    end
  end

  def show(conn, %{"id" => id}) do
    status = Main.get_status_for_display!(id)
    render(conn, :show_display, status: status)
  end

  def show_comments(conn, %{"id" => id}) do
    comments = Main.get_status_comments!(id)
    render(conn, :index_display, statuses: comments)
  end

  def update(conn, %{"id" => id, "status" => status_params}) do
    status = Main.get_status!(id)

    with {:ok, %Status{} = status} <- Main.update_status(status, status_params) do
      render(conn, "show.json", status: status)
    end
  end

  def delete(conn, %{"id" => id}) do
    status = Main.get_status!(id)

    with {:ok, %Status{}} <- Main.delete_status(status) do
      send_resp(conn, :no_content, "")
    end
  end
end
