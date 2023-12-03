defmodule SchemaTest do
  use ExUnit.Case
  use TwixWeb.ConnCase, async: true

  describe "users query" do
    test "returns a user", %{conn: conn} do
      user_parmas = %{nickname: "Jose", age: 18, email: "jose@devaction.com"}

      {:ok, user} = Twix.create_user(user_parmas)

      query = """
        {
          user(id: #{user.id}) {
            nickname
            age
            email
          }
        }
      """

      expected_response = %{"data" => %{"user" => %{"age" => 18, "email" => "jose@devaction.com", "nickname" => "Jose"}}}
      response =
      conn
      |> post("/api/graphql", %{query: query})
      |> json_response(200)

      assert response == expected_response
    end

    test "when there is an error, returns an error", %{conn: conn} do
      query = """
        {
          user(id: 99) {
            nickname
            age
            email
          }
        }
      """

      expected_response =
        %{
          "errors" => [
            %{
              "message" => "not_found",
              "path" => ["user"],
              "locations" => [
                %{
                  "column" => 5,
                  "line" => 2
                }
              ]
            }
          ],
          "data" =>
          %{
            "user" => nil
          }
        }

      response =
      conn
      |> post("/api/graphql", %{query: query})
      |> json_response(200)

      assert response == expected_response
    end
  end

  describe "users mutation" do
    test "when the params are valid, create the user", %{conn: conn} do

      query = """
        mutation {
          createUser(
            input: {
              nickname: "Bruna",
              email: "bruna@gmail.com.br",
              age: 20,
            }
          ) {
            id
            nickname
            email
            age
          }
        }
      """

      response =
      conn
      |> post("/api/graphql", %{query: query})
      |> json_response(200)

      assert %{"data" => %{"createUser" => %{"age" => 20, "email" => "bruna@gmail.com.br", "id" => _id, "nickname" => "Bruna"}}} = response
    end
  end

  describe "subscription" do
    test "new follow", %{socket: socket} do
      user_parmas = %{nickname: "Jose1", age: 19, email: "jose1@devaction.com"}

      {:ok, user1} = Twix.create_user(user_parmas)

      user_parmas = %{nickname: "Jose2", age: 33, email: "jose2@devaction.com"}

      {:ok, user2} = Twix.create_user(user_parmas)

      mutation = """
        mutation{
          addFollower(input: {userId: #{user1.id}, followerId: #{user2.id}}){
            followerId
            followingId
          }
        }
      """

      subscription = """
        subscription{
          newFollower{
            followerId
            followingId
          }
        }
      """

      #setup subscription
      socket_ref = push_doc(socket, subscription)
      assert_reply socket_ref, :ok, %{subscriptionId: subscription_id}

      #setup mutation
      socket_ref = push_doc(socket, mutation)
      assert_reply socket_ref, :ok, mutation_response

      #assert subscription
      expected_response = %{
        data: %{"addFollower" => %{"followerId" => "#{user2.id}", "followingId" => "#{user1.id}"}}
      }
      assert mutation_response == expected_response

      #assert subscription
      assert_push "subscription:data", subscription_response

      expected_sub_response = %{
        result: %{
          data: %{
            "newFollower" => %{
              "followerId" => "#{user2.id}", "followingId" => "#{user1.id}"}}},
        subscriptionId: "#{subscription_id}"
      }

      assert subscription_response == expected_sub_response
    end
  end
end
