# Attribute to Prof Nathaniel Tuck's class notes and code
defmodule Microblog.Repo.Migrations.AddPassword do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :password_hash, :string
  end
  end
end
