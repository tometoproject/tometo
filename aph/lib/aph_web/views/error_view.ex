defmodule AphWeb.ErrorView do
  use AphWeb, :view

  def render("no_auth.json", _assigns) do
    %{
      error: true,
      id: "no_auth",
      message: "You are not authorized to access this!"
    }
  end

  def render("reverse_no_auth.json", _assigns) do
    %{
      error: true,
      id: "reverse_no_auth",
      message: "You can't be logged in while doing this!"
    }
  end

  def render("no_confirmation.json", _assigns) do
    %{
      error: true,
      id: "no_confirmation",
      message: "You haven't confirmed your email address yet!"
    }
  end

  def render("wrong_user.json", _assigns) do
    %{
      error: true,
      id: "wrong_user",
      message: "Invalid authentication! You are logged in as the wrong user."
    }
  end

  def render("invalid_input.json", %{message: message}) do
    %{
      error: true,
      id: "invalid_input",
      message: message
    }
  end

  def render("insufficient_input.json", %{message: message}) do
    %{
      error: true,
      id: "insufficient_input",
      message: message
    }
  end

  def render("resource_limit.json", %{message: message}) do
    %{
      error: true,
      id: "resource_limit",
      message: message
    }
  end

  def render("internal_error.json", %{message: message}) do
    %{
      error: true,
      id: "internal_error",
      message: message
    }
  end

  def template_not_found(template, _assigns) do
    %{message: Phoenix.Controller.status_message_from_template(template)}
  end
end
