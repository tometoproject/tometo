defmodule AphWeb.AvatarView do
  use AphWeb, :view
  alias AphWeb.AvatarView

  def render("show.json", %{avatar: avatar}) do
    render_one(avatar, AvatarView, "avatar.json")
  end

  def render("avatar.json", %{avatar: avatar}) do
    %{
      id: avatar.id,
      name: avatar.name,
      pitch: avatar.pitch,
      speed: avatar.speed,
      language: avatar.language,
      gender: avatar.gender,
      user_id: avatar.user_id,
      inserted_at: avatar.inserted_at,
      updated_at: avatar.updated_at
    }
  end
end
