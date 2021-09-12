defmodule ApiWeb.Stripe.LineItemView do
  use ApiWeb, :view
  alias ApiWeb.Stripe.PlanView
  alias ApiWeb.Stripe.PriceView

  def render("item.json", %{item: item}) do
    %{
      amount: item.amount,
      currency: item.currency,
      description: item.description,
      discountable: item.discountable,
      id: item.id,
      invoice_item: item.invoice_item,
      period: item.period,
      plan: render_one(item.plan, PlanView, "plan.json", as: :plan),
      price: render_one(item.price, PriceView, "price.json", as: :price)

    }
  end
end
