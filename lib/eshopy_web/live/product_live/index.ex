defmodule EshopyWeb.ProductLive.Index do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Catalog
  alias Eshopy.ShoppingCart
  alias Eshopy.ShoppingCart.Cart

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    {:ok,
      socket
      |> assign(:current_user, user)
      |> assign(:products, Catalog.list_available_products())
      |> assign(:brands, Catalog.list_brands())
      |> assign(:categories, Catalog.list_categories())
      |> assign(:cart, ShoppingCart.get_cart_by_user_id(user.id))
      |> assign(:cart_items, nil)}
  end

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:products, Catalog.list_available_products())
      |> assign(:brands, Catalog.list_brands())
      |> assign(:categories, Catalog.list_categories())
    }
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, assign(socket, :products, Catalog.list_available_products())}
  end

  def handle_event("add_to_cart", %{"product" => product_id, "quantity" => quantity}, socket) do
    case socket.assigns[:current_user] do
      %Eshopy.Accounts.User{role: :user} ->
        create_and_add_item(product_id, quantity, socket)

      _ ->
        {:noreply,
          socket
          |> put_flash(:info, "You must be logged in")}
    end
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

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Show Product")
    |> assign(:product, Catalog.get_product!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end
end
