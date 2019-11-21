module dataSplit
using CSV;
using LinearAlgebra;
using Distributions;
using Random;
using Plots;

function getDF(df_name)
    return CSV.read(df_name, 
    delim = ',',
    types=Dict(
        "Potter"=>Bool,
        "Weasley"=>Bool,
        "Granger"=>Bool,
        "Trip"=>Int,
        "Close"=>Int,
        "Far"=>Int));
end

function ListDataSplite(aims,mask,keep)
    # cut aim with mask and keep the number "keep" in the position of mask
    # usage: P = ListDataSplite([data_X,data_Y,data_Trip,data_Close,data_Far],data_Potter,1);
    keep_list = []
    for aim in aims
        new_list = []
        for i = 1 : length(aim)
            if mask[i] == keep
                push!(new_list,aim[i])
            end
        end
        push!(keep_list,new_list)
    end
    return keep_list
end

function get_trip(P, Max_trip=49)
    P_trip = []
    for i = 1:Max_trip
        current_trip = ListDataSplite([P[1],P[2],P[4],P[5]],P[3],i);
        push!(P_trip,current_trip)
    end
    return P_trip
end

function getPic(P_trip, color = :inferno, markersize = 1)
    ## color is a list of color, you should change the color and data
    ## you can find colors at: http://docs.juliaplots.org/latest/colors/#misc
    kk = length(P_trip)
    colors = RGBA[cgrad(color)[z] for z=range(0,stop=1,length=kk)]
    p1 = scatter()
    for i = 1:kk
        p1 = scatter!(P_trip[i][1],P_trip[i][2],markersize = markersize, markerstrokewidth = 0,
            markercolor = colors[i], size=(600,400), leg=false, xlims = (0,107), xticks = 0:10:107,
            ylims = (0,107), yticks = 0:10:107)
    end
    return p1
end



end