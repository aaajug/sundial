defmodule SundialWeb.BoardController do
  use SundialWeb, :controller

  alias Sundial.API.BoardAPI
  alias Sundial.API.ClientAPI
  alias SundialWeb.SessionHandler

  def create(conn, %{"board" => board_params}) do
    access_token = SessionHandler.fetch_current_user_access_token(conn)
    client = ClientAPI.client(access_token)

    response = BoardAPI.create_board(client, %{"data" => board_params})

    IO.inspect response, label: "createboardcontr"

    conn
      |> put_flash(:info, "Board created successfully.")
      |> redirect(to: "/boards")
  end
end
