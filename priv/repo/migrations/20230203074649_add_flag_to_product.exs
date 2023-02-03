defmodule Eshopy.Repo.Migrations.AddFlagToProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :available, :boolean
    end
  end
end
