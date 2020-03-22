defmodule AphWeb.InvitationController do
  use AphWeb, :controller

  import Ecto.Query
  alias Aph.Repo
  import AphWeb.Authorize

  alias Aph.Accounts
  alias Aph.Accounts.Invitation

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:create, :for_user]

  def get(conn, %{"code" => code}) do
    invitation = Accounts.get_invitation_by_code(code)

    conn
    |> put_status(:ok)
    |> render(:show, invitation)
  end

  def create(%Plug.Conn{assigns: %{current_user: user}} = conn, _attrs) do
    # Get all existing invitations and check if the user is over their limit
    existing_invs =
      Repo.one(from(i in Invitation, where: i.created_by == ^user.id, select: count()))

    if existing_invs >= 10 do
      conn
      |> put_status(:unprocessable_entity)
      |> put_view(AphWeb.ErrorView)
      |> render(:resource_limit, message: "You can only have 10 invitations!")
    else
      inv = %{
        code: UUID.uuid4(),
        created_by: user.id
      }

      with {:ok, %Invitation{} = invitation} <- Accounts.create_invitation(inv) do
        conn
        |> put_status(:created)
        |> render(:show, invitation: invitation)
      end
    end
  end

  def for_user(%Plug.Conn{assigns: %{current_user: user}} = conn, _attrs) do
    query = from(i in Invitation, where: i.created_by == ^user.id, preload: :used_user)
    invitations = Repo.all(query)
    render(conn, :for_user, invitations: invitations)
  end
end
