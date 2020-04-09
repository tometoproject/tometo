defmodule AphWeb.Router do
  use AphWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Phauxth.Authenticate
    plug Phauxth.Remember, create_session_func: &AphWeb.Auth.create_session/1
  end

  scope "/api", AphWeb do
    pipe_through :api
    get "/", DefaultController, :index
    post "/users", UserController, :create
    get "/users/:id/invitations", InvitationController, :for_user
    get "/users/:id/inboxes", InboxController, :show_for_user
    get "/users/:id/poll", UserController, :poll

    post "/sessions", SessionController, :create
    delete "/sessions/:id", SessionController, :delete

    post "/invitations", InvitationController, :create
    get "/invitations/:code", InvitationController, :get

    post "/avatars", AvatarController, :create
    get "/avatars/:id", AvatarController, :show
    put "/avatars/:id", AvatarController, :update

    post "/questions", QuestionController, :create
    get "/questions/:id", QuestionController, :show

    post "/answers", AnswerController, :create
    get "/answers/:id", AnswerController, :show
    get "/answers/:id/comments", CommentController, :show_for_answer

    delete "/inboxes/:id", InboxController, :delete

    post "/comments", CommentController, :create
  end
end
