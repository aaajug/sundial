defmodule Sundial.API.ResponseHelper do
  alias Sundial.API.Errors

  def parse(response) do
    IO.inspect response, label: "response debug in parse"
    {
      {:error, get_error_messages(response["error"])},
      {:success_info, get_info(response)},
      {:data, response["data"]}
    }
    # cond do
    #   Map.has_key?(response, "error") -> {:error, get_error_messages(response["error"])}
    #   # Map.has_key?(response, "data") -> {:data, get_data(response["data"])}
    #   Map.has_key?(response, "data") -> {:data, response["data"]}
    #   true -> {:info, response}
    # end
  end

  defp get_info(%{"success_info" => success_info}), do: success_info
  defp get_info(%{} = _response_body), do: get_info
  defp get_info(), do: nil
  defp get_info(response_body), do: response_body

  defp get_data(response_body) do
    # cond do
    #   Map.has_key?(response_body, "message") -> response_body["message"]
    #   true ->
    # end
  end

  defp get_error_messages(%{"errors" => errors}) do
    # "error" => %{
    #    "errors" => %{"email" => ["has already been taken"]},
    #   "message" => "Couldn't create user",
    #   "status" => 500
    # }
    # keys = response_body["errors"] |> Map.keys

    errors
      |> Enum.map(
        fn {key, error} ->
          {key, String.capitalize(key) <> " " <> Enum.at(error, 0) <> "."}
          # error_messages = Map.put(error_messages, key, String.capitalize(key) <> " " <> Enum.at(error, 0) <> ".")
          # IO.inspect error_messages, label: key <> " errorslogger (error messages)"
        end
      )
      |> Map.new
  end

  defp get_error_messages(response_body) do
    IO.inspect response_body, label: "response_body debug"
    cond do
      response_body == nil -> nil
      Map.has_key?(response_body, "message") -> response_body["message"]
      true -> nil
    end
  end

end
