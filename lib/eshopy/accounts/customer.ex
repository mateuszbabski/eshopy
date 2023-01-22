defmodule Eshopy.Accounts.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :city, :string
    field :country, :string
    field :lastname, :string
    field :name, :string
    field :postal, :string
    field :street, :string
    field :telephone_number, :string

    belongs_to :user, Eshopy.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :lastname, :country, :city, :street, :postal, :telephone_number])
    |> validate_required([:name, :lastname, :country, :city, :street, :postal, :telephone_number])
  end
end
