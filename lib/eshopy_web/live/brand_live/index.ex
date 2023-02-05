defmodule EshopyWeb.BrandLive.Index do
  use EshopyWeb, :live_view

  alias Eshopy.Catalog
  alias Eshopy.Catalog.Brand

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:brands, Catalog.list_brands())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Brand")
    |> assign(:brand, Catalog.get_brand!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Brand")
    |> assign(:brand, %Brand{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Brands")
    |> assign(:brand, nil)
  end
end
