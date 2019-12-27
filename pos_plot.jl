using CSV;
using LinearAlgebra;
using Distributions;
using Random;
using Plots;

df = CSV.read("C:\\Users\\admin1\\Desktop\\VE414\\proj\\data_proj_414.csv", delim = ',')

using PyPlot
data = df
posX = data[:,2]
posY = data[:,3]
Potter_posX = posX[1:8000]
Potter_posY = posY[1:8000]
Weasley_posX = posX[8000:16335]
Weasley_posY = posY[8000:16335]
Granger_posX = posX[16336:24093]
Granger_posY = posY[16336:24093]
PyPlot.scatter(Potter_posX, Potter_posY, s=0.1, color="brown")
PyPlot.scatter(Weasley_posX, Weasley_posY, s=0.1, color = "green")
PyPlot.scatter(Granger_posX, Granger_posY, s=0.1, color = "blue")
PyPlot.legend(["Potter","Weasley","Granger"])
