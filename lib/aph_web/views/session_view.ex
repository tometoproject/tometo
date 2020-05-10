defmodule AphWeb.SessionView do
  use AphWeb, :view
  alias AphWeb.UserView

  def render("show.json", %{user: user, id: id}) do
    %{user: render_one(user, UserView, "show.json"), session_id: id}
  end

  def render("success_delete.json", _attrs) do
    %{message: "Successfully logged out!"}
  end
end
