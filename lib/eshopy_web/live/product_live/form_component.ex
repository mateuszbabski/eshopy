defmodule EshopyWeb.ProductLive.FormComponent do
  use EshopyWeb, :live_component

  alias Eshopy.Catalog

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)

    {:ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
      |> assign(:brands, Catalog.list_brands())
      |> assign(:categories, Catalog.list_categories())
      |> assign(:image_upload, product.image_upload || nil)
      |> allow_upload(:image,
        accept: ~w(.jpg .jpeg .png),
        max_entries: 1,
        max_file_size: 9_000_000,
        auto_upload: true,
        progress: &handle_progress/3)}
  end

  @impl true
  def handle_event("validate", %{"product" => params}, socket) do
   changeset =
     socket.assigns.product
     |> Catalog.change_product(params)
     |> Map.put(:action, :validate)

   {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => params}, socket) do
    save_product(socket, socket.assigns.action, params)
  end

  defp handle_progress(:image, entry, socket) do
    if entry.done? do
      path =
        consume_uploaded_entry(
          socket,
          entry,
          &upload_static_file(&1, socket)
        )
      {:noreply,
        socket
        |> put_flash(:info, "file #{entry.client_name} uploaded")
        |> assign(:image_upload, path)}
    else
      {:noreply,
        socket
        |> put_flash(:info, "file upload error")}
    end
  end

  defp upload_static_file(%{path: path}, socket) do
    dest = Path.join("priv/static/images/", Path.basename(path))
    File.cp!(path, dest)
    {:ok, Routes.static_path(socket, "/images/#{Path.basename(dest)}")}
  end

  defp save_product(socket, :edit, params) do
    case Catalog.update_product(socket.assigns.product, product_params(socket, params)) do
    {:ok, _product} ->
      {:noreply,
        socket
        |> put_flash(:info, "Product updated successfully")
        |> push_redirect(to: socket.assigns.return_to)}

    {:error, %Ecto.Changeset{} = changeset} ->
      {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, params) do
    case Catalog.create_product(product_params(socket, params)) do
      {:ok, _product} ->
        {:noreply,
          socket
          |> put_flash(:info, "Product created successfully")
          |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp product_params(socket, params) do
    Map.put(params, "image_upload", socket.assigns.image_upload)
  end

  def upload_image_error(%{image: %{errors: errors}}, entry) when length(errors) > 0 do
    {_, msg} =
      Enum.find(errors, fn {ref, _} ->
        ref == entry.ref || ref == entry.upload_ref
      end)

      upload_error_msg(msg)
  end

  def upload_image_error(_, _), do: ""

  defp upload_error_msg(msg) do
    case msg do
      :not_accepted -> "Invalid file type"
      :too_many_files -> "Too many files"
      :too_large -> "File exceeds max size"
    end
  end
end
