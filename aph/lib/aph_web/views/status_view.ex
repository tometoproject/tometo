defmodule AphWeb.StatusView do
  use AphWeb, :view
  alias AphWeb.StatusView

  def render("index.json", %{statuses: statuses}) do
    %{data: render_many(statuses, StatusView, "status.json")}
  end

  def render("index_display.json", %{statuses: statuses}) do
    %{data: render_many(statuses, StatusView, "status_for_display.json")}
  end

  def render("show.json", %{status: status}) do
    %{data: render_one(status, StatusView, "status.json")}
  end

  def render("show_display.json", %{status: status}) do
    %{data: render_one(status, StatusView, "status_for_display.json")}
  end

  def render("status_for_display.json", %{status: status}) do
    %{
      audio: status.audio,
      timestamps: status.timestamps,
      avatar_name: status.avatar_name,
      pic1: status.pic1,
      pic2: status.pic2,
      related_status_id: status.related_status_id
    }
  end

  def render("status.json", %{status: status}) do
    %{
      id: status.id,
      content: status.content
    }
  end
end
