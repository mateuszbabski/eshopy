defmodule EshopyWeb.CartItemLive.FormComponent do
  use EshopyWeb, :live_component

  alias Eshopy.ShoppingCart

  @impl true
  def update(%{cart_item: cart_item} = assigns, socket) do
    changeset = ShoppingCart.change_cart_item(cart_item)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"cart_item" => cart_item_params}, socket) do
    changeset =
      socket.assigns.cart_item
      |> ShoppingCart.change_cart_item(cart_item_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"cart_item" => cart_item_params}, socket) do
    save_cart_item(socket, socket.assigns.action, cart_item_params)
  end

  defp save_cart_item(socket, :edit, cart_item_params) do
    case ShoppingCart.update_cart_item(socket.assigns.cart_item, cart_item_params) do
      {:ok, _cart_item} ->
        {:noreply,
         socket
         |> put_flash(:info, "Cart item updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_cart_item(socket, :new, cart_item_params) do
    case ShoppingCart.create_cart_item(cart_item_params) do
      {:ok, _cart_item} ->
        {:noreply,
         socket
         |> put_flash(:info, "Cart item created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
