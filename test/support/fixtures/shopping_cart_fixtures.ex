defmodule Eshopy.ShoppingCartFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eshopy.ShoppingCart` context.
  """

  @doc """
  Generate a cart_item.
  """
  def cart_item_fixture(attrs \\ %{}) do
    {:ok, cart_item} =
      attrs
      |> Enum.into(%{

      })
      |> Eshopy.ShoppingCart.create_cart_item()

    cart_item
  end

  @doc """
  Generate a cart.
  """
  def cart_fixture(attrs \\ %{}) do
    {:ok, cart} =
      attrs
      |> Enum.into(%{

      })
      |> Eshopy.ShoppingCart.create_cart()

    cart
  end
end
