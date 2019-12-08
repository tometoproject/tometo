defmodule AphWeb.UserView do
  use AphWeb, :view
  alias AphWeb.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email, username: user.username}
  end

  def render("poll.json", %{has_avatar: h}) do
    %{has_avatar: h}
  end
end
