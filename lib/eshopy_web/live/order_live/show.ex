defmodule EshopyWeb.OrderLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.Orders
  alias Eshopy.Accounts

  @impl true
  def mount(%{"id" => id}, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    case user.role do
      :user ->
        mount_order(user, id, socket)

      :admin ->
        {:ok,
        socket
        |> assign(:current_user, user)
        |> assign(:order, Orders.get_order!(id))}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> put_flash(:info, "You must be logged in")
    |> redirect(to: Routes.home_path(socket, :home))}
  end

  defp mount_order(user, id, socket) do
    case Orders.get_full_order_by_user_id(user.id, id) do
      nil ->
        {:ok,
        socket
        |> assign(:current_user, user)
        |> assign(:order, nil)
        |> put_flash(:info, "Order doesnt exist")
        |> redirect(to: Routes.home_path(socket, :home))}

      order ->
        {:ok,
        socket
        |> assign(:current_user, user)
        |> assign(:order, order)}
    end
  end
end
