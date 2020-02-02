defmodule TestTechniqueExercice1.Job do
  alias TestTechniqueExercice1.{Job}

  @moduledoc """
  Documentation for `TestTechniqueExercice1.Job`.
  """

  @doc """
  Structure d'un Job ou Offre.

  ## Examples

      iex> %TestTechniqueExercice1.Job{}
      %TestTechniqueExercice1.Job{profession_id: nil, contract_type: nil, name: nil, office_latitude: nil, office_longitude: nil}

  """
  defstruct [:profession_id, :contract_type, :name, :office_latitude, :office_longitude]

  defimpl Collectable, for: Job do
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
    jobs = nil
    jobsStream = nil

    jobsStream = File.stream!(Path.join("data", "technical-test-jobs.csv"))
      |> Stream.map(&String.trim(&1))
      |> Stream.map(&String.split(&1, ","))

    header = Enum.take(jobsStream, 1) |> Enum.at(0) |> Enum.map(fn x -> String.to_atom(x) end)
    jobs = Enum.to_list(jobsStream) |> List.delete_at(0)

    Enum.map(jobs, fn(jobRow) ->                                                                                                                                                                              
      # Map the header to each jobRow field                                                                                                                                                                    
      jobRow = Enum.zip(header, jobRow) |> Enum.into(%Job{})
      # Do some processing with the jobRow

      end                                             
    )
  end
end
