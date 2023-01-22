defmodule Eshopy.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eshopy.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        total_price: "120.5"
      })
      |> Eshopy.Orders.create_order()

    order
  end

  @doc """
  Generate a order_item.
  """
  def order_item_fixture(attrs \\ %{}) do
    {:ok, order_item} =
      attrs
      |> Enum.into(%{

      })
      |> Eshopy.Orders.create_order_item()

    order_item
  end
end
