defmodule Twix.Users.Action.Update do
  @moduledoc false

  alias Twix.Repo
  alias Twix.Users.User

  def call(%{id: id} = params) do
    case Repo.get(User, id)  do
      nil ->  {:error, :not_found}
      user -> update_user(user, params)
    end
  end

  defp update_user(user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end
end
