defmodule ApiWeb.Stripe.SubscriptionView do
  use ApiWeb, :view
  alias  ApiWeb.Stripe.SubscriptionView
  alias  ApiWeb.Stripe.PlanView
  alias ApiWeb.Stripe.SubscriptionItemView
  alias ApiWeb.Stripe.InvoiceView

  def render("index.json", %{subscriptions: subscriptions}) do
    %{data: render_many(subscriptions, SubscriptionView, "subscription.json")}
  end

  def render("invoice.json", %{invoice: invoice}) do
    %{data: render_one(invoice, InvoiceView, "invoice.json")}
  end

  def render("invoices.json", %{invoice: invoice}) do
    %{data: render_many(invoice, InvoiceView, "invoice.json")}
  end

  def render("show.json", %{subscription: subscription}) do
    %{data: render_one(subscription, SubscriptionView, "subscription.json")}
  end

  def render("subscription.json", %{subscription: subscription}) do
    %Stripe.List{data: items} = subscription.items
    %{
      id: subscription.id,
      current_period_start: subscription.current_period_start,
      created: subscription.created,
      canceled_at: subscription.canceled_at,
      status: subscription.status,
      plan: render_one(subscription.plan, PlanView, "plan.json", as: :plan),
      latest_invoice: subscription.latest_invoice,
      trial_start: subscription.trial_start,
      customer: subscription.customer,
      days_until_due: subscription.days_until_due,
    quantity: subscription.quantity,
    items:  render_many(items, SubscriptionItemView, "item.json", as: :item),
    }
  end
end
