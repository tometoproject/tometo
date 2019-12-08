defmodule AphWeb.Router do
  use AphWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :user_auth do
    plug AphWeb.AuthPipeline
  end

  scope "/api", AphWeb do
    pipe_through :api
    get "/", DefaultController, :index
    post "/register", UserController, :create
    post "/auth", UserController, :login
    get "/status/:id", StatusController, :show
    get "/status/:id/comments", StatusController, :show_comments
  end

  scope "/api", AphWeb do
    pipe_through [:api, :user_auth]
    delete "/auth", UserController, :logout
    get "/poll", UserController, :poll
    get "/avatar/:id", AvatarController, :show
    put "/avatar/:id/update", AvatarController, :update
    post "/avatar/new", AvatarController, :create
    post "/status/new", StatusController, :create
  end
end
