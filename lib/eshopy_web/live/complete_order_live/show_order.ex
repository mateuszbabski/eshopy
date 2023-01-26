defmodule EshopyWeb.CompleteOrderLive.ShowOrder do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Orders

  @impl true
  def mount(%{"id" => id}, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    {:ok,
    socket
    |> assign(:current_user, user)
    |> assign(:order, Orders.get_full_order_by_user_id(user.id, id))}

  end

  def mount(_params, _session, socket) do
    {:ok,
        socket
        |> put_flash(:info, "You must be logged in")
        |> redirect(to: Routes.home_path(socket, :home))}
  end

  @impl true
  def handle_event("proceed", %{"order" => _order_id}, socket) do
    IO.inspect(socket.assigns[:order])

    {:noreply,
    socket
    |> redirect(to: Routes.complete_order_show_customer_data_path(socket, :show_customer_data))
    }
  end
end
