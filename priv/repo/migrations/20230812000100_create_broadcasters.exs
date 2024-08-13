defmodule Ratemynews.Repo.Migrations.CreateBroadcasters do
  use Ecto.Migration

  def change do
    create table(:broadcasters) do
      add :name, :string, null: false
      add :mode_of_broadcast, :string, null: false
      add :origin, :string, null: false
      add :topics, :string, null: false
      add :profile_image_url, :string
      add :upvotes, :integer, default: 0
      add :downvotes, :integer, default: 0

      timestamps()
    end
  end
end
