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
    # header, la ligne contenant les attributs
    # jobs, les lignes contenant les infos d'un job par ligne
    # jobsStream, le Stream des lignes lues du CSV

    jobsStream = File.stream!(Path.join("data", "technical-test-jobs.csv"))
      |> Stream.map(&String.trim(&1))
      |> Stream.map(&String.split(&1, ","))

    # On récupère la première de ligne qui réprésente les attributs
    # Elle est transformée en atom
    header = Enum.take(jobsStream, 1)
      |> Enum.at(0)
      |> Enum.map(fn x -> String.to_atom(x) end)

    # On récupère les lignes de job
    # Sauf la première
    jobs = Enum.to_list(jobsStream)
      |> List.delete_at(0)

    # Chaque ligne récupérée est transformée en %Job{}
    Enum.map(
      jobs,
      fn(jobRow) ->
        # Map the header to each jobRow field
        Enum.zip(header, jobRow)
          |> Enum.into(%Job{})
      end                                             
    )
  end

  def get_cn_by_ct(jobs, professions) do

    # On prépare la map qui contiendra le total par category_name
    # On lui ajoute la category_name par défaut "Aucune"
    cnTotaux = Enum.reduce professions, %{}, fn a, acc ->
      Map.put(acc, a.category_name, 0)
    end
    cnTotaux = Map.put(cnTotaux, "Aucune", 0)

    # Préparation du retour en regroupant les différents totaux
    totaux = Map.put(%{}, :cnTotaux, cnTotaux)
    totaux = Map.put(totaux, :ctTotaux, %{})
    totaux = Map.put(totaux, :totaux, 0)

    # Récupération d'un mapping id => category_name
    idByCategoryName = Enum.reduce(
      professions,
      %{},
      fn a, acc ->
        Map.put(acc, a.id, a.category_name)
      end
    )

    # On group par contract_type
    # En groupant on remplace l'id par category_name
    # Si la category_name n'existe pas alors on lui affecte "Aucune"
    cnByCt = Enum.group_by(
      jobs,
      fn x -> x.contract_type end,
      fn x -> (idByCategoryName[x.profession_id] || "Aucune") end
    )

    # On parcours l'ensemble des contract_type
    # Pour chaque contract_type les category_name sont comptés
    # Puis mappé en category_name => nb_category_name
    cnByCt = Enum.reduce(
      cnByCt,
      %{},
      fn a, acc ->
        {k, v} = a
        Map.put(
          acc,
          k,
          (
            Enum.reduce v, %{}, fn b, acc2 ->
              Map.put(acc2, b, (acc2[b] || 0) + 1)
            end
          )
        )
      end
    )

    totaux = Enum.reduce(
      cnByCt,
      totaux,
      fn a, acc ->
        {ctKey, ctValue} = a      

        acc = Map.put(
          acc,
          :cnTotaux,
          Enum.reduce(
            ctValue,
            acc[:cnTotaux],
            fn b, acc2 ->
              {k, v} = b
              Map.put(acc2, k, acc2[k] + v)
            end
          )
        )
        acc = Map.put(
          acc,
          :ctTotaux,
          Enum.reduce(
            ctValue,
            acc[:ctTotaux],
            fn b, acc2 ->
              {_k, v} = b
              Map.put(acc2, ctKey, (acc2[ctKey] || 0) + v)
            end
          )
        )
        Map.put(acc, :totaux, acc[:totaux]+ acc[:ctTotaux][ctKey])
      end
    )

    Map.put(totaux, :cnByCt, cnByCt)
  end

  def draw_cn_by_ct(jobs, professions) do
    cnByCt = Job.get_cn_by_ct(jobs, professions)

    # IO.inspect cnByCt[:cnTotaux]

    {cn, _} = Enum.max_by(cnByCt[:cnTotaux], fn {k,_v} -> String.length(k) end)
    {ct, _} = Enum.max_by(cnByCt[:ctTotaux], fn {k,_v} -> String.length(k) end)
    cnMax = String.length(cn)
    ctMax = String.length(ct)
    cnKeys = Map.keys(cnByCt[:cnTotaux])
    cnKeys = ["TOTAL"] ++ cnKeys
    max = length(cnKeys)

    outHSeparator = String.duplicate("-", (1 + 1 + ctMax + 1 ) + ( max * ( 1 + 1 + cnMax + 1) ) + 1)
    inHcnSeparator = String.duplicate("-", cnMax)
    inHctSeparator = String.duplicate("-", ctMax)
    inHcnSeparators = Enum.reduce(
      cnKeys,
      [],
      fn _a, acc ->
        [inHcnSeparator] ++ acc
      end
    )
    inHSeparators = [inHctSeparator] ++ inHcnSeparators

    case00 = String.duplicate(" ", ctMax)
    line0Values = [case00] ++ cnKeys
    cnKeys = tl(cnKeys)

    line1Values = Map.values(cnByCt[:cnTotaux])
    line1Values = [cnByCt[:totaux]] ++ line1Values
    line1Values = ["TOTAL"] ++ line1Values
    
    IO.puts outHSeparator
    IO.puts prepare_draw_line(line0Values, " ", cnMax, ctMax)
    IO.puts prepare_draw_line(inHSeparators, " ", cnMax, ctMax)
    IO.puts prepare_draw_line(line1Values, " ", cnMax, ctMax)
    Enum.each(
      cnByCt[:cnByCt],
      fn {ctKey, values} ->
        cnValues = Enum.reduce(
          cnKeys,
          [],
          fn key, acc ->
            v = (values[key] || 0)
            acc ++ [v]
          end
        )

        ctTotal = to_string(cnByCt[:ctTotaux][ctKey])

        lineYValues = [ctTotal] ++ cnValues
        lineYValues = [ctKey] ++ lineYValues

        IO.puts prepare_draw_line(inHSeparators, " ", cnMax, ctMax)
        IO.puts prepare_draw_line(lineYValues, " ", cnMax, ctMax)
      end
    )
    IO.puts outHSeparator
  end

  def prepare_draw_case(element, separator, max) do
    string = to_string(element)
    stringL = String.length(string)
    diff = max - stringL
    separatorRem = rem(diff, 2)
    separatorDiv = div(diff, 2)
    separatorDup = String.duplicate(separator, separatorDiv + 1)
    "|" <> separatorDup <> string <> separatorDup <> String.duplicate(separator, separatorRem)
  end

  def prepare_draw_line(ctCnvalues, separator, cnMax, ctMax) do
    [ct | cns] = ctCnvalues
    line = Job.prepare_draw_case(ct, separator, ctMax)
    line = Enum.reduce(
      cns,
      line,
      fn value, acc ->
        acc <> Job.prepare_draw_case(value, separator, cnMax)
      end
    )
    line <> "|"
  end
end
