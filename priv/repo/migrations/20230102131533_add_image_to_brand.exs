defmodule Eshopy.Repo.Migrations.AddImageToBrand do
  use Ecto.Migration

  def change do
    alter table(:brands) do
      add :image_upload, :string
    end
  end
end
