defmodule Eshopy.ShoppingCart.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_items" do
    field :price, :decimal
    field :quantity, :integer

    belongs_to :cart, Eshopy.ShoppingCart.Cart, foreign_key: :cart_id
    belongs_to :product, Eshopy.Catalog.Product, foreign_key: :product_id

    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:price, :quantity])
    |> validate_required([:price, :quantity])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
  end
end
