module MyPlot

include("./dataSplit.jl")
# using CSV;
# using LinearAlgebra;
# using Distributions;
# using Random;
using Plots;

export MyPlotTest, getPic

function MyPlotTest()
    dataSplit.dataSplitTest("MyPlot used!")
end


function getPic(P_trip, color = :inferno, markersize = 1,size_x = 5, title="", titlefontsize = 13)
    ## color is a list of color, you should change the color and data
    ## you can find colors at: http://docs.juliaplots.org/latest/colors/#misc
    kk = length(P_trip)
    markersize = markersize*size_x
    colors = RGBA[cgrad(color)[z] for z=range(0,stop=1,length=kk)]
    p1 = scatter()
    for i = 1:kk
        p1 = scatter!(P_trip[i][1],P_trip[i][2],markersize = markersize, markerstrokewidth = 0,
            markercolor = colors[i], size=(107*size_x,107*size_x), leg=false, xlims = (0,107), xticks = 0:10:107,
            ylims = (0,107), yticks = 0:10:107, title = title, titlefontsize = titlefontsize)
    end
    return p1
end

function PicAll3(P,W,G,color = :inferno,markersize = 1,size_x = 5, title="", titlefontsize = 13)
    markersize = markersize*size_x
    colors = RGBA[cgrad(color)[z] for z=range(0,stop=1,length=3)]
    p4 =  scatter(P[1],P[2],markersize = markersize,markerstrokewidth = 0,markercolor = colors[1],
        size=(107*size_x,107*size_x),
        xlims = (0,107), xticks = 0:10:107, ylims = (0,107), yticks = 0:10:107, 
        title = "Rout for All", titlefontsize = 10,α=0.6)
    p4 = scatter!(W[1],W[2],markersize = markersize,markerstrokewidth = 0,markercolor = colors[2],α=0.3)
    p4 = scatter!(G[1],G[2],markersize = markersize,markerstrokewidth = 0,markercolor = colors[3],α=0.2)
    return p4
end

end