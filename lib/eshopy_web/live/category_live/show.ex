defmodule EshopyWeb.CategoryLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.Catalog
  alias Eshopy.ShoppingCart
  alias Eshopy.ShoppingCart.Cart
  alias Eshopy.ShoppingCart.CartItem
  alias Eshopy.Accounts

  @impl true

  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    {:ok,
      socket
      |> assign(:current_user, user)
      |> assign(:cart, ShoppingCart.get_cart_by_user_id(user.id))
      |> assign(:cart_items, %CartItem{})}
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("add_to_cart", %{"product" => product_id, "quantity" => quantity}, socket) do
    if socket.assigns[:current_user] do
      create_and_add_item(product_id, quantity, socket)
    else
      {:noreply,
        socket
        |> put_flash(:info, "You must be logged in")}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
      socket
      |> assign(:page_title, "Show Category")
      |> assign(:category, Catalog.get_category!(id))
      |> assign(:products, Catalog.get_available_products_by_category_id(id))}
  end

  defp create_and_add_item(product_id, quantity, socket) do
    product = Catalog.get_product!(product_id)
    quantity = String.to_integer(quantity)

    socket =
      case ShoppingCart.get_cart_by_user_id(socket.assigns.current_user.id) do
        %Cart{} = cart ->
          add_item_to_shopping_cart(socket, cart, product, quantity)

        nil ->
          {:ok, %Cart{} = cart} = ShoppingCart.create_cart(socket.assigns.current_user)
          add_item_to_shopping_cart(socket, cart, product, quantity)
      end

    {:noreply, socket}
  end

  defp add_item_to_shopping_cart(socket, cart, product, quantity) do
    case ShoppingCart.add_item_to_cart(cart, product, quantity) do
          {:ok, _item} ->
            socket
            |> put_flash(:info, "Item added to shopping cart")

          {:error, _changeset} ->
            socket
            |> put_flash(:info, "Error with adding item")
    end
  end
end
