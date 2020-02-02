defmodule TestTechniqueExercice1 do
  @moduledoc """
  Documentation for `TestTechniqueExercice1`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TestTechniqueExercice1.hello()
      :world

  """
  
  def launch do
    alias TestTechniqueExercice1.{Job, Profession}

    jobs = Job.all()
    professions = Profession.all()

    IO.inspect Enum.at(jobs, 0)
    IO.inspect Enum.at(professions, 0)
  end
end
