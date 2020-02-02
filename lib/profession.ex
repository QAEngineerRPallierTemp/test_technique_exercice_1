defmodule TestTechniqueExercice1.Profession do
  alias TestTechniqueExercice1.{Profession}

  @moduledoc """
  Documentation for `TestTechniqueExercice1.Profession`.
  """

  @doc """
  Structure d'une Profession.

  ## Examples

      iex> %TestTechniqueExercice1.Profession{}
      %TestTechniqueExercice1.Profession{id: nil, name: nil, category_name: nil}

  """
  defstruct [:id, :name, :category_name]

  defimpl Collectable, for: Profession do
    def into(original) do
      {original, fn
        map, {:cont, {k, v}} -> :maps.put(k, v, map)
        map, :done -> map
        _, :halt -> :ok
      end}
    end
  end

  def all do
    header = nil
    professions = nil
    professionsStream = nil

    professionsStream = File.stream!(Path.join("data", "technical-test-professions.csv"))
      |> Stream.map(&String.trim(&1))
      |> Stream.map(&String.split(&1, ","))

    header = Enum.take(professionsStream, 1) |> Enum.at(0) |> Enum.map(fn x -> String.to_atom(x) end)
    professions = Enum.to_list(professionsStream) |> List.delete_at(0)

    Enum.map(professions, fn(professionRow) ->                                                                                                                                                                              
      # Map the header to each professionRow field                                                                                                                                                                    
      professionRow = Enum.zip(header, professionRow) |> Enum.into(%Profession{})
      # Do some processing with the professionRow

      end                                             
    )
  end
end
