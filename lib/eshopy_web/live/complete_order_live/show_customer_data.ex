defmodule EshopyWeb.CompleteOrderLive.ShowCustomerData do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Accounts.Customer

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    IO.inspect(Accounts.get_customer_data_by_user_id(user.id))

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
        |> redirect(to:  Routes.customer_form_component_path(socket, :new))}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
    socket}
  end

  @impl true
  def handle_event("proceed", %{"customer" => _customer_id}, socket) do
    IO.puts("hello world - PROCEED CLICKED")
    {:noreply,
    socket
    #|> redirect(to: )
    }
  end
end
