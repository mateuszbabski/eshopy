defmodule Eshopy.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias Eshopy.Repo

  alias Eshopy.Catalog.Product
  alias Eshopy.Catalog.Brand
  alias Eshopy.Catalog.Category

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product) |> Repo.preload([:brand, :category])
  end

  @doc """
  Returns the list of products which have available field set to 'true'.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_available_products() do
    query =
      from p in Product,
      where: p.available == true

    Repo.all(query) |> Repo.preload([:brand, :category])
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id) |> Repo.preload([:brand, :category])

  def get_product(id), do: Repo.get(Product, id) |> Repo.preload([:brand, :category])

  def get_products_by_brand_id(brand_id) do
    query =
      from p in Product,
      where: p.brand_id == ^brand_id

    Repo.all(query)
  end

  def get_products_by_category_id(category_id) do
    query =
      from p in Product,
      where: p.category_id == ^category_id

    Repo.all(query)
  end

  def get_available_products_by_brand_id(brand_id) do
    query =
      from p in Product,
      where: p.brand_id == ^brand_id,
      where: p.available == true

    Repo.all(query)
  end

  def get_available_products_by_category_id(category_id) do
    query =
      from p in Product,
      where: p.category_id == ^category_id,
      where: p.available == true

    Repo.all(query)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    brand = get_brand!(attrs["brand_id"])
    category = get_category!(attrs["category_id"])

    %Product{}
    |> Product.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:brand, brand)
    |> Ecto.Changeset.put_assoc(:category, category)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    brand = get_brand!(attrs["brand_id"])
    category = get_category!(attrs["category_id"])

    product
    |> Product.changeset(attrs)
    |> Ecto.Changeset.put_change(:brand_id, brand.id)
    |> Ecto.Changeset.put_change(:category_id, category.id)
    |> Repo.update()
  end

  @doc """
  Updates/changes product's availability.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def change_product_availability(%Product{} = product, attrs \\ %{}) do
    if product.available == true do
      product
      |> Product.availability_changeset(attrs)
      |> Ecto.Changeset.put_change(:available, false)
      |> Repo.update()
    else
      product
      |> Product.availability_changeset(attrs)
      |> Ecto.Changeset.put_change(:available, true)
      |> Repo.update()
    end
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  alias Eshopy.Catalog.Brand

  @doc """
  Returns the list of brands.

  ## Examples

      iex> list_brands()
      [%Brand{}, ...]

  """
  def list_brands do
    Repo.all(Brand)
  end

  @doc """
  Gets a single brand.

  Raises `Ecto.NoResultsError` if the Brand does not exist.

  ## Examples

      iex> get_brand!(123)
      %Brand{}

      iex> get_brand!(456)
      ** (Ecto.NoResultsError)

  """
  def get_brand!(id), do: Repo.get!(Brand, id)

  @doc """
  Creates a brand.

  ## Examples

      iex> create_brand(%{field: value})
      {:ok, %Brand{}}

      iex> create_brand(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_brand(attrs \\ %{}) do
    %Brand{}
    |> Brand.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a brand.

  ## Examples

      iex> update_brand(brand, %{field: new_value})
      {:ok, %Brand{}}

      iex> update_brand(brand, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_brand(%Brand{} = brand, attrs) do
    brand
    |> Brand.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a brand.

  ## Examples

      iex> delete_brand(brand)
      {:ok, %Brand{}}

      iex> delete_brand(brand)
      {:error, %Ecto.Changeset{}}

  """
  def delete_brand(%Brand{} = brand) do
    Repo.delete(brand)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking brand changes.

  ## Examples

      iex> change_brand(brand)
      %Ecto.Changeset{data: %Brand{}}

  """
  def change_brand(%Brand{} = brand, attrs \\ %{}) do
    Brand.changeset(brand, attrs)
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
