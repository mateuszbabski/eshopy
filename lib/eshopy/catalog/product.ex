defmodule Eshopy.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :decimal
    field :image_upload, :string
    field :available, :boolean, default: true

    belongs_to :brand, Eshopy.Catalog.Brand, foreign_key: :brand_id
    belongs_to :category, Eshopy.Catalog.Category, foreign_key: :category_id

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload, :available])
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

  def availability_changeset(product, attrs) do
    product
    |> cast(attrs, [:available])
    |> validate_required([:available])
    |> case do
      %{changes: %{available: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :available, "Error with changing product's availability")
    end
  end
end
