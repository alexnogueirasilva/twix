defmodule Twix do
  @moduledoc """
  Twix keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Twix.Users
  alias Twix.Posts
  alias Twix.Followers.Action.Follower

  defdelegate create_user(params), to: Users.Action.Create, as: :call
  defdelegate update_user(params), to: Users.Action.Update, as: :call
  defdelegate get_user(id), to: Users.Action.Get, as: :call

  defdelegate create_post(params), to: Posts.Action.Create, as: :call
  defdelegate add_likes(id), to: Posts.Action.AddLikes, as: :call

  defdelegate add_follower(user_id, follower_id), to: Follower, as: :call
end
