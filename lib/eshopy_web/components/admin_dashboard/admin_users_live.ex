defmodule EshopyWeb.AdminUsersLive do
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
          |> redirect(to: Routes.home_path(socket, :home))}

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
      |> redirect(to: Routes.home_path(socket, :home))}
  end
end
