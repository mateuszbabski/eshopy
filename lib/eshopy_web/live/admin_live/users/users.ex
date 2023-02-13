defmodule EshopyWeb.AdminLive.Users do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)

    case user.role do
      :user ->
        {:ok,
          socket
          |> assign(:current_user, user)
          |> put_flash(:info, "Unauthorized")
          |> redirect(to: Routes.home_index_path(socket, :index))}

      :admin ->
        {:ok,
          socket
          |> assign(:current_user, user)
          |> assign(:users, Accounts.list_users())}
    end
  end

  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> put_flash(:info, "Unauthorized")
      |> redirect(to: Routes.home_index_path(socket, :index))}
  end

  @impl true
  def handle_event("save", params, socket) do
    IO.inspect(params)

    {:noreply, socket}
  end
end
