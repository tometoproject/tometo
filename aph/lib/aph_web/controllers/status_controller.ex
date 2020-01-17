defmodule AphWeb.StatusController do
  use AphWeb, :controller

  import AphWeb.Authorize

  alias Aph.Main
  alias Aph.Repo
  alias Aph.Main.Status

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:create]

  def create(%Plug.Conn{assigns: %{current_user: user}} = conn, %{
        "content" => content,
        "parent_id" => id
      }) do
    with other_status when is_nil(other_status) == false <- Repo.get(Status, id) do
      if !other_status.related_status_id do
        with {:ok, status} <-
               Main.create_status(user.id, %{content: content, related_status_id: id}) do
          conn
          |> put_status(:created)
          |> render(:created, status: status)
        end
      else
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(AphWeb.ErrorView)
        |> render(:invalid_input, message: "You can't comment on a comment!")
      end
    else
      nil ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(AphWeb.ErrorView)
        |> render(:invalid_input, message: "Nonexistent related status ID!")
    end
  end

  def create(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"content" => content}) do
    with {:ok, %Status{} = status} <- Main.create_status(user.id, %{content: content}) do
      conn
      |> put_status(:created)
      |> render(:created, status: status)
    else
      {:error, err} ->
        conn
        |> put_status(:internal_server_error)
        |> put_view(AphWeb.ErrorView)
        |> render(:internal_error, message: err)
    end
  end

  def show(conn, %{"id" => id}) do
    status = Main.get_status(id)
    render(conn, :show, status: status)
  end

  def show_comments(conn, %{"id" => id}) do
    comments = Main.get_status_comments(id)
    render(conn, :index, statuses: comments)
  end
end
