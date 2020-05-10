defmodule AphWeb.InvitationView do
  use AphWeb, :view
  alias AphWeb.InvitationView
  alias AphWeb.UserView

  def render("index.json", %{invitations: invitations}) do
    %{data: render_many(invitations, InvitationView, "invitation.json")}
  end

  def render("for_user.json", %{invitations: invitations}) do
    %{data: render_many(invitations, InvitationView, "invitation.json"), limit: 10}
  end

  def render("show.json", %{invitation: invitation}) do
    %{data: render_one(invitation, InvitationView, "invitation.json")}
  end

  def render("invitation.json", %{invitation: invitation}) do
    created =
      if Ecto.assoc_loaded?(invitation.created_user),
        do: render_one(invitation.created_user, UserView, "user.json"),
        else: invitation.created_by

    used =
      if Ecto.assoc_loaded?(invitation.used_user),
        do: render_one(invitation.used_user, UserView, "user.json"),
        else: invitation.used_by

    %{
      code: invitation.code,
      created_by: created,
      used_by: used
    }
  end
end
