module dataSplit
using CSV;
using LinearAlgebra;
using Distributions;
using Random;
using Plots;

# export every funtion name you want to use by importall
export dataSplitTest, getDF, ListDataSplite, get_trip

# println("dataSplit running ")

function dataSplitTest(a = "dataSplit used!")
    # print(a)
end

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

function ListDataSplite(aims,mask,keep,keep_all = false)
    # cut aim with mask and keep the number "keep" in the position of mask
    # usage: P = ListDataSplite([data_X,data_Y,data_Trip,data_Close,data_Far],data_Potter,1);
    keep_list = []
    for aim in aims
        new_list = []
        for i = 1 : length(aim)
            if mask[i] == keep || keep_all == true
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


end