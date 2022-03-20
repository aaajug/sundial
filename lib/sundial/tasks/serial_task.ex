defmodule Sundial.Tasks.SerialTask do
  defstruct [:id, :description, :details, :deadline, :completed_on, :is_overdue, :status, :status_desc]
end
