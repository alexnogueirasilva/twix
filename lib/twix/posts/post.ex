defmodule Twix.Posts.Post do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Twix.Users.User

  @required_fields [:text, :user_id]

  schema "posts" do
    field :text, :string
    field :likes, :integer, default: 0

    belongs_to :user, User
    timestamps()
  end

  def changeset(post \\ %__MODULE__{}, params) do
    post
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:text, min: 1, max: 140)
    |>foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id)
  end
end
