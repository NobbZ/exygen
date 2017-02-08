defmodule Exygen do
  @on_definition __MODULE__.Compiler

  @moduledoc """
  Thanks to this module you can get some kind of uniformicity to your documentation.

  After `use`ing this module you can use some special syntax in your function and
  macro documentation.

  There are some specialtags defined, which you can use:

  * `@param <name> <description>`: Describes the argument `<name>` of the function.
    You should use the same name here as in a bodyless-clause. A parameter that
    is documented but not found in the list of parameters will cause an error
    during compilation. The arguments described are ordered the same way as in
    the function head. The defaults of an argument are also printed if applicable.
  """

  defmacro __using__(_opts) do
    quote do
      # @before_compile unquote(__MODULE__).Compiler
      @on_definition  unquote(__MODULE__).Compiler
    end
  end
end

defmodule FooBar do
  use Exygen

  @moduledoc false

  @doc """
  @param list Barbaratz!
    Rabatzer
  """
  def foo(list, atom \\ :a)
  def foo([], _), do: nil
  def foo([_|t], a), do: foo t, a

  @doc false
  def bar(), do: nil
end
