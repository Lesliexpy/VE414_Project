include("./dataSplit.jl")
include("./MyPlot.jl")
using Plots

function autoFar(df_csv = "./data_proj_414.csv", pic_name = "# Tayes no far way (All)", plotnow = false)
	df = dataSplit.getDF(df_csv);
	title = names(df);

	data = df;
	data_X = data[:,2];
	data_Y = data[:,3];
	data_Potter = data[:,4];
	data_Weasley = data[:,5];
	data_Granger = data[:,6];
	data_Trip = data[:,7];
	data_Close = data[:,8];
	data_Far = data[:,9];

	P = dataSplit.ListDataSplite([data_X,data_Y,data_Trip,data_Close,data_Far],data_Potter,1);
	W = dataSplit.ListDataSplite([data_X,data_Y,data_Trip,data_Close,data_Far],data_Weasley,1);
	G = dataSplit.ListDataSplite([data_X,data_Y,data_Trip,data_Close,data_Far],data_Granger,1);

	X = vcat(vcat(P[1],W[1]),G[1]);
	Y = vcat(vcat(P[2],W[2]),G[2]);
	Weight_close = vcat(vcat(P[4],W[4]),G[4]);
	Weight_far = vcat(vcat(P[5],W[5]),G[5]);
	# print(length(X)," ", length(Y)," ", length(Weight_close)," ",length(Weight_far))

	gr();
	pw_far = MyPlot.getWeightPic(X,Y,Weight_far,:matter,3,5,pic_name,true);
	if plotnow
		plot(pw_far, fmt = :png)
	end
	return pw_far
end

function autoClose(df_csv = "./data_proj_414.csv", pic_name = "autoClose", plotnow = false)
	df = dataSplit.getDF(df_csv);
	title = names(df);

	data = df;
	data_X = data[:,2];
	data_Y = data[:,3];
	data_Potter = data[:,4];
	data_Weasley = data[:,5];
	data_Granger = data[:,6];
	data_Trip = data[:,7];
	data_Close = data[:,8];
	data_Far = data[:,9];

	P = dataSplit.ListDataSplite([data_X,data_Y,data_Trip,data_Close,data_Far],data_Potter,1);
	W = dataSplit.ListDataSplite([data_X,data_Y,data_Trip,data_Close,data_Far],data_Weasley,1);
	G = dataSplit.ListDataSplite([data_X,data_Y,data_Trip,data_Close,data_Far],data_Granger,1);

	X = vcat(vcat(P[1],W[1]),G[1]);
	Y = vcat(vcat(P[2],W[2]),G[2]);
	Weight_close = vcat(vcat(P[4],W[4]),G[4]);
	Weight_far = vcat(vcat(P[5],W[5]),G[5]);
	# print(length(X)," ", length(Y)," ", length(Weight_close)," ",length(Weight_far))

	gr();
	pw_close = MyPlot.getWeightPic(X,Y,Weight_close,:matter,1,5,pic_name,true);
	if plotnow
		plot(pw_close, fmt = :png)
	end
	return pw_close
end