defmodule Twix.Posts.Action.AddLikes do
  @moduledoc false

  alias Twix.Repo
  alias Twix.Posts.Post
  alias Ecto.Changeset

  def call(id) do
    case Repo.get(Post, id)  do
      nil ->  {:error, :not_found}
      post -> add_likes(post)
    end
  end

  defp add_likes(post) do
    likes = post.likes + 1
    post = Changeset.change(post, likes: likes)

    Repo.update(post)
  end
end
