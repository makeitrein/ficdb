defmodule FicdbWeb.Router do
  use FicdbWeb, :router

  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(FicdbWeb.Plugs.Veil.UserId)
    plug(FicdbWeb.Plugs.Veil.User)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", FicdbWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", FanficController, :index)
    get("/faq", PageController, :faq)
    get("/changelog", PageController, :changelog)
    post("/add_to_bookshelf/:fanfic_id/:bookshelf_id", BookshelfController, :add_to_bookshelf)
    resources "/fandoms", FandomController
    resources "/fanfics", FanficController
    post("/fanfics/approve/:id", FanficController, :approve)
    post("/fanfics/unapprove/:id", FanficController, :unapprove)
    post("/fanfics/reject/:id", FanficController, :reject)
    post("/fanfics/unreject/:id", FanficController, :unreject)
    post("/fanfics/approval_status/:id", FanficController, :approval_status, as: :approval_status)
    post("/crawl/:host/:id", CrawlerController, :crawl_fanfic)
    post("/crawl/fandom", CrawlerController, :crawl_fandom)
    get("/crawl/characters", CharacterController, :crawl_characters)
    resources "/genres", GenreController
    resources "/reviews", ReviewController
    resources "/suggestions", SuggestionController
    post("/reviews/vote/:id", ReviewController, :vote)

    resources "/characters", CharacterController

    get("/admin/users", AdminController, :users)
    post("/admin/submitter/:id", AdminController, :make_submitter)
    post("/admin/mod/:id", AdminController, :make_mod)
    post("/admin/banned/:id", AdminController, :make_banned)

    get("/veil/users/fanfics", FanficController, :index)


  end

  scope "/veil", FicdbWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", FanficController, :index)
    get("/reviews", ReviewController, :index)
  end

  scope "/veil", FicdbWeb.Veil do
    pipe_through(:browser)

    post("/users/login", UserController, :login)
    post("/users/signup", UserController, :signup)
    put("/users/update", UserController, :update)

    get("/users/new", UserController, :new)
    get("/users/account", UserController, :show)
    get("/users/account/:id", UserController, :show, as: :account)
    get("/users/reviews", UserController, :reviews)
    get("/users/bookshelves/:id", UserController, :bookshelves)
    get("/sessions/new/:request_id", SessionController, :create)
    get("/sessions/signout/:session_id", SessionController, :delete)

  end

end
