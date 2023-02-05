defmodule Eshopy.Catalog.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "brands" do
    field :name, :string
    field :image_upload, :string

    has_many :products, Eshopy.Catalog.Product, on_delete: :nilify_all

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :image_upload])
    |> validate_required([:name])
  end
end
