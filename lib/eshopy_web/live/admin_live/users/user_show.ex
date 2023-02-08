defmodule EshopyWeb.AdminLive.UserShow do
  use EshopyWeb, :live_view

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
    changeset = Accounts.change_user_role(Accounts.get_user!(id))

    socket
    |> assign(:page_title, "Show user")
    |> assign(:user, Accounts.get_user_with_data(id))
    |> assign(:changeset, changeset)
  end

  @impl true
  def handle_event("save", %{"user" => %{"role" => role}}, socket) do
    if socket.assigns[:user].id == socket.assigns[:current_user].id do
      {:noreply,
        socket
        |> put_flash(:info, "Unauthorized")}
    else
      {:ok, user} = Accounts.update_user_role(socket.assigns[:user], %{"role" => role})

      {:noreply,
      socket
      |> assign(:user, Accounts.get_user_with_data(user.id))}
    end
  end
end
