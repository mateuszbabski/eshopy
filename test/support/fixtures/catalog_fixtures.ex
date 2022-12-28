defmodule Eshopy.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eshopy.Catalog` context.
  """

  @doc """
  Generate a unique product sku.
  """
  def unique_product_sku, do: System.unique_integer([:positive])

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        sku: unique_product_sku(),
        unit_price: "120.5"
      })
      |> Eshopy.Catalog.create_product()

    product
  end

  @doc """
  Generate a brand.
  """
  def brand_fixture(attrs \\ %{}) do
    {:ok, brand} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Eshopy.Catalog.create_brand()

    brand
  end

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Eshopy.Catalog.create_category()

    category
  end
end
