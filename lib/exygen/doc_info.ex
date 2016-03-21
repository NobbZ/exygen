defmodule Exygen.DocInfo do
  @moduledoc """
  Defines types and functions to handle information about a single "section" of
  documentation.

  This is meant for internal use only.
  """

  defstruct body: [], params: [], returns: [], since: nil, deprecated: false
  @type t :: %__MODULE__{body: body_info,
                         params: [param_info],
                         returns: [return_info],
                         since: nil | Version.t,
                         deprecated: false | deprecation_info}
  @type body_info :: [String.t]
  @type param_info :: {atom, String.t} | {atom, String.t, String.t}
  @type return_info :: {String.t, String.t}
  @type deprecation_info :: {Version.t, Version.t, String.t}

  @doc """
  Creates a new DocInfo.
  """
  def new(), do: %__MODULE__{}
end
