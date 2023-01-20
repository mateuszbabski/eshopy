defmodule Eshopy.DeliveryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eshopy.Delivery` context.
  """

  @doc """
  Generate a shipping.
  """
  def shipping_fixture(attrs \\ %{}) do
    {:ok, shipping} =
      attrs
      |> Enum.into(%{
        name: "some name",
        price: "120.5"
      })
      |> Eshopy.Delivery.create_shipping()

    shipping
  end
end
