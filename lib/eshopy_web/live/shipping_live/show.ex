defmodule EshopyWeb.ShippingLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.Delivery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:shipping, Delivery.get_shipping!(id))}
  end

  defp page_title(:show), do: "Show Shipping"
  defp page_title(:edit), do: "Edit Shipping"
end
