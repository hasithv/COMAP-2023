### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 72e02800-af54-11ed-125f-394b451d9515
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate(".")
end;

# ╔═╡ 3e6f7e8f-9934-48c8-a94a-4d276a28bf4b
begin
	using DataFrames
	using LsqFit
	using XLSX
	using CSV
	using Plots
	using Dates
end

# ╔═╡ 71cfa161-90a0-4b3b-b16c-3926e2ccc0bf
begin
	df = DataFrame(XLSX.readxlsx("Problem_C_Data_Wordle.xlsx")["Sheet1"]["B2:M361"],:auto)
	df = rename!(df, Symbol.(Vector(df[1,:])))[2:end,:]
	rename!(df, "Number of  reported results" => "results")
	df[!, "days_since_start"] = df[!, "Contest number"] .- minimum(df[!, "Contest number"])
	select!(df, "Date", "days_since_start", Not(["days_since_start", "Date"]))
	
	df[!, "norm_x"] = df[!, "days_since_start"]/maximum(df[!, "days_since_start"])
	df
end

# ╔═╡ d722f21e-93fa-45bb-a3ad-93218191cf9c
md"""
# Exponential Fit
We experimented with trying to fit the data of number of results ($R$) as a function of days ($x$) since start of data collection (Jan 7 2022) to 

$$R(t) = Ae^{-B\tilde{x}} + C$$

using a simple least squares fit. \tilde{x} represents the normalized $x$ values so as to not cause any overflow errors. We normalized $x$ with the simple formula of:

$$\tilde{x} = \frac{x}{\max x}$$

In addition, we found that there was an outlier in number of reported results on Nov 30, 2022, so we excluded it from our fit and residuals (which we used to calculate average percent error to determine the interval).

Note: The data for time was arranged so that the most recent day is in the first index, so after a certain day means all values in the array before--not after--it
"""

# ╔═╡ 56cb5fed-af3c-43ca-96fb-e1d6f4351b93
begin
	@. model(x, p) = p[1]*exp(-x*p[2])+p[3]
	xdata = df[1:333,"norm_x"]
	ydata = df[1:333,"results"]
	popat!(xdata, 32)
	popat!(ydata, 32)
	p0 = [300_000.0, 10.0, 70_000]
	fit = curve_fit(model, xdata, ydata, p0)
end

# ╔═╡ 246fb5c1-7810-490f-bcaf-917d7aa995cc
md"""
To achieve a better fit and reflect the fact that the overall trend has not varied very much after the peak number of results on Feb 2, 2022, we only fit the model to data after that date.

As shown in the plots below, the fit was able to represent the data very well after Feb 2, 2022
"""

# ╔═╡ 755e1b7e-2551-4789-9835-e22a83c3a328
begin
	R(x) = model(x, fit.param)
	p1 = plot(R, minimum(xdata), maximum(xdata))
	plot!(df[!, "norm_x"], df[!, "results"])
	xlims!((0,1))
	ylabel!("posted resutls")

	p2 = plot(xdata, fit.resid)
	xlims!((0,1))
	ylabel!("residual")
	xlabel!("time")
	
	plot(p1, p2, layout=(2,1))
end

# ╔═╡ 5b65fbd5-eecb-48ff-9689-f1e1ac4ed980
md"""
The fit gave us the resulting model of:

$$R(t) = 5.33\cdot 10^5 e^{-6.38x} + 23531.2$$

for any day after Feb 2, 2022
"""

# ╔═╡ 9a87405d-a490-4e1b-af7a-deae742e59ec
md"""
### Average Percent Error

The residuals seem to be fairly constant after $\tilde{x} = 0.4$ so we will use data after that point to determine the average percent error between our fit and actual data for future predictions.
"""

# ╔═╡ 39bd7865-5d4f-4b75-ae56-87a6fba34125
sum(abs.(fit.resid[1:215]./ydata[1:215]))/215

# ╔═╡ a4c9ea93-51d9-4229-ab8e-b2029f14255b
begin
	StartDate = Date(2022,2,2)
	EndDate = Date(2023,3,1)
	t = (EndDate-StartDate).value/maximum(df[!, "days_since_start"])
	R(t)
end

# ╔═╡ cc50cc74-3103-4b05-b4ab-a95d8e458195
md"""
## Result

From the exponential fit and the mean squared error, we project that the number of posted wordle results should be $24022 \pm 6.8\%$ or $24022 \pm 1633.5$ on March 1, 2023
"""

# ╔═╡ Cell order:
# ╠═72e02800-af54-11ed-125f-394b451d9515
# ╠═3e6f7e8f-9934-48c8-a94a-4d276a28bf4b
# ╠═71cfa161-90a0-4b3b-b16c-3926e2ccc0bf
# ╟─d722f21e-93fa-45bb-a3ad-93218191cf9c
# ╠═56cb5fed-af3c-43ca-96fb-e1d6f4351b93
# ╟─246fb5c1-7810-490f-bcaf-917d7aa995cc
# ╠═755e1b7e-2551-4789-9835-e22a83c3a328
# ╟─5b65fbd5-eecb-48ff-9689-f1e1ac4ed980
# ╟─9a87405d-a490-4e1b-af7a-deae742e59ec
# ╠═39bd7865-5d4f-4b75-ae56-87a6fba34125
# ╠═a4c9ea93-51d9-4229-ab8e-b2029f14255b
# ╟─cc50cc74-3103-4b05-b4ab-a95d8e458195
