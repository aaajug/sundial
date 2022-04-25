defmodule Backend.Tasks.SerialTask do
  @derive Jason.Encoder
  defstruct [:id, :board_id, :list_id, :author, :assignee, :description, :details, :details_plaintext, :deadline,
             :completed_on, :is_overdue, :status_id, :status, :status_desc, :deadline_parsed,
             :completed_on_parsed, :position, :index, :comments]
end
