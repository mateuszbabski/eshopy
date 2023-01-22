defmodule Eshopy.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    field :price, :decimal
    field :quantity, :integer

    belongs_to :order, Eshopy.Orders.Order, foreign_key: :order_id
    belongs_to :product, Eshopy.Catalog.Product, foreign_key: :product_id


    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:price, :quantity])
    |> validate_required([:price, :quantity])
  end
end
