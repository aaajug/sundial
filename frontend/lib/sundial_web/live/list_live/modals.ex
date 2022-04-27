defmodule SundialWeb.ListLive.ModalContents do
  import SundialWeb.Live.Task.TaskModalComponent
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import Phoenix.HTML
  import Phoenix.HTML.Link

  alias SundialWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.JS
  alias Sundial.Tasks.SerialTask
  alias Sundial.API.TaskAPI

  def task_form(%{assigns: assigns}) do
    ~H"""
    <.live_component
      module={SundialWeb.TaskLive.FormComponent}
      id={@task.id || :new}
      title={@page_title}
      action={@live_action}
      task={@task}
      list_id={@list_id}
      current_user_access_token={@current_user_access_token}
      board_id={@board_id}
      status={@status}
      serial_task={@serial_task}
      return_to={@return_target}
      form_target={@form_target}
    />
    """
  end

  def list_form(%{assigns: assigns}) do
    ~H"""
    <.live_component
      module={SundialWeb.ListLive.FormComponent}
      id={@list.id || :new}
      title={@page_title}
      action={@live_action}
      list={@list}
      current_user_access_token={@current_user_access_token}
      return_to={@return_target}
    />
    """
  end

end
