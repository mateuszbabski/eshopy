defmodule EshopyWeb.AdminLive.BrandShow do
  use EshopyWeb, :live_view

  alias Eshopy.Catalog
  alias Eshopy.Catalog.Brand
  alias Eshopy.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    case user.role do
      :admin ->
        {:ok,
          socket
          |> assign(:current_user, user)}

      :user ->
        {:ok,
          socket
          |> assign(:current_user, user)
          |> put_flash(:info, "Unauthorized")
          |> redirect(to: Routes.home_index_path(socket, :index))}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> put_flash(:info, "Unauthorized")
      |> redirect(to: Routes.home_index_path(socket, :index))}
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

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Show brand")
    |> assign(:brand, Catalog.get_brand!(id))
    |> assign(:products, Catalog.get_products_by_brand_id(id))
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

  @impl true
  def handle_event("change", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    Catalog.change_product_availability(product)

    {:noreply,
      socket
      |> put_flash(:info, "Product availability changed")
      |> assign(:brand, socket.assigns[:brand])
      |> assign(:products, Catalog.get_products_by_brand_id(product.brand_id))}
  end
end
