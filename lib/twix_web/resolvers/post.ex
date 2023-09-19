defmodule TwixWeb.Resolvers.Post do
  @moduledoc false

  def create(%{input: params}, _context), do: Twix.create_post(params)
  def add_likes(%{id: id}, _context), do: Twix.add_likes(id)
end
