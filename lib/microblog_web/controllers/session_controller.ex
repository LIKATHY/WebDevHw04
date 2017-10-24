# Attribute to Prof Nathaniel Tuck's class notes and code
defmodule MicroblogWeb.SessionController do
  use MicroblogWeb, :controller

  alias Microblog.Accounts

  def update_tries(throttle, prev) do
    if throttle do
      prev + 1
    else
      1
    end
  end

    def get_and_auth_user(email, password) do
    user = Accounts.get_user_by_email(email)
    case Comeonin.Argon2.check_pass(user, password) do
      {:ok, user} -> user
      _else       -> nil
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    user = get_and_auth_user(email, password)

    if user do

      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as #{user.email}")
      |> redirect(to: post_path(conn, :index))
    else
      conn
      |> put_session(:user_id, nil)
      |> put_flash(:error, "Sorry, incorrect email or password")
      |> redirect(to: user_path(conn, :new))
    end
  end

  def logout(conn, _args) do
    conn
    |> put_session(:user_id, nil)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: user_path(conn, :new))
  end
end