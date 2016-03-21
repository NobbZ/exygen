defmodule Exygen.Compiler do
  @moduledoc false

  def __on_definition__(env, kind, _name, args, _guards, _body) when kind in [:def, :defmacro] do
    module = env.module
    case Module.get_attribute(module, :doc) do
      doc when is_binary(doc) ->
        doc
        |> parse_doc(args)
        |> put_doc(env)

        :ok
      doc when doc in [nil, false] ->
        :ok
    end
  end

  defp parse_doc(doc, _args), do: doc

  defp put_doc(doc, env), do: Module.put_attribute(env.module, :doc, {env.line, doc})
end
