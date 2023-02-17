defmodule EshopyWeb.UserChannel do
  use EshopyWeb, :channel

  alias EshopyWeb.Presence

  @topic "user_presence"

  @impl true
  def join(@topic, _payload, socket) do
    send(self(), :after_join)

    {:ok, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    case socket.assigns do
      %{user_id: user_id} ->
        track_user_presence(user_id, socket)
        push(socket, "presence_state", Presence.list(socket))

        {:noreply, socket}

      _ ->
        {:noreply, socket}
      end
  end

  defp track_user_presence(user_id, socket) do
    {:ok, _} =
      Presence.track(socket, user_id, %{users: [%{online_at: inspect(System.system_time(:second))}]})
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (users).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
