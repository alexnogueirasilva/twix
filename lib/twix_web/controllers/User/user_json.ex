defmodule TwixWeb.User.UserJSON do
  @moduledoc false

  def index(%{data: %{users: users}}) do
    %{users: for(user <- users, do: user(user))}
  end

  defp user(user) do
    %{
      id: user.id,
      nickname: user.nickname,
      age: user.age,
      email: user.email
    }
  end
end
