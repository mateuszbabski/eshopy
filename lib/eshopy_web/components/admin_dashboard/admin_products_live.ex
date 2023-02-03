defmodule EshopyWeb.AdminProductsLive do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Catalog

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    case user.role do
      :user ->
        {:ok,
          socket
          |> assign(:current_user, user)
          |> put_flash(:info, "Unauthorized")
          |> redirect(to: Routes.home_path(socket, :home))}

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
      |> redirect(to: Routes.home_path(socket, :home))}
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
end
