defmodule EshopyWeb.CustomerLive.Show do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Accounts.Customer

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    case Accounts.get_customer_data_by_user_id(user.id) do
      %Customer{} = customer ->
        {:ok,
        socket
        |> assign(:current_user, user)
        |> assign(:customer, customer)}

      nil ->
       {:ok,
        socket
        |> assign(:current_user, user)
        |> assign(:customer, %Customer{})
        |> put_flash(:info, "Fill customer data to continue")
        |> redirect(to: Routes.customer_index_path(socket, :new))}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> put_flash(:info, "You must be logged in")
    |> redirect(to: Routes.home_path(socket, :home))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:customer, Accounts.get_customer!(id))}
  end

  defp page_title(:show), do: "Show Customer"
  defp page_title(:edit), do: "Edit Customer"
end
