defmodule TwixWeb.Schema.Types.Root do
  @moduledoc false

  use Absinthe.Schema.Notation

  alias TwixWeb.Resolvers.User, as: UserResolver
  alias TwixWeb.Resolvers.Post, as: PostResolver
  alias Crudry.Middlewares.TranslateErrors

  import_types TwixWeb.Schema.Types.User
  import_types TwixWeb.Schema.Types.Post

  object :root_query do
    field :user, type: :user do
      arg :id, non_null(:id)
      resolve &UserResolver.get/2
    end
  end

  object :root_mutation do
    field :create_user, type: :user do
      arg :input, non_null(:create_user_input)
      resolve &UserResolver.create/2
      middleware TranslateErrors
    end

    field :update_user, type: :user do
      arg :input, non_null(:update_user_input)
      resolve &UserResolver.update/2
      middleware TranslateErrors
    end

    field :create_post, type: :post do
      arg :input, non_null(:create_post_input)
      resolve &PostResolver.create/2
      middleware TranslateErrors
    end

    field :add_like_post, type: :post do
      arg :id, non_null(:id)
      resolve &PostResolver.add_likes/2
    end

    field :add_follower, type: :add_follower_response do
      arg :input, non_null(:add_followers_input)
      resolve &UserResolver.add_follower/2
      middleware TranslateErrors
    end
  end

  object :root_subscription do
    field :new_follower, :add_follower_response do
      config fn _args, _context ->
        {:ok, topic: "new_follow_topic"}
      end
      resolve fn _args, _contexto ->
        {:ok, %{}}
      end
    end
  end
end
