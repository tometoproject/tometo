defmodule AphWeb.SessionView do
  use AphWeb, :view

  def render("success.json", %{user: user}) do
    %{data: %{id: user.id, username: user.username, email: user.email}}
  end

  def render("success_delete.json", _attrs) do
    %{message: "Successfully logged out!"}
  end
end
