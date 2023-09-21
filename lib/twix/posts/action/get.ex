defmodule Twix.Posts.Action.Get do
  @moduledoc false

  alias Twix.Posts.Post
  alias Twix.Repo

  import Ecto.Query

  def call(user, page, per_page) do
    query = from p in Post,
      where: p.user_id == ^user.id,
      order_by: [desc: p.id],
      offset: ^((page - 1) * per_page),
      limit: ^per_page

    {:ok, Repo.all(query)}
  end
end
