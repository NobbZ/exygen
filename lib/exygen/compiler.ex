defmodule Exygen.Compiler do
  @moduledoc false

  @newline [:n, :rn]

  alias Exygen.DocInfo

  def __on_definition__(env, kind, _name, args, _guards, _body) when kind in [:def, :defmacro] do
    module = env.module
    case Module.get_attribute(module, :doc) do
      {_line, doc} when is_binary(doc) ->
        doc
        |> tokenize
        |> parse_doc(args)
        # |> put_doc(env, line)

        :ok
      {_line, false} ->
        :ok
      nil ->
        :ok
    end
  end

  defp tokenize(doc) do
    doc
    |> Stream.unfold(&do_tokenize/1)
    |> Enum.into([]) |> IO.inspect
    |> Stream.transform(%{last: nil}, &consolidate_tokens/2)
    |> Enum.into([]) |> IO.inspect
  end

  defp do_tokenize(:eof), do: nil
  defp do_tokenize(""), do: {:eof, :eof}
  defp do_tokenize("\r\n" <> rest), do: {:rn, rest}
  defp do_tokenize("\n" <> rest), do: {:n, rest}
  defp do_tokenize(string) do
    case Regex.split(~r/(\b|$)/m, string, parts: 2) do
      [token, rest] -> {token, rest}
      [token] -> {token, ""}
      [] -> nil
    end
  end

  defp consolidate_tokens(curr, state = %{last: "@"}) when is_binary(curr),
    do: {["@" <> curr], %{state | last: nil}}
  defp consolidate_tokens(curr, state = %{last: nil}) when curr in @newline,
    do: {[curr], %{state | last: curr}}
  defp consolidate_tokens(curr, state = %{last: last}) when curr in @newline,
    do: {[last], %{state | last: curr}}
  defp consolidate_tokens(curr, state = %{last: last}) when last in @newline and is_binary(curr) do
    if curr |> String.trim |> Kernel.==("") do
      {[:continue, curr], %{state | last: nil}}
    else
      {[last, curr], %{state | last: nil}}
    end
  end
  defp consolidate_tokens("@", state = %{}), do: {[], %{state | last: "@"}}
  defp consolidate_tokens(curr, state = %{}), do: {[curr], state}

  defp parse_doc(tokens, _args) do
    tokens
    |> Enum.into([])
    |> IO.inspect

    tokens
  end

  # defp put_doc(doc, env, linum), do: Module.put_attribute(env.module, :doc, {linum, doc})
end
