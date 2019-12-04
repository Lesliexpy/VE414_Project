
include("./src/dataSplit.jl")
include("./src/MyPlot.jl")

dataSplit.dataSplitTest()
MyPlot.MyPlotTest()

df = dataSplit.getDF("./data_proj_414.csv");
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

A = dataSplit.ListDataSplite([data_X,data_Y,data_Trip,data_Close,data_Far],data_Granger,1,true);

print(length(data_X),", ",length(P[1]),", ",length(W[2]),", ",length(G[3]),", ",length(P[1])+length(W[2])+length(G[3]))

P_trip = dataSplit.get_trip(P);
W_trip = dataSplit.get_trip(W);
G_trip = dataSplit.get_trip(G);

All_trip = dataSplit.get_trip(A);

using Plots
gr()
# pyplot()
p1 = MyPlot.getPic(P_trip, :haline, 1, 5, "Rout for P", 10)
p2 = MyPlot.getPic(W_trip, :inferno, 1, 5, "Rout for W", 10)
p3 = MyPlot.getPic(G_trip, :ice, 1, 5, "Rout for G", 10)
# p4 = MyPlot.PicAll3(P,W,G,:magma,1,5,"Rout for All",10)
p4 = MyPlot.getPic(All_trip, :haline, 1, 5, "Rout for All", 10)
plot(p1,p2,p3,p4,layout=(2,2),legend=false, fmt = :png)

# savefig("pic/fig1.eps")
savefig("pic/fig1.png")
# savefig("pic/fig1.svg")

p_all = MyPlot.getPic(All_trip, :inferno, 1, 5, "Rout for All", 10)
plot(p_all, legend=false, fmt = :png)
savefig("pic/fig0.png")
# savefig("pic/fig0.svg")

X = vcat(vcat(P[1],W[1]),G[1]);
Y = vcat(vcat(P[2],W[2]),G[2]);
Weight_close = vcat(vcat(P[4],W[4]),G[4]);
Weight_far = vcat(vcat(P[5],W[5]),G[5]);
print(length(X)," ", length(Y)," ", length(Weight_close)," ",length(Weight_far))

using Plots
# pyplot();
gr();
pw_close = MyPlot.getWeightPic(X,Y,Weight_close,:matter,1,5,"# Tayes close by (All)",true);
pw_far = MyPlot.getWeightPic(X,Y,Weight_far,:matter,3,5,"# Tayes no far way (All)",true);
plot(pw_close, pw_far,layout=(1,2), size=(107*15,107*6), fmt = :png)

savefig("pic/fig5.png")
# savefig("pic/fig5.svg")
