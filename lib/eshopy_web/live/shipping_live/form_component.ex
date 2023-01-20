defmodule EshopyWeb.ShippingLive.FormComponent do
  use EshopyWeb, :live_component

  alias Eshopy.Delivery

  @impl true
  def update(%{shipping: shipping} = assigns, socket) do
    changeset = Delivery.change_shipping(shipping)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"shipping" => shipping_params}, socket) do
    changeset =
      socket.assigns.shipping
      |> Delivery.change_shipping(shipping_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"shipping" => shipping_params}, socket) do
    save_shipping(socket, socket.assigns.action, shipping_params)
  end

  defp save_shipping(socket, :edit, shipping_params) do
    case Delivery.update_shipping(socket.assigns.shipping, shipping_params) do
      {:ok, _shipping} ->
        {:noreply,
         socket
         |> put_flash(:info, "Shipping updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_shipping(socket, :new, shipping_params) do
    case Delivery.create_shipping(shipping_params) do
      {:ok, _shipping} ->
        {:noreply,
         socket
         |> put_flash(:info, "Shipping created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
