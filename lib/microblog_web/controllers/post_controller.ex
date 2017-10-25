# Attribute to Prof Nathaniel Tuck's class notes and code and Christine Chen's redirect
defmodule MicroblogWeb.PostController do
  use MicroblogWeb, :controller

  alias Microblog.Blog
  alias Microblog.Blog.Post

  def index(conn, _params) do
  posts = Blog.list_posts()
  current_user = conn.assigns[:current_user]
    if current_user do
      users = Enum.map(posts, fn(s) -> s.user_id end)
      posts = Blog.list_posts()
      changeset = Blog.change_post(%Post{})
      render(conn, "index.html", posts: posts, changeset: changeset)
    else
      conn 
      |> redirect(to: "/users/new")
      |> halt()
    end
  end

  def new(conn, _params) do
  posts = Blog.list_posts()
  current_user = conn.assigns[:current_user]
  conn.assigns[:current_user]
  users = Enum.map(posts, fn(s) -> s.user_id end)
    if current_user do 
      changeset = Blog.change_post(%Post{})
      render(conn, "new.html", users: users, changeset: changeset)
    else
      conn 
      |> redirect(to: "/users/new")
      |> halt()
    end
  end

  def create(conn, %{"post" => post_params}) do
    case Blog.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Enum.join([post_path(conn, :show, post), "#post"], ""))
        # |> redirect(to: post_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    posts = Blog.list_posts()
    current_user = conn.assigns[:current_user]
    conn.assigns[:current_user]
    users = Enum.map(posts, fn(s) -> s.user_id end)
      if current_user && current_user==post.user_id do 
        changeset = Blog.change_post(post)
        render(conn, "edit.html", post: post, changeset: changeset)
      else
        conn 
        |> redirect(to: "/users/new")
        |> halt()
      end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id)

    case Blog.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    {:ok, _post} = Blog.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
