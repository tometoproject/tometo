defmodule AphWeb.UserView do
  use AphWeb, :view
  alias AphWeb.UserView

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end

  def render("poll.json", %{has_avatar: h, inboxes: inboxes}) do
    %{
      has_avatar: h,
      inboxes: inboxes
    }
  end
end
