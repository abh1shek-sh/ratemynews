
defmodule Ratemynews.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :broadcaster_id, references(:broadcasters, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :vote_type, :integer, null: false

      timestamps()
    end

    create index(:votes, [:broadcaster_id])
    create index(:votes, [:user_id])
  end
end
