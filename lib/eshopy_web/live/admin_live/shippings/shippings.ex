defmodule EshopyWeb.AdminLive.Shippings do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Delivery
  alias Eshopy.Delivery.Shipping

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
          |> assign(:shippings, Delivery.list_shippings())}
    end
  end

  def mount(_params, _session, socket) do
    {:noreply,
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

    {:noreply, assign(socket, :shippings, Delivery.list_shippings())}
  end
end
