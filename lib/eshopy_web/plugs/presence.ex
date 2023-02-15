defmodule EshopyWeb.Presence do
  use Phoenix.Presence,
    otp_app: :eshopy,
    pubsub_server: Eshopy.PubSub

  alias EshopyWeb.Presence

  @topic "user_presence"
  def list_online_users() do
    Presence.list(@topic)
    |> Enum.map(&extract_users/1)
  end

  defp extract_users({user_id, %{metas: metas}}) do
    {user_id, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(metas_list) do
    Enum.map(metas_list, &users_from_meta_map/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp users_from_meta_map(meta_map) do
    get_in(meta_map, [:users])
  end
end
