defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", ApiWeb do
    pipe_through :api
    scope "/stripe", Stripe do
      get "/my-subscriptions",  SubscriptionController, :list_user_subscriptions
      get "/all-subscriptions", SubscriptionController, :list_all_subscriptions
      post "/save-card-and-subscription", SubscriptionController, :create_subscription
      get "/last-and-upcoming-payments", SubscriptionController, :list_upcoming_payments
      get "/billing-history", SubscriptionController, :list_billing_history
      post "/webhook", WebHookController, :web_hook
    end
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ApiWeb.Telemetry
    end
  end
end
