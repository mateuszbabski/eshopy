defmodule EshopyWeb.AdminLive.OrderShow do
  use EshopyWeb, :live_view

  alias Eshopy.Orders
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

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Show order")
    |> assign(:order, Orders.get_order_with_items(id))
  end
end
