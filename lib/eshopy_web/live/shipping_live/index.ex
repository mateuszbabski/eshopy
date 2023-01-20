defmodule EshopyWeb.ShippingLive.Index do
  use EshopyWeb, :live_view

  alias Eshopy.Delivery
  alias Eshopy.Delivery.Shipping

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :shippings, list_shippings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Shipping")
    |> assign(:shipping, Delivery.get_shipping!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Shipping")
    |> assign(:shipping, %Shipping{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Shippings")
    |> assign(:shipping, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    shipping = Delivery.get_shipping!(id)
    {:ok, _} = Delivery.delete_shipping(shipping)

    {:noreply, assign(socket, :shippings, list_shippings())}
  end

  defp list_shippings do
    Delivery.list_shippings()
  end
end
