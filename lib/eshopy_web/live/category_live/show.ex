defmodule EshopyWeb.CategoryLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:category, Catalog.get_category!(id))
     |> assign(:products, Catalog.get_product_by_category_id(id))}
  end

  defp page_title(:show), do: "Show Category"
  defp page_title(:edit), do: "Edit Category"
end
