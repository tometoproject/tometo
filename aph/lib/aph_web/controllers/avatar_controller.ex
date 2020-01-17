defmodule AphWeb.AvatarController do
  use AphWeb, :controller

  import AphWeb.Authorize

  alias Aph.Main
  alias Aph.Main.Avatar

  action_fallback AphWeb.FallbackController

  plug :user_check when action in [:create, :update, :delete]

  def create(%Plug.Conn{assigns: %{current_user: user}} = conn, %{
        "name" => name,
        "pitch" => pitch,
        "speed" => speed,
        "language" => language,
        "gender" => gender,
        "pic1" => pic1,
        "pic2" => pic2
      }) do
    if is_bitstring(pic1) == 0 or is_bitstring(pic2) == 0 do
      conn
      |> put_status(:bad_request)
      |> put_view(AphWeb.ErrorView)
      |> render(:insufficient_input, message: "Please attach two images!")
    else
      with {:ok, %Avatar{} = avatar} <-
             Main.create_avatar(
               %{
                 name: name,
                 pitch: pitch,
                 speed: speed,
                 language: language,
                 gender: gender,
                 user_id: user.id
               },
               pic1,
               pic2
             ) do
        conn
        |> put_status(:created)
        |> render(:show, avatar: avatar)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    avatar = Main.get_avatar(id)
    render(conn, :show, avatar: avatar)
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{
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

    if avatar.user_id != user.id do
      conn
      |> put_status(:unauthorized)
      |> put_view(AphWeb.ErrorView)
      |> render(:wrong_user)
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
