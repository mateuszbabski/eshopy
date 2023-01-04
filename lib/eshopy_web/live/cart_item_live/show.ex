defmodule EshopyWeb.CartItemLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.ShoppingCart

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cart_item, ShoppingCart.get_cart_item!(id))}
  end

  defp page_title(:show), do: "Show Cart item"
  defp page_title(:edit), do: "Edit Cart item"
end
