defmodule Twix.Users.Action.Get do
  @moduledoc false

  alias Twix.Repo
  alias Twix.Users.User

  def call(id) do
   case Repo.get(User, id)  do
     nil ->
       {:error, :not_found}
     user ->
       {:ok, Repo.preload(user, followers: [:follower], followings: [:following])}
    end
  end
end
