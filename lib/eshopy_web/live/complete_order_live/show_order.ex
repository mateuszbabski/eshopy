defmodule EshopyWeb.CompleteOrderLive.ShowOrder do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Orders
  alias Eshopy.Orders.Order

  @impl true
  def mount(%{"id" => id}, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    # change to get order in progress
    case Orders.get_full_order_by_user_id(user.id, id) do
      %Order{} = order ->
        {:ok,
          socket
          |> assign(:current_user, user)
          |> assign(:order, order)}

      nil ->
        {:ok,
          socket
          |> assign(:current_user, user)
          |> redirect(to: Routes.home_path(socket, :home))}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> put_flash(:info, "You must be logged in")
      |> redirect(to: Routes.home_path(socket, :home))}
  end

  @impl true
  def handle_event("proceed", %{"order" => order_id}, socket) do
    order = Orders.get_full_order_by_user_id(socket.assigns[:current_user].id, order_id)

    {:noreply,
      socket
      |> assign(:order, order)
      |> redirect(to: Routes.complete_order_show_customer_data_path(socket, :show_customer_data))}
  end
end
