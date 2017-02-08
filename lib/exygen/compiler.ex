defmodule Exygen.Compiler do
  @moduledoc false

  alias Exygen.DocInfo

  def __on_definition__(env, kind, _name, args, _guards, _body) when kind in [:def, :defmacro] do
    module = env.module
    case Module.get_attribute(module, :doc) do
      {line, doc} when is_binary(doc) ->
        doc
        |> parse_doc(args)
        |> put_doc(env, line)

        :ok
      {_n, false} ->
        :ok
      nil ->
        :ok
    end
  end

  defp parse_doc(doc, args) do
    doc
    |> String.split(~r/\r?\n/)
    |> parse_lines(args, DocInfo.new)

    doc
  end

  defp parse_lines(_lines, _args, _docinfo), do: nil

  defp put_doc(doc, env, linum), do: Module.put_attribute(env.module, :doc, {linum, doc})
end
