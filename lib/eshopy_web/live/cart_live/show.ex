defmodule EshopyWeb.CartLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Catalog
  alias Eshopy.ShoppingCart

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    cart = ShoppingCart.get_cart_by_user_id(user.id)

    {:ok,
    socket
    |> assign(:current_user, user)
    |> assign(:cart, ShoppingCart.get_cart_by_user_id(user.id))
    |> assign(:cart_items, ShoppingCart.list_cart_items(cart.id))
    |> assign(:product, Catalog.list_products())
    }
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cart, ShoppingCart.get_cart!(id))}
  end

  defp page_title(:show), do: "Show Cart"
  defp page_title(:edit), do: "Edit Cart"
end
