# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Microblog.Repo.insert!(%Microblog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Microblog.Repo
alias Microblog.Accounts.User
alias Microblog.Blog.Post
alias Microblog.Accounts.Follow

Repo.delete_all(User)
Repo.delete_all(Post)
Repo.delete_all(Follow)

kathy = Repo.insert!(%User{name: "Kathy Li Zhang", username: "happylikathy", email: "happylikathy@hotmail.com"})
michael = Repo.insert!(%User{name: "Michael Wang", username: "vegeta", email: "wang.mich@husky.neu.edu"})
Repo.insert!(%User{name: "Admin", username: "Admin", email: "admin@admin.com", is_admin?: true})
Repo.insert!(%Post{title: "Post", content: "I am a post!", user_id: kathy.id})
Repo.insert!(%Post{title: "Vegeta <3", content: "I love Vegeta!", user_id: michael.id})
Repo.insert!(%Follow{user_id: kathy.id, follower_user_id: michael.id})


