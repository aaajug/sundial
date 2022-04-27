defmodule SundialWeb.ListController do
  use SundialWeb, :controller

  alias Sundial.API.ListAPI
  alias Sundial.API.ClientAPI
  alias SundialWeb.SessionHandler

  def create(conn, %{"id" => board_id}), do: create_list(conn, %{"id" => board_id, "list" => %{}})
  def create(conn, %{"id" => board_id, "list" => list_params}) do
    create_list(conn, %{"id" => board_id, "list" => list_params})
  end

  defp create_list(conn, %{"id" => board_id, "list" => list_params}) do
    access_token = SessionHandler.fetch_current_user_access_token(conn)
    client = ClientAPI.client(access_token)
    response = ListAPI.create_list(client, board_id, %{"list" => list_params})

    conn
      |> put_flash(:info, "List created successfully.")
      |> redirect(to: "/boards/" <> board_id)
  end
end
