defmodule EshopyWeb.OrderLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.Orders
  alias Eshopy.Accounts
  alias Eshopy.Orders.Order

  @impl true
  def mount(%{"id" => id}, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    #completed order
    case user.role do
      :user ->
        assign_order(user, id, socket)

      :admin ->
        {:ok,
          socket
          |> put_flash(:info, "You must be logged in")
          |> redirect(to: Routes.home_index_path(socket, :index))}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> put_flash(:info, "You must be logged in")
      |> redirect(to: Routes.home_index_path(socket, :index))}
  end

  defp assign_order(user, id, socket) do
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
          |> assign(:order, nil)
          |> put_flash(:info, "Order doesnt exist")
          |> redirect(to: Routes.home_index_path(socket, :index))}
    end
  end
end
