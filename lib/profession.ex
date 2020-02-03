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
    # header, la ligne contenant les attributs
    # professions, les lignes contenant les infos d'une profession par ligne
    # professionsStream, le Stream des lignes lues du CSV

    professionsStream = File.stream!(Path.join("data", "technical-test-professions.csv"))
      |> Stream.map(&String.trim(&1))
      |> Stream.map(&String.split(&1, ","))

    header = Enum.take(professionsStream, 1)
      |> Enum.at(0)
      |> Enum.map(fn x -> String.to_atom(x) end)

    professions = Enum.to_list(professionsStream)
      |> List.delete_at(0)

    Enum.map(professions, fn(professionRow) ->                                                                                                                                                                     
      # Map the header to each professionRow field
      Enum.zip(header, professionRow)
        |> Enum.into(%Profession{})

      end                                             
    )
  end
end
