defmodule EshopyWeb.HomeLive do
  alias Eshopy.Catalog
  use EshopyWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :categories, Catalog.list_categories())}
  end

  # @impl true
  # def handle_event() do

  # end
end
