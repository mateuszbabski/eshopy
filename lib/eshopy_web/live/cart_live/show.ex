defmodule EshopyWeb.CartLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Catalog
  alias Eshopy.ShoppingCart.Cart
  alias Eshopy.ShoppingCart

  @impl true
  # def mount(_params, %{"user_token" => user_token}, socket) do
  #   user = Accounts.get_user_by_session_token(user_token)
  #   cart = ShoppingCart.get_cart_by_user_id(user.id)

  #   {:ok,
  #   socket
  #   |> assign(:current_user, user)
  #   |> assign(:cart, ShoppingCart.get_cart_by_user_id_with_cart_items(user.id))
  #   |> assign(:cart_items, ShoppingCart.list_cart_items(cart.id))
  #   |> assign(:product, Catalog.list_products())
  #   }
  # end

  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    cart = ShoppingCart.get_cart_by_user_id(user.id)

    if cart do
      {:ok,
          socket
          |> assign(:current_user, user)
          |> assign(:cart, ShoppingCart.get_cart_by_user_id_with_cart_items(user.id))
          |> assign(:cart_items, ShoppingCart.list_cart_items(cart.id))
          |> assign(:product, Catalog.list_products())}
    else
      {:ok,
          socket
          |> assign(:current_user, user)
          |> put_flash(:info, "Cart is empty! Add a product!")
          |> redirect(to: Routes.home_path(socket, :home))}
    end
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("delete", %{"product" => product_id}, socket) do
    {:ok, cart} = ShoppingCart.remove_item_from_cart(socket.assigns[:cart], product_id)

    {:noreply,
        socket
        |> put_flash(:info, "Product removed from cart")
        |> redirect(to: Routes.cart_show_path(socket, :show, cart.id))}
  end

  def handle_event("clear-cart", _, socket) do
    cart = socket.assigns[:cart]
    {:ok, _} = ShoppingCart.delete_cart(cart)

    {:noreply,
        socket
        |> put_flash(:info, "Cart cleared! Add a product to create a new one!")
        |> redirect(to: Routes.home_path(socket, :home))}
  end

  def handle_event("inc", %{"id" => item_id}, socket) do
    {:ok, %Cart{} = cart} = ShoppingCart.increase_quantity_by_one(item_id, socket.assigns[:cart])

    {:noreply,
        socket
        # |> assign(:cart, ShoppingCart.reload_cart(cart.id))
        # |> assign(:cart_items, ShoppingCart.list_cart_items(cart.id))
        |> redirect(to: Routes.cart_show_path(socket, :show, cart.id))}
  end

  def handle_event("dec", %{"id" => item_id}, socket) do
    {:ok, %Cart{} = cart} = ShoppingCart.decrease_quantity_by_one(item_id, socket.assigns[:cart])

    {:noreply,
        socket
        # |> assign(:cart, ShoppingCart.reload_cart(cart.id))
        # |> assign(:cart_items, ShoppingCart.list_cart_items(cart.id))
        |> redirect(to: Routes.cart_show_path(socket, :show, cart.id))}
  end

  # @impl true
  # def handle_params(%{"id" => id}, _, socket) do
  #   {:noreply,
  #    socket
  #    |> assign(:page_title, page_title(socket.assigns.live_action))
  #    |> assign(:cart, ShoppingCart.get_cart_with_items(id))}
  # end

end
