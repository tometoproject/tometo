defmodule AphWeb.InvitationController do
  use AphWeb, :controller

  alias Aph.Accounts
  alias Aph.Accounts.Invitation

  action_fallback AphWeb.FallbackController

  def index(conn, _params) do
    invitations = Accounts.list_invitations()
    render(conn, "index.json", invitations: invitations)
  end

  def create(conn, %{"invitation" => invitation_params}) do
    with {:ok, %Invitation{} = invitation} <- Accounts.create_invitation(invitation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.invitation_path(conn, :show, invitation))
      |> render("show.json", invitation: invitation)
    end
  end

  def show(conn, %{"id" => id}) do
    invitation = Accounts.get_invitation!(id)
    render(conn, "show.json", invitation: invitation)
  end

  def update(conn, %{"id" => id, "invitation" => invitation_params}) do
    invitation = Accounts.get_invitation!(id)

    with {:ok, %Invitation{} = invitation} <- Accounts.update_invitation(invitation, invitation_params) do
      render(conn, "show.json", invitation: invitation)
    end
  end

  def delete(conn, %{"id" => id}) do
    invitation = Accounts.get_invitation!(id)

    with {:ok, %Invitation{}} <- Accounts.delete_invitation(invitation) do
      send_resp(conn, :no_content, "")
    end
  end
end
