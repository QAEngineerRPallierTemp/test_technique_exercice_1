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

    Job.draw_cn_by_ct(jobs, professions)
  end
end
