defmodule Eshopy.Delivery do
  @moduledoc """
  The Delivery context.
  """

  import Ecto.Query, warn: false
  alias Eshopy.Repo

  alias Eshopy.Delivery.Shipping

  @doc """
  Returns the list of shippings.

  ## Examples

      iex> list_shippings()
      [%Shipping{}, ...]

  """
  def list_shippings do
    Repo.all(Shipping)
  end

  @doc """
  Gets a single shipping.

  Raises `Ecto.NoResultsError` if the Shipping does not exist.

  ## Examples

      iex> get_shipping!(123)
      %Shipping{}

      iex> get_shipping!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shipping!(id), do: Repo.get!(Shipping, id)

  def get_shipping_price(id) do
    query =
      from s in Shipping,
      where: s.id == ^id,
      select: s.price

    Repo.one(query)
  end

  @doc """
  Creates a shipping.

  ## Examples

      iex> create_shipping(%{field: value})
      {:ok, %Shipping{}}

      iex> create_shipping(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shipping(attrs \\ %{}) do
    %Shipping{}
    |> Shipping.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shipping.

  ## Examples

      iex> update_shipping(shipping, %{field: new_value})
      {:ok, %Shipping{}}

      iex> update_shipping(shipping, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shipping(%Shipping{} = shipping, attrs) do
    shipping
    |> Shipping.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shipping.

  ## Examples

      iex> delete_shipping(shipping)
      {:ok, %Shipping{}}

      iex> delete_shipping(shipping)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shipping(%Shipping{} = shipping) do
    Repo.delete(shipping)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shipping changes.

  ## Examples

      iex> change_shipping(shipping)
      %Ecto.Changeset{data: %Shipping{}}

  """
  def change_shipping(%Shipping{} = shipping, attrs \\ %{}) do
    Shipping.changeset(shipping, attrs)
  end
end
