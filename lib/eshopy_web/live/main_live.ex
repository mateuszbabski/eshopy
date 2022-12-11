defmodule EshopyWeb.MainLive do
  use EshopyWeb, :live_view

  alias EshopyWeb.HomePage

  @impl true
  def render(assigns) do
    ~L"""
    <%= if @live_action == :home do %>
      <%= live_component HomePage
      %>
    <% end %>
    """
  end
end
