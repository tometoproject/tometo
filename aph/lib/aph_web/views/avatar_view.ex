defmodule AphWeb.AvatarView do
  use AphWeb, :view
  alias AphWeb.AvatarView

  def render("index.json", %{avatars: avatars}) do
    %{data: render_many(avatars, AvatarView, "avatar.json")}
  end

  def render("show.json", %{avatar: avatar}) do
    %{data: render_one(avatar, AvatarView, "avatar.json")}
  end

  def render("avatar.json", %{avatar: avatar}) do
    %{
      id: avatar.id,
      name: avatar.name,
      pitch: avatar.pitch,
      speed: avatar.speed,
      language: avatar.language,
      gender: avatar.gender,
      user_id: avatar.user_id
    }
  end
end
