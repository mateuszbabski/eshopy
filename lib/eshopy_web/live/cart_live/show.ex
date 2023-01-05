defmodule EshopyWeb.CartLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.ShoppingCart

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    {:ok,
    socket
    |> assign(:current_user, user)
    |> assign(:carts, ShoppingCart.get_cart_by_user_id_with_items(user.id))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cart, ShoppingCart.get_cart!(id))}
  end

  defp page_title(:show), do: "Show Cart"
  defp page_title(:edit), do: "Edit Cart"
end
