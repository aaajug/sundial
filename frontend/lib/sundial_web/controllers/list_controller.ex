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
    IO.inspect "SundialWeb.ListController create/2"

    access_token = SessionHandler.fetch_current_user_access_token(conn)
    client = ClientAPI.client(access_token)

    IO.inspect client, label: "SundialWeb.ListController client"

    response = ListAPI.create_list(client, board_id, %{"list" => list_params})

    IO.inspect response, label: "createlistcontr6"

    # TODO: fix redirect, use dyanmic return_to
    conn
      |> put_flash(:info, "List created successfully.")
      |> redirect(to: "/boards/1")
  end
end
