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
  def hello do
    :world
  end

  def launch do
    alias TestTechniqueExercice1.{Job}

    jobs = Job.all()

    IO.inspect Enum.at(jobs, 0)
  end
end
