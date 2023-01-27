defmodule EshopyWeb.Router do
  use EshopyWeb, :router

  import EshopyWeb.UserAuth
  alias EshopyWeb.EnsureRolePlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {EshopyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :admin do
    plug EnsureRolePlug, :admin
  end

  pipeline :user do
    plug EnsureRolePlug, [:admin, :user]
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EshopyWeb do
    pipe_through :browser

    live "/", HomeLive, :home
    live "/admin", AdminDashboardLive, :admin_dashboard

    live "/products", ProductLive.Index, :index
    live "/products/new", ProductLive.Index, :new
    live "/products/:id/edit", ProductLive.Index, :edit

    live "/products/:id", ProductLive.Show, :show
    live "/products/:id/show/edit", ProductLive.Show, :edit

    live "/brands", BrandLive.Index, :index
    live "/brands/new", BrandLive.Index, :new
    live "/brands/:id/edit", BrandLive.Index, :edit

    live "/brands/:id", BrandLive.Show, :show
    live "/brands/:id/show/edit", BrandLive.Show, :edit

    live "/categories", CategoryLive.Index, :index
    live "/categories/new", CategoryLive.Index, :new
    live "/categories/:id/edit", CategoryLive.Index, :edit

    live "/categories/:id", CategoryLive.Show, :show
    live "/categories/:id/show/edit", CategoryLive.Show, :edit

    live "/shippings", ShippingLive.Index, :index
    live "/shippings/new", ShippingLive.Index, :new
    live "/shippings/:id/edit", ShippingLive.Index, :edit

    live "/shippings/:id", ShippingLive.Show, :show
    live "/shippings/:id/show/edit", ShippingLive.Show, :edit

    live "/orders", OrderLive.Index, :index
    live "/orders/:id", OrderLive.Show, :show

    live "/customers/new", CustomerLive.FormComponent, :new
    live "/customers/:id/show/edit", CustomerLive.FormComponent, :edit

    live "/cart/", CartLive.Show, :show

    live "/order/:id", CompleteOrderLive.ShowOrder, :show_order
    live "/delivery/", CompleteOrderLive.ShowCustomerData, :show_customer_data
    # live "/payment/", CompleteOrderLive.ShowPaymentMethod, :show_payment_method
    # live "/summary/", CompleteOrderLive.Summary, :summary
  end

  scope "/", EshopyWeb do
    pipe_through [:browser, :require_authenticated_user, :user]
  end

  scope "/", EshopyWeb do
    pipe_through [:browser, :require_authenticated_user, :admin]
  end

  # Other scopes may use custom stacks.
  # scope "/api", EshopyWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EshopyWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", EshopyWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", EshopyWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", EshopyWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
