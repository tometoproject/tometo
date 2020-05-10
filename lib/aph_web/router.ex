defmodule AphWeb.Router do
  use AphWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug
  import AphWeb.UserAuth
  import Phoenix.LiveDashboard.Router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_current_user
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/api/v1", AphWeb do
    pipe_through [:api, :redirect_if_user_is_authenticated]

    post "/users", UserRegistrationController, :create
    post "/sessions", UserSessionController, :create
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
    post "/users/reset_password", UserResetPasswordController, :create
    put "/users/reset_password/:token", UserResetPasswordController, :update
    get "/users/confirm_email/:token", UserSettingsController, :confirm_email
    get "/invitations/:code", InvitationController, :get
  end

  scope "/api/v1", AphWeb do
    pipe_through [:api, :require_authenticated_user]

    delete "/sessions", UserSessionController, :delete
    put "/users/update_password", UserSettingsController, :update_password
    put "/users/update_email", UserSettingsController, :update_email
    get "/users/:id/invitations", InvitationController, :for_user
    get "/users/:id/inboxes", InboxController, :show_for_user
    get "/users/:id/poll", UserController, :poll
    post "/invitations", InvitationController, :create
    post "/avatars", AvatarController, :create
    put "/avatars/:id", AvatarController, :update
    get "/questions/:id", QuestionController, :show
    post "/answers", AnswerController, :create
    delete "/inboxes/:id", InboxController, :delete
    post "/comments", CommentController, :create
  end

  scope "/api/v1", AphWeb do
    pipe_through [:api, :require_admin_or_mod_user]

    get "/questions", QuestionController, :list
    post "/questions", QuestionController, :create
  end

  scope "/api/v1", AphWeb do
    pipe_through :api

    get "/", DefaultController, :index
    get "/avatars/:id", AvatarController, :show
    get "/answers/:id", AnswerController, :show
    get "/answers/:id/comments", CommentController, :show_for_answer
  end

  if Mix.env() == :dev do
    scope "/" do
      live_dashboard "/dashboard"
      forward "/sent_emails", Bamboo.SentEmailViewerPlug
    end
  end

  scope "/", AphWeb do
    pipe_through :browser

    get "/admin/*path", PageController, :admin
    get "/*path", PageController, :index
  end
end
