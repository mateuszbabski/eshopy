defmodule EshopyWeb.CategoryLive.Index do
  use EshopyWeb, :live_view

  alias Eshopy.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :categories, Catalog.list_categories())}
  end

  # @impl true
  # def handle_event("add_to_cart", _, socket) do
  #   {:noreply, socket}
  # end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
      |> assign(:page_title, "Show Category")
      |> assign(:category, Catalog.get_category!(id))
      |> assign(:products, Catalog.get_available_products_by_category_id(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Categories")
    |> assign(:category, nil)
  end
end
