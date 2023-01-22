defmodule Eshopy.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :total_price, :decimal

    belongs_to :user, Eshopy.Accounts.User, foreign_key: :user_id
    has_many :order_items, Eshopy.Orders.OrderItem

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total_price])
    |> validate_required([:total_price])
    |> validate_number(:total_price, greater_than: 0)
  end
end
