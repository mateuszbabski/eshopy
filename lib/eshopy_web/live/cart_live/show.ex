defmodule EshopyWeb.CartLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Catalog
  alias Eshopy.Delivery
  alias Eshopy.ShoppingCart.Cart
  alias Eshopy.ShoppingCart
  alias Eshopy.Orders
  alias Eshopy.Orders.Order
  alias Eshopy.Delivery.Shipping

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    case ShoppingCart.get_cart_by_user_id(user.id) do
      %Cart{} = cart ->
        {:ok,
        socket
        |> assign(:current_user, user)
        |> assign(:cart, ShoppingCart.get_cart_by_user_id_with_cart_items(user.id))
        |> assign(:cart_items, ShoppingCart.list_cart_items(cart.id))
        |> assign(:product, Catalog.list_products())
        |> assign(:shipping_list, Delivery.list_shippings())}

      nil ->
        {:ok,
         socket
         |> assign(:current_user, user)
         |> put_flash(:info, "Cart is empty! Add a product!")
         |> redirect(to: Routes.home_path(socket, :home))}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
        socket
        |> put_flash(:info, "You must be logged in")
        |> redirect(to: Routes.home_path(socket, :home))}
  end

  @impl true
  def handle_event("delete", %{"product" => product_id}, socket) do
    {:ok, _cart} = ShoppingCart.remove_item_from_cart(socket.assigns[:cart], product_id)

    {:noreply,
        socket
        |> put_flash(:info, "Product removed from cart")
        |> redirect(to: Routes.cart_show_path(socket, :show))}
  end

  def handle_event("clear_cart", _, socket) do
    cart = socket.assigns[:cart]
    {:ok, _} = ShoppingCart.delete_cart(cart)

    {:noreply,
        socket
        |> put_flash(:info, "Cart cleared! Add a product to create a new one!")
        |> redirect(to: Routes.home_path(socket, :home))}
  end

  def handle_event("inc", %{"id" => item_id}, socket) do
    {:ok, %Cart{} = _cart} = ShoppingCart.increase_quantity_by_one(item_id, socket.assigns[:cart])

    {:noreply,
        socket
        |> redirect(to: Routes.cart_show_path(socket, :show))}
  end

  def handle_event("dec", %{"id" => item_id}, socket) do
    {:ok, %Cart{} = _cart} = ShoppingCart.decrease_quantity_by_one(item_id, socket.assigns[:cart])

    {:noreply,
        socket
        |> redirect(to: Routes.cart_show_path(socket, :show))}
  end

  def handle_event("shipment", %{"shipping" => shipping_id}, socket) do
    {:noreply,
      socket
      |> assign(:shipping, Delivery.get_shipping!(shipping_id))}
  end

  # def handle_event("checkout", _, socket) do
  #   case socket.assigns[:shipping] do
  #     %Shipping{} = shipping ->
  #       {:ok, order} = Orders.create_order_from_cart(socket.assigns[:cart], shipping)

  #       {:noreply,
  #       socket
  #       |> put_flash(:info, "Order created!")
  #       |> redirect(to: Routes.complete_order_show_order_path(socket, :show_order, order.id))}

  #     nil ->
  #       {:noreply,
  #       socket
  #       |> put_flash(:info, "Check products and shipping method")}
  #   end
  # end

  def handle_event("checkout", _, socket) do
    case socket.assigns[:shipping] do
      %Shipping{} = shipping ->
        create_or_update_order(socket, socket.assigns[:cart], shipping)

      nil ->
        {:noreply,
        socket
        |> put_flash(:info, "Check products and shipping method")}
    end
  end

  defp create_or_update_order(socket, cart, shipping) do
    case Orders.get_order_in_progress(socket.assigns[:current_user].id) do
      nil ->
        {:ok, order} = Orders.create_order_from_cart(cart, shipping)

        {:noreply,
        socket
        |> put_flash(:info, "Order created!")
        |> redirect(to: Routes.complete_order_show_order_path(socket, :show_order, order.id))}

      %Order{} = order ->
        {:ok, updated_order} = Orders.update_order(order, cart, shipping)

        {:noreply,
        socket
        |> put_flash(:info, "Order updated!")
        |> redirect(to: Routes.complete_order_show_order_path(socket, :show_order, updated_order.id))}
    end
  end
end
