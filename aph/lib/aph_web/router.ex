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
    post "/register", UserController, :create
    post "/auth", SessionController, :create
    get "/status/:id", StatusController, :show
    get "/status/:id/comments", StatusController, :show_comments
    get "/invitations/:code", InvitationController, :get

    # Routes where authorization is required (this is set in the controller)
    delete "/auth", SessionController, :delete
    get "/poll", UserController, :poll
    get "/avatar/:id", AvatarController, :show
    put "/avatar/edit/:id", AvatarController, :update
    post "/avatar/new", AvatarController, :create
    post "/status/new", StatusController, :create
    get "/invitations", InvitationController, :for_user
    post "/invitations", InvitationController, :create
  end
end
