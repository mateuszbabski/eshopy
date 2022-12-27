defmodule Eshopy.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :decimal

    belongs_to :brand, Eshopy.Catalog.Brand, foreign_key: :brand_id

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> cast_assoc(:brand)
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
  end
end
