defmodule AphWeb.InvitationControllerTest do
  use AphWeb.ConnCase

  alias Aph.Accounts
  alias Aph.Accounts.Invitation

  @create_attrs %{
    code: "some code"
  }
  @update_attrs %{
    code: "some updated code"
  }
  @invalid_attrs %{code: nil}

  def fixture(:invitation) do
    {:ok, invitation} = Accounts.create_invitation(@create_attrs)
    invitation
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all invitations", %{conn: conn} do
      conn = get(conn, Routes.invitation_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create invitation" do
    test "renders invitation when data is valid", %{conn: conn} do
      conn = post(conn, Routes.invitation_path(conn, :create), invitation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.invitation_path(conn, :show, id))

      assert %{
               "id" => id,
               "code" => "some code"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.invitation_path(conn, :create), invitation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update invitation" do
    setup [:create_invitation]

    test "renders invitation when data is valid", %{conn: conn, invitation: %Invitation{id: id} = invitation} do
      conn = put(conn, Routes.invitation_path(conn, :update, invitation), invitation: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.invitation_path(conn, :show, id))

      assert %{
               "id" => id,
               "code" => "some updated code"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, invitation: invitation} do
      conn = put(conn, Routes.invitation_path(conn, :update, invitation), invitation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete invitation" do
    setup [:create_invitation]

    test "deletes chosen invitation", %{conn: conn, invitation: invitation} do
      conn = delete(conn, Routes.invitation_path(conn, :delete, invitation))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.invitation_path(conn, :show, invitation))
      end
    end
  end

  defp create_invitation(_) do
    invitation = fixture(:invitation)
    {:ok, invitation: invitation}
  end
end
