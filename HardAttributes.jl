### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 0586f860-afe0-11ed-3ceb-5351ffb20883
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate(".")
end;

# ╔═╡ 87dd45e9-5990-474e-b073-d6a229d26f28
begin
	using DataFrames
	using LsqFit
	using XLSX
	using CSV
	using Plots
	using Dates
end

# ╔═╡ b3c5a046-1458-4c46-a105-48e290d1b7b5
begin
	function CountReps(w)
		return length(w)-length(unique(w))
	end

	function CountVowels(w)
		count = 0
		for i in ["a", "e", "i", "o", "u"]
			if occursin(i, w)
				count = count + 1
			end
		end
		
		if w[end] == "y"
			count = count + 1
		end

		if count == 0
			for i in w
				if i=="y" ? count = count + 1 : count = count end
			end
		end
		
		return count
	end	

	function WordRarity(w)
		df = CSV.read("ngram_freq_trimmed.csv", DataFrame)
		return sort!(df)
	end	
		
	WordRarity("manly")
end

# ╔═╡ 3cafc96a-497c-49bf-8f4a-3133d8261f2a
begin
	df = DataFrame(XLSX.readxlsx("Problem_C_Data_Wordle.xlsx")["Sheet1"]["B2:M361"],:auto)
	df = rename!(df, Symbol.(Vector(df[1,:])))[2:end,:]
	rename!(df, "Number of  reported results" => "results")
	df[!, "days_since_start"] = df[!, "Contest number"] .- minimum(df[!, "Contest number"])
	select!(df, "Date", "days_since_start", Not(["days_since_start", "Date"]))
	
	df[!, "norm_x"] = df[!, "days_since_start"]/maximum(df[!, "days_since_start"])
	df[!, "hard_percent"] = df[!, "Number in hard mode"] ./ df[!, "results"]

	df
end

# ╔═╡ 1470dd24-7bb7-436c-9eaa-b7753e160a66
plot(df[Not(32),"days_since_start"], df[Not(32),"hard_percent"])

# ╔═╡ f1ac81cd-3399-4862-8e55-5d86f2934559


# ╔═╡ Cell order:
# ╠═0586f860-afe0-11ed-3ceb-5351ffb20883
# ╠═87dd45e9-5990-474e-b073-d6a229d26f28
# ╠═b3c5a046-1458-4c46-a105-48e290d1b7b5
# ╠═3cafc96a-497c-49bf-8f4a-3133d8261f2a
# ╠═1470dd24-7bb7-436c-9eaa-b7753e160a66
# ╠═f1ac81cd-3399-4862-8e55-5d86f2934559
