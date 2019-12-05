
include("./src/dataSplit.jl")
include("./src/MyPlot.jl")

dataSplit.dataSplitTest()
MyPlot.MyPlotTest()
proj_file = "../data/data_proj_414.csv"
df = dataSplit.getDF(proj_file);
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

rows, columns = size(df)

function distance(x1,y1,x2,y2)
    return sqrt((x1-x2)^2+(y1-y2)^2)
end

map_close = [-1 for i in 1:107, j in 1:107] 
map_far   = [-1 for i in 1:107, j in 1:107] 
for i = 1:107
    for j = 1:107
        p_x = i - 0.5
        p_y = j - 0.5
        for k in 1:24094
            x = data_X[k]
            y = data_Y[k]
            close = data_Close[k]
            far = data_Far[k]
            if distance(p_x,p_y,x,y) <= 1
                if map_close[i, j] == -1
                    map_close[i, j] = 0
                end
                map_close[i, j]+=close
                
            end
            if distance(p_x,p_y,x,y) <= 3
                if map_far[i, j] == -1
                    map_far[i, j] = 0
                end
                map_far[i, j]+=far
                
            end
        end
    end
end
                

using DataFrames, CSV
function save_array(file_name, map_close)
    df_close = DataFrame(map_close)
    CSV.write(file_name, df_close, delim="\t")
end
    

save_array("./csv/close_map2.csv", map_close)
save_array("./csv/far_map2.csv", map_far)
