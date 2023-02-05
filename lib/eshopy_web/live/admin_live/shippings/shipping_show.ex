defmodule EshopyWeb.AdminLive.ShippingShow do
  use EshopyWeb, :live_view

  alias Eshopy.Delivery
  alias Eshopy.Delivery.Shipping
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
    |> assign(:page_title, "Edit shipping")
    |> assign(:shipping, Delivery.get_shipping!(id))
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Show shipping")
    |> assign(:shipping, Delivery.get_shipping!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New shipping")
    |> assign(:shipping, %Shipping{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing shippings")
    |> assign(:shipping, nil)
  end

  @impl true
  def handle_event("change", %{"id" => id}, socket) do
    shipping = Delivery.get_shipping!(id)
    Delivery.change_shipping_availability(shipping)

    {:noreply,
      socket
      |> put_flash(:info, "Shipping availability changed")
      |> assign(:shipping, Delivery.get_shipping!(id))}
  end
end
