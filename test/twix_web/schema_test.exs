defmodule SchemaTest do
  use ExUnit.Case
  use TwixWeb.ConnCase

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
end
