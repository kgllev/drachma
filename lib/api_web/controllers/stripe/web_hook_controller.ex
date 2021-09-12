defmodule ApiWeb.Stripe.WebHookController do
  use ApiWeb, :controller

  def web_hook(conn, %{"event" => event})do
    case event.type do
      "payment_intent.succeeded" ->
        IO.inspect event
      "payment_method.attached" ->
        IO.inspect event
      data ->
        IO.puts "Unhandled Event"
        IO.inspect data
    end
    conn
    |> json(%{status: :ok, message: "event received"})
  end

end
