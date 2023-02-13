defmodule EshopyWeb.Presence do
  use Phoenix.Presence,
    otp_app: :eshopy,
    pubsub_server: Eshopy.PubSub
end
