defmodule Eshopy.ShoppingCart do
  @moduledoc """
  The ShoppingCart context.
  """

  import Ecto.Query, warn: false
  alias Eshopy.Repo

  alias Eshopy.ShoppingCart.Cart
  alias Eshopy.ShoppingCart.CartItem
  alias Eshopy.Accounts.User
  alias Eshopy.Catalog.Product
  alias Eshopy.Catalog

  @doc """
  Returns the list of cart_items.

  ## Examples

      iex> list_cart_items()
      [%CartItem{}, ...]

  """
  def list_cart_items() do
    Repo.all(CartItem)
  end

  def list_cart_items(cart_id) do
    query =
      from item in CartItem,
      where: item.cart_id == ^cart_id,
      order_by: [desc: item.price]

    Repo.all(query) |> Repo.preload(:product)
  end

  @doc """
  Gets a single cart_item.

  Raises `Ecto.NoResultsError` if the Cart item does not exist.

  ## Examples

      iex> get_cart_item!(123)
      %CartItem{}

      iex> get_cart_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart_item!(id), do: Repo.get!(CartItem, id)

  @doc """
  Creates a cart_item.

  ## Examples

      iex> create_cart_item(%{field: value})
      {:ok, %CartItem{}}

      iex> create_cart_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart_item(attrs \\ %{}) do
    %CartItem{}
    |> CartItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cart_item.

  ## Examples

      iex> update_cart_item(cart_item, %{field: new_value})
      {:ok, %CartItem{}}

      iex> update_cart_item(cart_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart_item(%CartItem{} = cart_item, attrs) do
    cart_item
    |> CartItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cart_item.

  ## Examples

      iex> delete_cart_item(cart_item)
      {:ok, %CartItem{}}

      iex> delete_cart_item(cart_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart_item(%CartItem{} = cart_item) do
    Repo.delete(cart_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart_item changes.

  ## Examples

      iex> change_cart_item(cart_item)
      %Ecto.Changeset{data: %CartItem{}}

  """
  def change_cart_item(%CartItem{} = cart_item, attrs \\ %{}) do
    CartItem.changeset(cart_item, attrs)
  end

  @doc """
  Returns the list of carts.

  ## Examples

      iex> list_carts()
      [%Cart{}, ...]

  """
  def list_carts do
    Repo.all(Cart)
  end

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart!(id), do: Repo.get!(Cart, id)

  def get_cart_with_items(id), do: Repo.get!(Cart, id) |> Repo.preload([:cart_items])

  def get_cart_by_user_id(user_id) do
    query =
      from c in Cart,
      where: c.user_id == ^user_id

    Repo.one(query)
  end

  def get_cart_by_user_id_with_cart_items(user_id) do
    Repo.one(
      from(c in Cart,
        where: c.user_id == ^user_id,
        left_join: i in assoc(c, :cart_items),
        left_join: p in assoc(i, :product),
        preload: [cart_items: {i, product: p}]
      )
    )
  end

  def get_cart_by_user_id_with_items(user_id), do: Repo.get_by(Cart, [user_id: user_id]) |> Repo.preload([:cart_items])

  def reload_cart(id), do: get_cart_with_items(id)

  @doc """
  Creates a cart.

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_cart(attrs \\ %{}) do
  #   %Cart{}
  #   |> Cart.changeset(attrs)
  #   |> Repo.insert()
  # end

  def create_cart(%User{} = user, attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Creates an item and adds it to the cart.

  Cart is created while adding first Product to the cart
  (in the case of cart doesnt exist yet)

  Creates association with specific product and cart.

  In the case of conflict function updates the quantity and total price.

  ## Examples

      iex> add_item_to_cart(%Cart{}, %Product{}, quantity)
      {:ok, %CartItem{}}

      iex> add_item_to_cart(%Cart{}, %Product{}, quantity)
      {:error, %Ecto.Changeset{}}

  """

  def add_item_to_cart(%Cart{} = cart, %Product{} = product, quantity \\ 1) do
    %CartItem{}
    |> CartItem.changeset(%{quantity: quantity, price: Decimal.mult(product.unit_price, quantity)})
    |> Ecto.Changeset.put_assoc(:product, product)
    |> Ecto.Changeset.put_assoc(:cart, cart)
    |> Repo.insert(
      conflict_target: [:cart_id, :product_id],
      on_conflict: [inc: [quantity: quantity, price: Decimal.mult(product.unit_price, quantity)]]
    )
  end

   def increase_quantity_by_one(item_id, %Cart{} = cart) do
    item = get_cart_item!(item_id)
    product = Catalog.get_product!(item.product_id)

    item
    |> CartItem.changeset(%{quantity: item.quantity + 1, price: Decimal.add(item.price, product.unit_price)})
    |> Repo.update()

    {:ok, reload_cart(cart.id)}
   end

  def decrease_quantity_by_one(item_id, %Cart{} = cart) do
    item = get_cart_item!(item_id)
    product = Catalog.get_product!(item.product_id)

    item
    |> CartItem.changeset(%{quantity: item.quantity - 1, price: Decimal.sub(item.price, product.unit_price)})
    |> Repo.update()

    {:ok, reload_cart(cart.id)}
   end

  @doc """
  Removes specific item from the cart
  """
  def remove_item_from_cart(%Cart{} = cart, product_id) do
    query =
      from item in CartItem,
      where: item.cart_id == ^cart.id,
      where: item.product_id == ^product_id

    Repo.delete_all(query)

    {:ok, reload_cart(cart.id)}
  end

  @doc """
  Updates a cart.

  ## Examples

      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}

      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart(%Cart{} = cart, attrs) do
    cart
    |> Cart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.

  ## Examples

      iex> change_cart(cart)
      %Ecto.Changeset{data: %Cart{}}

  """
  def change_cart(%Cart{} = cart, attrs \\ %{}) do
    Cart.changeset(cart, attrs)
  end
  @doc """
  Returns a full price of shopping cart basis on user_id

  """

  def total_cart_price(user_id) do
    cart = get_cart_by_user_id_with_cart_items(user_id)

    Enum.reduce(cart.cart_items, 0, fn cart_item, acc ->
      cart_item.price
      |> Decimal.add(acc)
    end)
  end
end
