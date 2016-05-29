defmodule Geolix.Adapter.MMDB2.Storage.Metadata do
  @moduledoc """
  Geolix metadata storage.

  ## Usage

      iex> alias Geolix.Adapter.MMDB2.Metadata
      iex> set(:some_database_name, %Metadata{ database_type: "doctest" })
      :ok
      iex> get(:some_database_name)
      %Metadata{ database_type: "doctest" }
      iex> get(:some_database_name, :database_type)
      "doctest"

      iex> get(:unregistered_database)
      nil
      iex> get(:unregistered_database, :database_type)
      nil
  """

  alias Geolix.Adapter.MMDB2.Metadata

  @name Geolix.Adapter.MMDB2.Names.storage(:metadata)


  @doc """
  Starts the metadata agent.
  """
  @spec start_link() :: Agent.on_start
  def start_link(), do: Agent.start_link(fn -> %{} end, name: @name)

  @doc """
  Fetches a metadata entry for a database.
  """
  @spec get(atom) :: Metadata.t | nil
  def get(database) do
    Agent.get(@name, &Map.get(&1, database, nil))
  end

  @doc """
  Returns the value of the requested key from a metadata entry.

  If either the key or the whole metadata entry are not found then `nil` will
  be returned.
  """
  @spec get(atom, atom) :: any
  def get(database, key) do
    case get(database) do
      nil      -> nil
      metadata -> Map.get(metadata, key, nil)
    end
  end

  @doc """
  Returns the names of all registered metadata entries.
  """
  @spec registered() :: list
  def registered() do
    Agent.get(@name, &Map.keys/1)
  end

  @doc """
  Stores a set of metadata for a specific database.
  """
  @spec set(atom, Metadata.t) :: :ok
  def set(database, %Metadata{} = metadata) do
    Agent.update(@name, &Map.put(&1, database, metadata))
  end
end
