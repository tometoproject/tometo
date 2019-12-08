defmodule AphWeb.ErrorView do
  use AphWeb, :view

  def render("404.json", _assigns) do
    %{message: "Not found!"}
  end

  def render("401.json", assigns) do
    if assigns.message do
      %{message: "Unauthorized: #{assigns.message}"}
    end

    %{message: "Unauthorized!"}
  end

  def render("400.json", assigns) do
    if assigns.message do
      %{message: "Bad Request: #{assigns.message}"}
    else
      %{message: "Bad Request!"}
    end
  end

  def template_not_found(template, _assigns) do
    %{message: Phoenix.Controller.status_message_from_template(template)}
  end
end
