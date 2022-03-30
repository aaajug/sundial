defmodule SundialWeb.TaskLive.Sections do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import Phoenix.HTML
  alias SundialWeb.Router.Helpers, as: Routes

  alias Phoenix.LiveView.JS

  def timestamps(%{assigns: assigns}) do
    ~H"""
    <%= if assigns.task.deadline do %>
      <span class="tag is-tiny-text is-danger is-light is-letter-spaced-0 mt-2">
        Due: <%= assigns.task.deadline %>
      </span>
    <% end %>

    <%= if assigns.task.completed_on do %>
      <span class="tag is-tiny-text is-success is-light is-letter-spaced-0 mt-2">
        Completed: <%= assigns.task.completed_on %>
      </span>
    <% end %>
    """
  end

  def header(%{assigns: assigns, status: status}) do
    ~H"""
    <div class="header mt-3 py-1">
      <p class="is-size-6 has-text-weight-semibold mb-0">
        <%= assigns.task.description %>
      </p>
      <p class="is-size-7 is-letter-spaced-0">
        <span class="is-italic"><%= assigns.task.status_desc %></span>
        <%= if status == "overdue" do %>
          <span class="has-text-weight-bold">&nbsp;&bull; OVERDUE</span>
        <% end %>
      </p>
    </div>
    """
  end

  def content(%{assigns: assigns, options: options}) do
    ~H"""
    <% is_truncated = if Map.has_key?(options, :truncated) do
                        options.truncated
                      else
                        false
                      end %>

    <% class = "content is-mini-text #{if is_truncated, do: "truncated"}"  %>

    <div class="card-content p-0 pt-2">
      <div class={class}>
        <%= raw assigns.task.details %>
      </div>
    </div>
    """
  end

  def actions(%{assigns: assigns}) do
    ~H"""
    <div class="">
      <%= live_patch to: Routes.task_index_path(@socket, :edit, assigns.task) do %>
        <ion-icon name="pencil-outline" class="is-clickable action-button"></ion-icon>
      <% end %>
      <ion-icon name="trash-outline" class="is-clickable action-button"></ion-icon>
    </div>
    """
  end

  def state_actions(%{assigns: assigns}) do
    task_status = assigns.task.status

    ~H"""
    <div class="state-actions-container absolute">
      <%= for status <- assigns.status do %>
        <%= unless status.name == task_status do %>
          <a phx-click="update_status" phx-target={assigns.myself} phx-value-status={status.id}>
            <button class={"has-tooltip-arrow has-tooltip-right action-state-link " <> status.name} data-tooltip={"Set " <> status.name} type="submit">
              <ion-icon name="ellipse" class={status.name}></ion-icon> <br>
            </button>
          </a>
        <% end %>
      <% end %>
    </div>
    """
  end
end
