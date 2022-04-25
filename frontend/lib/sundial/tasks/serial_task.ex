defmodule Sundial.Tasks.SerialTask do
  defstruct [:id, :board_id, :description, :details, :details_plaintext, :deadline,
             :completed_on, :is_overdue, :status, :status_desc, :deadline_parsed,
             :completed_on_parsed, :position, :index]
end
