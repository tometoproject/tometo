defmodule AphWeb.AvatarControllerTest do
  use AphWeb.ConnCase

  alias Aph.Main
  alias Aph.Main.Avatar

  @create_attrs %{
    gender: "some gender",
    language: "some language",
    name: "some name",
    pitch: 42,
    speed: 120.5
  }
  @update_attrs %{
    gender: "some updated gender",
    language: "some updated language",
    name: "some updated name",
    pitch: 43,
    speed: 456.7
  }
  @invalid_attrs %{gender: nil, language: nil, name: nil, pitch: nil, speed: nil}

  def fixture(:avatar) do
    {:ok, avatar} = Main.create_avatar(@create_attrs)
    avatar
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all avatars", %{conn: conn} do
      conn = get(conn, Routes.avatar_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create avatar" do
    test "renders avatar when data is valid", %{conn: conn} do
      conn = post(conn, Routes.avatar_path(conn, :create), avatar: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.avatar_path(conn, :show, id))

      assert %{
               "id" => id,
               "gender" => "some gender",
               "language" => "some language",
               "name" => "some name",
               "pitch" => 42,
               "speed" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.avatar_path(conn, :create), avatar: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update avatar" do
    setup [:create_avatar]

    test "renders avatar when data is valid", %{conn: conn, avatar: %Avatar{id: id} = avatar} do
      conn = put(conn, Routes.avatar_path(conn, :update, avatar), avatar: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.avatar_path(conn, :show, id))

      assert %{
               "id" => id,
               "gender" => "some updated gender",
               "language" => "some updated language",
               "name" => "some updated name",
               "pitch" => 43,
               "speed" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, avatar: avatar} do
      conn = put(conn, Routes.avatar_path(conn, :update, avatar), avatar: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete avatar" do
    setup [:create_avatar]

    test "deletes chosen avatar", %{conn: conn, avatar: avatar} do
      conn = delete(conn, Routes.avatar_path(conn, :delete, avatar))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.avatar_path(conn, :show, avatar))
      end
    end
  end

  defp create_avatar(_) do
    avatar = fixture(:avatar)
    {:ok, avatar: avatar}
  end
end
