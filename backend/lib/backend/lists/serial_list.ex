defmodule Backend.Lists.SerialList do
  @derive Jason.Encoder
  defstruct [:id, :board_id, :title, :position, :owner_id, :tasks,
             :actions_allowed, :delete_allowed]
end
