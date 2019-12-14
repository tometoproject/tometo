defmodule AphWeb.InvitationView do
  use AphWeb, :view
  alias AphWeb.InvitationView

  def render("index.json", %{invitations: invitations}) do
    %{data: render_many(invitations, InvitationView, "invitation.json")}
  end

  def render("show.json", %{invitation: invitation}) do
    %{data: render_one(invitation, InvitationView, "invitation.json")}
  end

  def render("invitation.json", %{invitation: invitation}) do
    %{id: invitation.id,
      code: invitation.code}
  end
end
