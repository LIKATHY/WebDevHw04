# Attribute to Prof Nathaniel Tuck's class notes and code
defmodule Microblog.Helpers do
  def is_admin?(nil), do: false
  def is_admin?(user) do
    user.is_admin?
  end
end
