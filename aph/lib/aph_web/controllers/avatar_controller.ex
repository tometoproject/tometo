defmodule AphWeb.AvatarController do
  use AphWeb, :controller

  alias Aph.Main
  alias Aph.Main.Avatar
  alias AphWeb.Guardian

  action_fallback AphWeb.FallbackController

  def create(conn, %{
        "name" => name,
        "pitch" => pitch,
        "speed" => speed,
        "language" => language,
        "gender" => gender,
        "pic1" => pic1,
        "pic2" => pic2
      }) do
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    with {:ok, %Avatar{} = avatar} <-
           Main.create_avatar(
             %{
               name: name,
               pitch: pitch,
               speed: speed,
               language: language,
               gender: gender,
               user_id: user_id
             },
             pic1,
             pic2
           ) do
      conn
      |> put_status(:created)
      |> render(:show, avatar: avatar)
    end
  end

  def show(conn, %{"id" => id}) do
    if !is_number(id) do
      conn
      |> put_status(:bad_request)
      |> put_view(AphWeb.ErrorView)
      |> render(:"400", message: "Invalid Avatar ID!")
    end
    avatar = Main.get_avatar(id)
    render(conn, :show, avatar: avatar)
  end

  def update(conn, %{
        "id" => id,
        "name" => name,
        "pitch" => pitch,
        "speed" => speed,
        "language" => language,
        "gender" => gender,
        "pic1" => pic1,
        "pic2" => pic2
      }) do
    avatar = Main.get_avatar(id)
    %{id: user_id} = Guardian.Plug.current_resource(conn)

    if avatar.user_id != user_id do
      conn
      |> put_status(:unauthorized)
      |> put_view(AphWeb.ErrorView)
      |> render(:"401")
    end

    with {:ok, %Avatar{} = avatar} <-
           Main.update_avatar(
             avatar,
             %{
               id: id,
               name: name,
               pitch: pitch,
               speed: speed,
               language: language,
               gender: gender
             },
             pic1,
             pic2
           ) do
      render(conn, :show, avatar: avatar)
    end
  end

  def delete(conn, %{"id" => id}) do
    avatar = Main.get_avatar(id)

    with {:ok, %Avatar{}} <- Main.delete_avatar(avatar) do
      send_resp(conn, :no_content, "")
    end
  end
end
