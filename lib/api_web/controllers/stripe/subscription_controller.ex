defmodule ApiWeb.Stripe.SubscriptionController do
  use ApiWeb, :controller

  @plan_id "price_1JYF3sSGLvMTa3qVrsx7uADn"

  def list_user_subscriptions(conn, %{"user_id" => user_id})do
    {:ok, %Stripe.List{data: subscriptions}} = Stripe.Subscription.list(%{customer: user_id})
    render(conn, "index.json", %{subscriptions: subscriptions})
  end


  def list_all_subscriptions(conn, _params)do
    {:ok, %Stripe.List{data: subscriptions}} = Stripe.Subscription.list()
    render(conn, "index.json", %{subscriptions: subscriptions})
  end

  def create_subscription(conn, %{"payment_method" => %{"billing_details" => %{"email" => email}} = payment_method})do
    with {:ok,  %Stripe.PaymentMethod{id: payment_method, card: _card}} <- Stripe.PaymentMethod.create(payment_method),
         {:ok, %Stripe.Customer{id: customer_stripe_id}} <- Stripe.Customer.create(%{email: email, payment_method: payment_method, invoice_settings: %{default_payment_method: payment_method}}),
         {:ok, %Stripe.Subscription{}} <- Stripe.Subscription.create(%{customer: customer_stripe_id, items: [%{plan: @plan_id}], payment_behavior: "allow_incomplete"})do

      conn
      |> json(%{status: :ok, message: "Your subscription was successful"})

      else
      {:error,  %Stripe.Error{code: _code, message: message}} ->
      conn
      |> put_status(400)
      |> json(%{error: :error, message: message})
      _ ->
      conn
      |> put_status(400)
      |> json(%{error: :error, message: "Something went wrong while processing your subscription"})
    end
  end

  def list_upcoming_payments(conn, %{"user_id" => user_id})do
    {:ok, invoice} =  Stripe.Invoice.upcoming(%{customer: user_id})
    render(conn, "invoice.json", invoice: invoice)
  end

  def list_billing_history(conn, %{"user_id" => user_id})do
    {:ok, invoice} =  Stripe.Invoice.upcoming(%{customer: user_id})
    render(conn, "invoice.json", invoice: invoice)
end
end
