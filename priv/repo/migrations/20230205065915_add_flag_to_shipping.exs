defmodule Eshopy.Repo.Migrations.AddFlagToShipping do
  use Ecto.Migration

  def change do
    alter table(:shippings) do
      add :available, :boolean
    end
  end
end
