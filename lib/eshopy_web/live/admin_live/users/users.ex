defmodule EshopyWeb.AdminLive.Users do
  use EshopyWeb, :live_view

  alias Eshopy.Accounts
  alias EshopyWeb.UserPresenceLive

  @topic "user_presence"

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
        EshopyWeb.Endpoint.subscribe(@topic)

        {:ok,
          socket
          |> assign(:current_user, user)
          |> assign(:user_presence_component_id, "user_presence")
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
  # def handle_info(%{event: "presence_state"}, socket) do
  #   send_update(
  #     UserPresenceLive,
  #     id: socket.assigns.user_presence_component_id)

  #   {:noreply, socket}
  # end

  def handle_info(%{event: "presence_diff"}, socket) do
    send_update(
      UserPresenceLive,
      id: socket.assigns.user_presence_component_id)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", params, socket) do
    IO.inspect(params)

    {:noreply, socket}
  end
end
