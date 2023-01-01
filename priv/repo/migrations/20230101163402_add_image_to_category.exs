defmodule Eshopy.Repo.Migrations.AddImageToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :image_upload, :string
    end
  end
end
