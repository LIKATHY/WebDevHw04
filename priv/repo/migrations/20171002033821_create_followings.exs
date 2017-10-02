defmodule Microblog.Repo.Migrations.CreateFollowings do
  use Ecto.Migration

  def change do
    create table(:followings) do
      add :user_id, references(:users, on_delete: :nothing)
      add :follower_user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:followings, [:user_id])
    create index(:followings, [:follower_user_id])
  end
end
