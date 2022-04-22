defmodule SundialWeb.ListController do
  use SundialWeb, :controller

  alias Sundial.API.ListAPI
  alias Sundial.API.ClientAPI
  alias SundialWeb.SessionHandler

  def create(conn, %{"id" => board_id}), do: create(conn, %{"id" => board_id, "list" => nil})
  def create(conn, %{"id" => board_id, "list" => list_params}) do
    access_token = SessionHandler.fetch_current_user_access_token(conn)
    client = ClientAPI.client(access_token)

    response = ListAPI.create_list(client, board_id, %{"list" => list_params})

    IO.inspect response, label: "createlistcontr"

    # TODO: fix redirect, use dyanmic return_to
    conn
      |> put_flash(:info, "List created successfully.")
      |> redirect(to: "/boards/1")
  end
end
