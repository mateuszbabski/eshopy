defmodule EshopyWeb.CustomerLive.FormComponent do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias Eshopy.Accounts.Customer

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    changeset = Accounts.change_customer(%Customer{})
    user = Accounts.get_user_by_session_token(user_token)

    {:ok,
    socket
    |> assign(:current_user, user)
    |> assign(:customer, %Customer{})
    |> assign(:changeset, changeset)}
  end

  def mount(_params, _session, socket) do
    {:ok,
        socket
        |> put_flash(:info, "You must be logged in")
        |> redirect(to: Routes.home_path(socket, :home))}
  end

  @impl true
  def handle_event("validate", %{"customer" => customer_params}, socket) do
    changeset =
      socket.assigns.customer
      |> Accounts.change_customer(customer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"customer" => customer_params}, socket) do
    case Accounts.get_customer_data_by_user_id(socket.assigns[:current_user].id) do
      nil ->
        save_customer(socket, customer_params)

      %Customer{} = customer ->
        update_customer(socket, customer, customer_params)
    end
  end

  defp update_customer(socket, customer, customer_params) do
    case Accounts.update_customer(socket.assigns[:current_user], customer, customer_params) do
      {:ok, _customer} ->
        {:noreply,
        socket
        |> put_flash(:info, "Customer updated successfully")
        |> push_redirect(to: Routes.complete_order_show_customer_data_path(socket, :show_customer_data))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_customer(socket, customer_params) do
    case Accounts.create_customer(socket.assigns[:current_user], customer_params) do
      {:ok, _customer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Customer created successfully")
         |> push_redirect(to: Routes.complete_order_show_customer_data_path(socket, :show_customer_data))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
