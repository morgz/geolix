defmodule Geolix.Adapter do
  @moduledoc """
  Adapter behaviour module.
  """


  @doc """
  Loads a given database into Geolix.
  """
  @callback load_database(map) :: :ok

  @doc """
  Looks up IP information.

  The passed `opts` are expected to contain a key `:where` to define
  which database should be queried. If that key is not set then `nil`
  should be returned instead.
  """
  @callback lookup(ip :: tuple, opts :: Keyword.t) :: map | nil
end