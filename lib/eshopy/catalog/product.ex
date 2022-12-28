defmodule Eshopy.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :decimal

    belongs_to :brand, Eshopy.Catalog.Brand, foreign_key: :brand_id
    belongs_to :category, Eshopy.Catalog.Category, foreign_key: :category_id

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> cast_assoc(:brand)
    |> cast_assoc(:category)
    |> validate_required([:name, :description, :sku])
    |> validate_price()
    |> unique_constraint(:sku)
  end

  defp validate_price(changeset) do
    changeset
    |> validate_required(:unit_price, message: "Price has to be set and be greater than 0")
    |> validate_number(:unit_price, greater_than: 0)
  end
end
