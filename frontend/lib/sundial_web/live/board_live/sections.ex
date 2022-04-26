defmodule SundialWeb.BoardLive.Sections do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import Phoenix.HTML
  import Phoenix.HTML.Link

  alias SundialWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.JS
  alias Sundial.Boards.SerialBoard
  alias Sundial.API.BoardAPI

  def actions(%{assigns: assigns}) do
    if assigns.board["actions_allowed"] do
      ~H"""
      <div style="position: absolute; right: 23px; bottom: 20px; display: grid;">
        <%= live_patch to: Routes.board_index_path(@socket, :edit, %SerialBoard{id: assigns.board["id"]}), id: "edit-board", phx_update: "ignore" do %>
        <%= #link to: "/" do %>
          <ion-icon name="pencil-outline" class="is-clickable action-button" style="color:#122329;"></ion-icon>
        <% end %>
        <a id={"delete-board-" <> Integer.to_string(assigns.board["id"])} phx-update="ignore" phx-click="delete" phx-value-id={assigns.board["id"]} data-confirm="This board will be deleted. Are you sure?" phx-target={assigns.myself}>
          <ion-icon name="trash-outline" class="is-clickable action-button" style="color:#122329;"></ion-icon>
        </a>
      </div>
      """
    else
      ~H"""
      """
    end
  end
end
