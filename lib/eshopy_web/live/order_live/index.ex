defmodule EshopyWeb.OrderLive.Index do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Orders
  alias Eshopy.Orders.Order

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    case user.role do
      :user ->
        {:ok,
          socket
          |> assign(:current_user, user)
          |> assign(:orders, Orders.list_orders_by_user_id(user.id))}

      :admin ->
        {:ok,
          socket
          |> assign(:current_user, user)
          |> assign(:orders, Orders.list_orders())}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> put_flash(:info, "You must be logged in")
      |> redirect(to: Routes.home_path(socket, :home))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Orders.get_order!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order")
    |> assign(:order, %Order{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    order = Orders.get_order!(id)
    {:ok, _} = Orders.delete_order(order)

    {:noreply, assign(socket, :orders, list_orders())}
  end

  defp list_orders do
    Orders.list_orders()
  end
end
