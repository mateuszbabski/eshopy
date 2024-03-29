defmodule EshopyWeb.AdminLive.Products do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Catalog
  alias Eshopy.Catalog.Product

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    case user.role do
      :user ->
        {:ok,
          socket
          |> assign(:current_user, user)
          |> put_flash(:info, "Unauthorized")
          |> redirect(to: Routes.home_index_path(socket, :index))}

      :admin ->
        {:ok,
          socket
          |> assign(:current_user, user)
          |> assign(:products, Catalog.list_products())
          |> assign(:brands, Catalog.list_brands())
          |> assign(:categories, Catalog.list_categories())}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> put_flash(:info, "Unauthorized")
      |> redirect(to: Routes.home_index_path(socket, :index))}
  end

  @impl true
  def handle_event("change", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    Catalog.change_product_availability(product)

    {:noreply,
      socket
      |> put_flash(:info, "Product availability changed")
      |> assign(:products, Catalog.list_products())
      |> assign(:brands, Catalog.list_brands())
      |> assign(:categories, Catalog.list_categories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end
end
