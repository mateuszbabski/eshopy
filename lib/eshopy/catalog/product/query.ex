defmodule Eshopy.Catalog.Product.Query do
  import Ecto.Query
  alias Eshopy.Catalog.Product
  alias Eshopy.Catalog.Category
  alias Eshopy.Catalog.Brand

  def base, do: Product

  def join_category(query \\ base() ) do
    query
    |> join(:left, [p], c in Category, on: p.category_id == c.id)
  end

  def join_brand(query \\ base()) do
    query
    |> join(:left, [p], b in Brand, on: p.brand_id == b.id)
  end
end
