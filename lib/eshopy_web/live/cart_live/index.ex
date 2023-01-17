defmodule EshopyWeb.CartLive.Index do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.ShoppingCart
  alias Eshopy.ShoppingCart.Cart

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    {:ok,
    socket
    |> assign(:current_user, user)
    |> assign(:cart, ShoppingCart.get_cart_by_user_id_with_items(user.id))}
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Cart")
    |> assign(:cart, ShoppingCart.get_cart!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Cart")
    |> assign(:cart, %Cart{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Carts")
    |> assign(:cart, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    cart = ShoppingCart.get_cart!(id)
    {:ok, _} = ShoppingCart.delete_cart(cart)

    {:noreply, assign(socket, :carts, list_carts())}
  end

  defp list_carts do
    ShoppingCart.list_carts()
  end
end
