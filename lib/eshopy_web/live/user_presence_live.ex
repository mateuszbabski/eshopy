defmodule EshopyWeb.UserPresenceLive do
  use EshopyWeb, :live_component

  alias EshopyWeb.Presence

  #@topic "user_presence"

  def update(_assigns, socket) do
    {:ok,
      socket
      |> assign_user_presence()}
  end

  defp assign_user_presence(socket) do
    assign(socket, :user_presence, Presence.list_online_users())
  end

  # defp extract_ids_from_list() do
  #   Enum.map(Presence.list_online_users(), fn {k, _v} -> k end)
  # end
end
