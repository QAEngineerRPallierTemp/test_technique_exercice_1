defmodule TestTechniqueExercice1 do
  @moduledoc """
  Documentation for `TestTechniqueExercice1`.
  """

  @doc """
  Affichage du nombre d'offres par catégorie de profession par type de contrat.

  ## Examples

      iex> TestTechniqueExercice1.launch()
      ------------------------------------- 
      |            |   TOTAL   |   TECH   | 
      | ---------- | --------- | -------- | 
      | TOTAL      |     1     |     1    | 
      | ---------- | --------- | -------- | 
      | FULL_TIME  |     1     |     1    | 
      | ---------- | --------- | -------- | 
      | INTERNSHIP |     0     |     0    | 
      ------------------------------------- 
 
  """

  def launch do
    alias TestTechniqueExercice1.{Job, Profession}

    jobs = Job.all()
    professions = Profession.all()

    IO.inspect Enum.at(jobs, 0)
    IO.inspect Enum.at(professions, 0)

    ctSizeMax = String.length(
        Enum.max_by(
        jobs, fn x -> String.length(x.contract_type) end
      ).contract_type
    )

    IO.puts ctSizeMax

    Job.get_cn_by_ct(jobs, professions)
  end
end
