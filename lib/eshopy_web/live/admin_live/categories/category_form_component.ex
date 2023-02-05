defmodule EshopyWeb.AdminLive.CategoryFormComponent do
  use EshopyWeb, :live_component

  alias Eshopy.Catalog

  @impl true
  def update(%{category: category} = assigns, socket) do
    changeset = Catalog.change_category(category)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:image_upload, category.image_upload || nil )
     |> allow_upload(:image,
      accept: ~w(.jpg .jpeg .png),
      max_entries: 1,
      max_file_size: 9_000_000,
      auto_upload: true,
      progress: &handle_progress/3)}
  end

  @impl true
  def handle_event("validate", %{"category" => category_params}, socket) do
    changeset =
      socket.assigns.category
      |> Catalog.change_category(category_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"category" => category_params}, socket) do
    save_category(socket, socket.assigns.action, category_params)
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

  defp save_category(socket, :edit, params) do
    case Catalog.update_category(socket.assigns.category, category_params(socket, params)) do
      {:ok, _category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_category(socket, :new, params) do
    case Catalog.create_category(category_params(socket, params)) do
      {:ok, _category} ->
        {:noreply,
          socket
          |> put_flash(:info, "Category created successfully")
          |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp category_params(socket, params) do
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
