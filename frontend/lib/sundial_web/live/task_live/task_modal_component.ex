defmodule SundialWeb.Live.Task.TaskModalComponent do
  use Phoenix.LiveDashboard.Web, :live_component

  def task_modal(assigns) do
    render(assigns)
  end

  def render(assigns) do
    ~H"""
    <div id={@id} class="modal is-active"
      tabindex="-1"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={"##{@id}"}
      phx-page-loading>

      <div class="modal-background"></div>

      <style>
        .modal {
          opacity: 1!important;
          position: fixed;
          z-index: 1;
          left: 0;
          bottom: 0;
          width: 100%;
          height: 100%;
          overflow: auto;
          background-color: rgba(0,0,0,0.4);
          display: relative;
        }

        .modal-content {
          background-color: white !important;
          padding: 120px 60px;
          box-shadow: 5px 0px 10px #141414;
          width: 70%;
          height: 80vh;
          position: relative;
          overflow: hidden;
          position: absolute;
          bottom: 0;
          border-radius: 20px 20px 0px 0px;
        }

        .close {
          font-size: 28px;
          font-weight: bold;
          position: absolute;
          top: 30px;
          right: 30px;
        }
      </style>

      <div class="modal-content">
        <div class="modal-dialog modal-lg">
            <div class="modal-header">
              <%= live_patch raw("&times;"), to: @return_to, class: "close" %>
            </div>
            <div class="modal-body">
              <.live_component module={SundialWeb.Live.Task.TaskShowComponent} id="task-show-modal" task={assigns.task} />
            </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
