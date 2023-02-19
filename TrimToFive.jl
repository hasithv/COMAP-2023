using CSV
using DataFrames

df = CSV.read("ngram_freq.csv", DataFrame)
dict = CSV.read("OPTED-Dictionary.csv", DataFrame)
replace!(dict[!, "Word"], missing => "")
dict = dict[Bool[length(x)==5 for x in dict[!, "Word"]],:]

dictwords = lowercase.(Array(dict[!, "Word"]))

function CompareWord(word)
    if word in dictwords
        println(word)
        return true
    else
        return false
    end
end

CSV.write("ngram_freq_trimmed.csv", df[Bool[length(x)==5 && CompareWord(x) for x in df[!, "word"]],:])

"""
df = CSV.read("ngram_freq_trimmed.csv", DataFrame)
df[!, "freq"] =  df[!, "count"] / sum(df[!, "count"])
CSV.write("ngram_freq_trimmed.csv", df)
"""
