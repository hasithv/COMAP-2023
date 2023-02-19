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

# ╔═╡ Cell order:
# ╠═0586f860-afe0-11ed-3ceb-5351ffb20883
# ╠═87dd45e9-5990-474e-b073-d6a229d26f28
# ╠═3cafc96a-497c-49bf-8f4a-3133d8261f2a
# ╠═1470dd24-7bb7-436c-9eaa-b7753e160a66
