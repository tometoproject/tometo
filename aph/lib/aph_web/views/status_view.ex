defmodule AphWeb.StatusView do
  use AphWeb, :view
  alias AphWeb.AvatarView
  alias AphWeb.StatusView

  def render("index.json", %{statuses: statuses}) do
    render_many(statuses, StatusView, "status.json")
  end

  def render("show.json", %{status: status}) do
    render_one(status, StatusView, "status.json")
  end

  def render("created.json", %{status: status}) do
    %{
      id: status.id,
      content: status.content,
      related_status_id: status.related_status_id
    }
  end

  def render("status.json", %{status: status}) do
    %{
      id: status.id,
      content: status.content,
      related_status_id: status.related_status_id,
      audio: status.audio,
      timestamps: status.timestamps,
      pic1: status.pic1,
      pic2: status.pic2,
      avatar: render_one(status.avatar, AvatarView, "show.json")
    }
  end
end
