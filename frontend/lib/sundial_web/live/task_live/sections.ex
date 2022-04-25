defmodule SundialWeb.TaskLive.Sections do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import Phoenix.HTML
  import Phoenix.HTML.Link

  alias SundialWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.JS
  alias Sundial.Tasks.SerialTask
  alias Sundial.API.TaskAPI

  def timestamps(%{assigns: assigns}) do
    ~H"""
    <%= if assigns.task["deadline"] do %>
      <span class="tag is-tiny-text is-danger is-light is-letter-spaced-0 mt-2">
        Due: <%= assigns.task["deadline"] %>
      </span>
    <% end %>

    <%= if assigns.task["completed_on"] do %>
      <span class="tag is-tiny-text is-success is-light is-letter-spaced-0 mt-2">
        Completed: <%= assigns.task["completed_on"] %>
      </span>
    <% end %>
    """
  end

  def header(%{assigns: assigns, status: status}) do
    ~H"""
    <div class="header mt-3 py-1">
      <p class="is-size-6 has-text-weight-semibold mb-0">
        <%= assigns.task["description"] %>
      </p>
      <p class="is-size-7 is-letter-spaced-0">
        <span class="is-italic"><%= assigns.task["status_desc"] %></span>
        <%= if status == "overdue" do %>
          <span class="has-text-weight-bold">&nbsp;&bull; OVERDUE</span>
        <% end %>
      </p>
    </div>
    """
  end

  def content(%{assigns: assigns, options: options}) do
    container_class = if Map.has_key?(options, :container_class) do
      options.container_class
    else
      ""
    end
    ~H"""
    <% is_truncated = if Map.has_key?(options, :truncated) do
                        options.truncated
                      else
                        false
                      end %>

    <% class = "content is-mini-text #{if is_truncated, do: "truncated"}"  %>

    <div class={"card-content p-0 pt-2" <> container_class}>
      <div class={class}>
        <%= raw assigns.task["details"] %>
        <%= #Jason.encode!(@content_item.quill) %>
      </div>
    </div>
    """
  end

  # TODO: links for API editing
  def actions(%{assigns: assigns}) do
    # #IO.inspect assigns
    ~H"""
    <div class="">
      <%= live_patch to: Routes.list_index_path(@socket, :show_task, assigns.task["board_id"], assigns.task["id"], %{return_to: "/boards/" <> Integer.to_string(assigns.task["board_id"]) <> "/tasks/" <> Integer.to_string(assigns.task["id"])}), id: "show-task" do %>
        <ion-icon name="open" class="is-clickable action-button"></ion-icon>
      <% end %> <br>
      <%= live_patch to: Routes.list_index_path(@socket, :edit_task, %SerialTask{id: assigns.task["id"]}, %{return_to: @return_to}), id: "edit-task" do %>
      <%= #link to: "/" do %>
        <ion-icon name="pencil-outline" class="is-clickable action-button"></ion-icon>
      <% end %>
      <a id={"delete-task-" <> Integer.to_string(assigns.task["id"])} phx-click="delete" phx-value-id={assigns.task["id"]} phx-value-return_to={@return_to} data-confirm="This task will be deleted. Are you sure?" phx-target={assigns.myself}>
        <ion-icon name="trash-outline" class="is-clickable action-button"></ion-icon>
      </a>
    </div>
    """
  end

  def actions_inline(%{assigns: assigns}) do
    # #IO.inspect assigns
    ~H"""
    <div class="">
      <%= live_patch to: Routes.list_index_path(@socket, :edit_task, %SerialTask{id: assigns.task["id"]}, %{return_to: @return_to}), id: "edit-task", style: "cursor:pointer;text-decoration:underline;" do %>
        edit
      <% end %>
      <a id={"delete-task-" <> Integer.to_string(assigns.task["id"])} phx-click="delete" phx-value-id={assigns.task["id"]} phx-value-return_to={@return_to} data-confirm="This task will be deleted. Are you sure?" phx-target={assigns.myself} style="cursor:pointer;text-decoration:underline;">
        <!--ion-icon name="trash-outline" class="is-clickable action-button"></ion-icon-->
        delete
      </a>
    </div>
    """
  end


  def state_actions(%{assigns: assigns}) do
    status_states = [
      %{description: "Not yet started", id: 1, name: "initial"},
      %{description: "In progress", id: 2, name: "started"},
      %{description: "On hold", id: 3, name: "paused"},
      %{description: "Completed", id: 4, name: "completed"}
    ]

    task_status = assigns.task["status"]

    ~H"""
    <div class="state-actions-container absolute">
      <%= for status <- status_states do %>
        <%= unless status.name == task_status do %>
          <a id={"state-action-" <> status.name} phx-click="update_status" phx-target={assigns.myself} phx-value-status={status.id} phx-value-return_to={@return_to}>
            <button class={"has-tooltip-arrow has-tooltip-right action-state-link " <> status.name} data-tooltip={"Set " <> status.name} type="submit">
              <ion-icon name="ellipse" class={status.name}></ion-icon> <br>
            </button>
          </a>
        <% end %>
      <% end %>
    </div>
    """
  end

  def assignee(%{assigns: assigns}) do
    assignee = case assigns.task["assignee"] do
      nil -> "Unnassigned"
      "" -> "Unnassigned"
      _ -> assigns.task["assignee"]
    end

    ~H"""
    <div class="assignee-container">
        <span class="icon-text is-italic pr-2">
          <span style="font-size: 0.65rem;"><%= assignee %></span>
          <span class="icon is-size-7"><ion-icon name="person-circle"></ion-icon></span>
        </span>
      </div>
    """
  end

  def assignee_label(%{assigns: assigns}) do
    assignee = case assigns.task["assignee"] do
      nil -> "Unnassigned"
      "" -> "Unnassigned"
      _ -> assigns.task["assignee"]
    end

    ~H"""
      <span class="icon-text pr-2">
        <span class="icon is-size-7"><ion-icon name="person-circle"></ion-icon></span>
        <span style="font-size: 0.65rem;"><%= assignee %></span>
      </span>
    """
  end
end
