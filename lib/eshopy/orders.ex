defmodule Eshopy.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Eshopy.ShoppingCart
  alias Eshopy.Repo

  alias Eshopy.Orders.Order
  alias Eshopy.Orders.OrderItem

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  def list_orders_by_user_id(user_id) do
    query =
      from o in Order,
      where: o.user_id == ^user_id

    Repo.all(query)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Gets a single order with associated order items, products and shipping.

  Returns nil if the Order does not exist.

  ## Examples

      iex> get_order_with_items(123)
      %Order{}

      iex> get_order_with_items(456)
      nil

  """
  def get_order_with_items(id) do
    query =
      from o in Order,
      where: o.id == ^id,
      left_join: i in assoc(o, :order_items),
      left_join: p in assoc(i, :product),
      inner_join: s in assoc(o, :shipping),
      preload: [:shipping, order_items: {i, product: p}]

    Repo.one(query)
  end

  @doc """
  Gets a single order with associated order items, products and shipping.

  Returns nil if the Order does not exist.

  ## Examples

      iex> get_full_order_by_user_id(1, 123)
      %Order{}

      iex> get_full_order_by_user_id(1, 456)
      nil

  """
  def get_full_order_by_user_id(user_id, id) do
    query =
      from o in Order,
      where: o.user_id == ^user_id,
      where: o.id == ^id,
      left_join: i in assoc(o, :order_items),
      left_join: p in assoc(i, :product),
      inner_join: s in assoc(o, :shipping),
      preload: [:shipping, order_items: {i, product: p}]

    Repo.one(query)
  end

  @doc """
  Gets a single order with associated order items, products and shipping
  which status is marked as :in_progress.

  Returns nil if the Order does not exist.

  ## Examples

      iex> get_order_in_progress(1)
      %Order{}

      iex> get_order_in_progress(100)
      nil

  """
  def get_order_in_progress(user_id) do
    query =
      from o in Order,
      where: o.user_id == ^user_id,
      where: o.status == :in_progress,
      left_join: i in assoc(o, :order_items),
      left_join: p in assoc(i, :product),
      inner_join: s in assoc(o, :shipping),
      preload: [:shipping, order_items: {i, product: p}]

    Repo.one(query)
  end


  @doc """
  Creates an order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an order with cart and shipping structs passed.

  Cart items from %Cart{} are mapped to order_items and passed into
  newly created %Cart{}

  ## Examples

      iex> create_order(%Cart{}, %Shipping{})
      {:ok, %Order{}}

      iex> create_order(%Cart{}, %Shipping{})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_from_cart(cart, shipping) do
    order_items =
      Enum.map(cart.cart_items, fn cart_item ->
        %{product_id: cart_item.product_id, price: cart_item.price, quantity: cart_item.quantity}
      end)

    order =
      Ecto.Changeset.change(%Order{},
        user_id: cart.user_id,
        total_price: order_price(cart, shipping),
        shipping_id: shipping.id,
        order_items: order_items)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:order, order)
    # |> Ecto.Multi.run(:delete_shopping_cart, fn _repo, _changes ->
    #   ShoppingCart.delete_cart(cart)
    # end)
    |> Repo.transaction()
    |> case do
      {:ok, %{order: order}} -> {:ok, order}
      {:error, name, value, _} -> {:error, {name, value}}
    end
  end

  # def complete_order() do
    #get order with shipping
    #add customer data
    #add payment method
    #add user id
    #delete shopping cart
    #create completed_order
    #delete proceeding order
    #creates and returns invoice with full data
  # end

  defp order_price(cart, shipping) do
    Decimal.add(ShoppingCart.cart_price_by_id(cart.id), shipping.price)
  end

  @doc """
  Updates an order.

  ## Examples

      iex> update_order(order, %Cart{}, %Shipping{})
      {:ok, %Order{}}

      iex> update_order(order, %Cart{}, %Shipping{})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(order, cart, shipping) do
    updated_order_items =
      Enum.map(cart.cart_items, fn cart_item ->
        %{product_id: cart_item.product_id, price: cart_item.price, quantity: cart_item.quantity}
      end)

    updated_order =
      Ecto.Changeset.change(order,
        id: order.id,
        total_price: order_price(cart, shipping),
        shipping_id: shipping.id,
        order_items: updated_order_items)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:order, updated_order)
    |> Repo.transaction()
    |> case do
      {:ok, %{order: updated_order}} -> {:ok, updated_order}
      {:error, name, value, _} -> {:error, {name, value}}
    end
  end


  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end


  @doc """
  Returns the list of orderItems.

  ## Examples

      iex> list_orderItems()
      [%OrderItem{}, ...]

  """
  def list_order_items do
    Repo.all(OrderItem)
  end

  @doc """
  Gets a single orderItem.

  Raises `Ecto.NoResultsError` if the Order item does not exist.

  ## Examples

      iex> get_order_item!(123)
      %OrderItem{}

      iex> get_order_itemm!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item!(id), do: Repo.get!(OrderItem, id)

  @doc """
  Creates a order_item.

  ## Examples

      iex> create_order_item(%{field: value})
      {:ok, %OrderItem{}}

      iex> create_order_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_item(attrs \\ %{}) do
    %OrderItem{}
    |> OrderItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a orderItem.

  ## Examples

      iex> update_order_item(order_item, %{field: new_value})
      {:ok, %OrderItem{}}

      iex> update_order_item(order_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_item(%OrderItem{} = order_item, attrs) do
    order_item
    |> OrderItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a orderItem.

  ## Examples

      iex> delete_order_item(order_item)
      {:ok, %order_item{}}

      iex> delete_orderItem(order_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item(%OrderItem{} = order_item) do
    Repo.delete(order_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_item changes.

  ## Examples

      iex> change_orderItem(order_item)
      %Ecto.Changeset{data: %OrderItem{}}

  """
  def change_order_item(%OrderItem{} = order_item, attrs \\ %{}) do
    OrderItem.changeset(order_item, attrs)
  end
end
