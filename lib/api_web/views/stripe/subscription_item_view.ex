defmodule ApiWeb.Stripe.SubscriptionItemView do
  use ApiWeb, :view
  alias  ApiWeb.Stripe.SubscriptionItemView
  alias ApiWeb.Stripe.PlanView
  alias ApiWeb.Stripe.PriceView

  def render("show.json", %{item: item}) do
    %{data: render_one(item, SubscriptionItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{
      billing_thresholds: item.billing_thresholds,
      created: item.created,
      id: item.id,
      plan: render_one(item.plan, PlanView, "plan.json", as: :plan),
      price: render_one(item.price, PriceView, "price.json", as: :price)
    }
  end
end
