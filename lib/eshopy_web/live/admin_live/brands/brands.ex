defmodule EshopyWeb.AdminLive.Brands do
  use EshopyWeb, :live_view

  alias Eshopy.Catalog
  alias Eshopy.Accounts
  alias Eshopy.Catalog.Brand

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
          |> assign(:brands, Catalog.list_brands())}
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
  def handle_event("delete", %{"id" => id}, socket) do
    brand = Catalog.get_brand!(id)
    {:ok, _} = Catalog.delete_brand(brand)

    {:noreply, assign(socket, :brands, Catalog.list_brands())}
  end
end
