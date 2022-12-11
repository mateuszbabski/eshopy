defmodule EshopyWeb.MainLive do
  use EshopyWeb, :live_view

  alias EshopyWeb.AdminDashboard
  alias EshopyWeb.HomePage

  @impl true
  def render(assigns) do
    ~L"""
    <%= if @live_action == :home do %>
      <%= live_component HomePage
      %>
    <% end %>

    <%= if @live_action == :admin_dashboard do %>
      <%= live_component AdminDashboard
      %>
    <% end %>
    """
  end
end
