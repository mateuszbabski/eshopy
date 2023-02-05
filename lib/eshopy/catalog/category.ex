defmodule Eshopy.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    field :image_upload, :string

    has_many :products, Eshopy.Catalog.Product, on_delete: :nilify_all

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :image_upload])
    |> validate_required([:name])
  end
end
