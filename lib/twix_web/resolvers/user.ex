defmodule TwixWeb.Resolvers.User do
  @moduledoc false

  def get(%{id: id}, _context), do: Twix.get_user(id)
  def create(%{input: params}, _context), do: Twix.create_user(params)
  def update(%{input: params}, _context), do: Twix.update_user(params)
  def add_follower(%{input: %{user_id: user_id, follower_id: follower_id}}, _context),
      do: Twix.add_follower(user_id, follower_id)
end
