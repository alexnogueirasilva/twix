defmodule TwixWeb.User.UserController do
  @moduledoc false

  use TwixWeb, :controller
  use Absinthe.Phoenix.Controller, schema: TwixWeb.Schema, action: [mode: :internal]

  @graphql """
  query {
    users {
      id
      nickname
      age
      email
      followers {
        follower_id
        follower {
          id
          nickname
          age
          email
        }
      }
      followings {
        following_id
        following {
          id
          nickname
          age
          email
        }
      }
    }
  }

  """

  def index(conn, %{data: data}) do
    conn
    |> put_status(:ok)
    |> render(:index, data: data)
  end
end
