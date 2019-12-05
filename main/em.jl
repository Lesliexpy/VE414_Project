
# Objective: determine the number of Jiuling tress in the forbidden forest.
# Spell: records the position of the person at an 1-minute interval (accurate)
#               the number of Tayes close by (less 1 meter away) on the ground from the person (accurate)
#               the number of Tayes no far way (less 3 meters away) on the ground from the person (not accurate, unknown precise nature)
# Foebidden Forest: 107 * 107 
# Number of Jiuling: Unchanged. Can't move or be stolen.

# Task 1: To figure out what the spell has recorded. Make graphs of locations and useful information.
# Task 2(main task): Estimate the number and location of Jiuling in the Forbidden Forrest. 
#                    Make sure the assumptions are consistent with the data.
#Figure out what is needed to solve task2 if Jiuling can actually move.
using CSV;
using LinearAlgebra;
using Distributions;
using Random;
using Plots;

include("./src/autoPic.jl")

proj_file = "../data/data_proj_414.csv"

df = CSV.read(proj_file, delim = ',');

df_close_notzero = df[df[:Close].!=0,:];
df_far_notzero = df[df[:Far].!=0,:];

df_close_notzero_cut = df_close_notzero[:,[2,3,8]];
df_far_notzero_cut = df_far_notzero[:,[2,3,9]];

arr_close=convert(Array,df_close_notzero_cut);
arr_far=convert(Array,df_far_notzero_cut);

function Onetree(df,x1,x2,y1,y2)
    dfm=df[(df.X.>=x1).&(df.X.<=x2).&(df.Y.>=y1).&(df.Y.<=y2).&(df.Close.>0), :]
    return dfm, dfm.Close
end
function Areafruit(single_tree_df)
    avgx=sum(single_tree_df.X.*single_tree_df.Close)/size(single_tree_df)[1];
    avgy=sum(single_tree_df.Y.*single_tree_df.Close)/size(single_tree_df)[1];
    index=findmax(single_tree_df.Close)[2];
    distance_x=single_tree_df.X.-single_tree_df.X[index];
    distance_y=single_tree_df.Y.-single_tree_df.Y[index];
    single_tree_df.distance = (distance_x.^2+distance_y.^2).^0.5;
    temp1=single_tree_df[single_tree_df.distance.<=1,:];
    temp2=single_tree_df[(single_tree_df.distance.<=3).&(single_tree_df.distance.>1),:];
    temp3=single_tree_df[(single_tree_df.distance.<=5).&(single_tree_df.distance.>3),:];
    number_fruit=findmax(temp1.Close)[1]+(sum(temp2.Close)/size(temp2)[1]*8)+(sum(temp3.Close)/size(temp3)[1]*16);
    return number_fruit
end

function number_estimate(df, lambda)
    fruit_sum = sum(df.Close)
    dfm = df[df.Close.>0, :]
    A = 70*3.12
    AT = area_estimate(dfm)
    tree_number = round(Int, AT/A*(fruit_sum/size(dfm)[1])/(lambda/A))
    return tree_number
end
function area_estimate(df)
    n = size(df)[1]
    arr = zeros(107, 107)
    for i in 1:n
        if df.Close[i]>0
            x = round(Int, df.X[i])
            y = round(Int, df.Y[i])
            arr[x, y] = 1
        end
    end
    return sum(arr)/2
end

function observed_tree_number(df)
    x1 = 5
    x2 = 15
    y1 = 3
    y2 = 10
    tree,df_close = Onetree(df,x1,x2,y1,y2)
    fruits = Areafruit(tree)
    df_c = df[df.Close.>0,:]
    number = round(Int, number_estimate(df_c, fruits))
    return number
end

k = observed_tree_number(df); #k=prior_num_tree
alpha = 0.5;
beta = 1-alpha;

N = size(df_far_notzero)[1];
dim = size(df_far_notzero)[2];
PI = Array{Float64,1}()
for i = 1:k
    push!(PI, 1/k)
end

gamma = zeros(k,N);
mu = 107*rand(k,2)
# print("jj ",mu)
sigma = [Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2)Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2)];
println(length(sigma))

function get_pdf(sample, mu, sigma)
        distribution = MvNormal(mu, sigma)
        result = pdf(distribution, sample)
        if isnan(result)
            return 0
        end
        return result
end

function gmm_component_far(arr_far, mu, sigma)
    return get_pdf(arr_far[1:2], mu, sigma);
    #return get_pdf(arr_far[1:2], mu, sigma)*arr_far[3];
end

function get_likelihood_far(gamma, arr_far, mu, sigma)  
    res = 0.0
    for i=1:N
        ll = 0.0
        for j=1:k
            ll += gamma[j,i]*gmm_component_far(arr_far[i,:], mu[j,:], sigma[j])
        end
        res += log(ll)
    end
    return res
end

num_iter = 20;
tmp_sum = 0;
tmp = zeros(k);
# print("aa ",mu)
for steps = 1:num_iter
    global mu
    for i = 1:N
        for j = 1:k
            
            kl = mu[j,:]
            # print("cc ",kl)
            tmp[j] = PI[j]*gmm_component_far(arr_far[i,:], kl, sigma[j])
        end
        tmp_sum = sum(tmp)
        if tmp == 0
            for j = 1:k
                gamma[j,i] = 1/k;
            end
        else
            for j = 1:k
                gamma[j,i] = tmp[j]/tmp_sum;
            end
        end
    end
    likelihood = [];
    cur_likelihood = get_likelihood_far(gamma, arr_far, mu, sigma);
    push!(likelihood, cur_likelihood);
    #println(likelihood)
    # update mu,sigma,pi
    mu = zeros(k,2)
    
    for i = 1:k
        for j = 1:2
            a=0
            for n = 1:N
                a += arr_far[n,j]*gamma[i,n]
            end
            mu[i,j] += a/sum(gamma[i,:])
        end
    end
    #=
    if steps < num_iter-2
        for i = 1:k
            for j = i:k
                if abs(mu[i,1]-mu[j,1])<1
                    mu[i]+=2*(rand()-0.5)
                end
            end
        end
        for i = 1:k
            for j = i:k-1
                if abs(mu[i,2]-mu[j,2])<1
                    mu[i]+=2*(rand()-0.5)
                end
            end
        end
    end
    =#
    for  i =1:k
        cov_sum = zeros(2,2)
        for j = 1:N
            cov_sum += gamma[i,j]*(arr_far[j,1:2]-mu[i,:])*(arr_far[j,1:2]-mu[i,:])'
        end
        cov_sum = cov_sum./sum(gamma[i,:])
        if (cov_sum[1,1] > 0 && cov_sum[1,2] > 0 && cov_sum[2,1] > 0 && cov_sum[2,2] > 0)
            sigma[i] = cov_sum
        end
        if isposdef(sigma[i]) == false
            sigma[i] = [1 0; 0 1]
        end
    end
    #println(sigma)
    for i = 1:k
        PI[i] = sum(gamma[i,:])/N
    end
    #println(PI)
end
mu_far = deepcopy(mu)
# print(mu)

N = size(df_close_notzero)[1];
dim = size(df_close_notzero)[2];
PI = Array{Float64,1}()
for i = 1:k
    push!(PI, 1/k)
end
gamma = zeros(k,N);
mu = 107*rand(k,2)
sigma = [Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2)Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2),Matrix{Float64}(I, 2, 2)];
# println(length(sigma))
function gmm_component_close(arr_close, mu, sigma)
    return get_pdf(arr_close[1:2], mu, sigma);
    #return get_pdf(arr_close[1:2], mu, sigma)*arr_close[3];
end
function get_likelihood_close(gamma, arr_close, mu, sigma)  
    res = 0.0
    for i=1:N
        ll = 0.0
        for j=1:k
            ll += gamma[j,i]*gmm_component_close(arr_close[i,:], mu[j,:], sigma[j])
        end
        res += log(ll)
    end
    return res
end

num_iter = 20;
tmp_sum = 0;
tmp = zeros(k);
for steps = 1:num_iter
    global mu
    for i = 1:N
        for j = 1:k
            tmp[j] = PI[j]*gmm_component_close(arr_close[i,:], mu[j,:], sigma[j])
        end
        tmp_sum = sum(tmp)
        if tmp == 0
            for j = 1:k
                gamma[j,i] = 1/k;
            end
        else
            for j = 1:k
                gamma[j,i] = tmp[j]/tmp_sum;
            end
        end
    end
    likelihood = [];
    cur_likelihood = get_likelihood_close(gamma, arr_close, mu, sigma);
    push!(likelihood, cur_likelihood);
    #println(likelihood)
    # update mu,sigma,pi
    mu = zeros(k,2)
    
    for i = 1:k
        for j = 1:2
            a=0
            for n = 1:N
                a += arr_close[n,j]*gamma[i,n]
            end
            mu[i,j] += a/sum(gamma[i,:])
        end
    end
    #=
    if steps < num_iter-2
        for i = 1:k
            for j = i:k
                if abs(mu[i,1]-mu[j,1])<1
                    mu[i]+=2*(rand()-0.5)
                end
            end
        end
        for i = 1:k
            for j = i:k-1
                if abs(mu[i,2]-mu[j,2])<1
                    mu[i]+=2*(rand()-0.5)
                end
            end
        end
    end
    =#
    for  i =1:k
        cov_sum = zeros(2,2)
        for j = 1:N
            cov_sum += gamma[i,j]*(arr_close[j,1:2]-mu[i,:])*(arr_close[j,1:2]-mu[i,:])'
        end
        cov_sum = cov_sum./sum(gamma[i,:])
        if (cov_sum[1,1] > 0 && cov_sum[1,2] > 0 && cov_sum[2,1] > 0 && cov_sum[2,2] > 0)
            sigma[i] = cov_sum
        end
        if isposdef(sigma[i]) == false
            sigma[i] = [1 0; 0 1]
        end
    end
    #println(sigma)
    for i = 1:k
        PI[i] = sum(gamma[i,:])/N
    end
    #println(PI)
end
mu_close = deepcopy(mu)

a = copy(mu_close)
a = sort(a, dims =1)
temp = a[:,1]
sorted_mu_close=zeros(k,2)
for i = 1:length(temp)
    for j = 1:length(temp)
        if temp[i] == mu_close[j][1]
            sorted_mu_close[i,1] = mu_close[j,1]
            sorted_mu_close[i,2] = mu_close[j,2]
        end
    end
end
println(sorted_mu_close)
b = copy(mu_far)
b = sort(b, dims =1)
temp = b[:,1]
sorted_mu_far=zeros(k,2)
for i = 1:length(temp)
    for j = 1:length(temp)
        if temp[i] == mu_far[j][1]
            sorted_mu_far[i,1] = mu_far[j,1]
            sorted_mu_far[i,2] = mu_far[j,2]
        end
    end
end
println(sorted_mu_far)
mu_comb = sorted_mu_close.*0.95 + sorted_mu_far.*0.05
println(mu_comb)

trees_x = [];
trees_y = [];
for i = 1:k
    push!(trees_x, mu_close[i,1])
    push!(trees_y, mu_close[i,2])
end
pw_far = autoFar(proj_file,"Jiuling in observed area");
size_x = 5;
pw_far = scatter!(trees_x, trees_y, markersize = 1*size_x, markerstrokewidth = 0,
            markercolor = :red, size=(107*size_x,107*size_x), leg=false, xlims = (0,107), xticks = 0:10:107,
            ylims = (0,107), yticks = 0:10:107);

trees_x = [];
trees_y = [];
for i = 1:k
    push!(trees_x, mu_far[i,1])
    push!(trees_y, mu_far[i,2])
end
pw_far = autoFar(proj_file,"Jiuling in observed area");
size_x = 5;
pw_far = scatter!(trees_x, trees_y, markersize = 1*size_x, markerstrokewidth = 0,
            markercolor = :red, size=(107*size_x,107*size_x), leg=false, xlims = (0,107), xticks = 0:10:107,
            ylims = (0,107), yticks = 0:10:107);

trees_x = [];
trees_y = [];
for i = 1:k
    push!(trees_x, mu_comb[i,1])
    push!(trees_y, mu_comb[i,2])
end
pw_far = autoFar(proj_file,"Jiuling in observed area");
size_x = 5;
pw_far = scatter!(trees_x, trees_y, markersize = 1*size_x, markerstrokewidth = 0,
            markercolor = :red, size=(107*size_x,107*size_x), leg=false, xlims = (0,107), xticks = 0:10:107,
            ylims = (0,107), yticks = 0:10:107);


using DataFrames, CSV
function save_array(file_name, map_close)
    df_close = DataFrame(map_close)
    CSV.write(file_name, df_close, delim="\t")
end
dnf = DataFrame(X = mu_comb[:,1], Y = mu_comb[:,2]);
save_array("./csv/tree_position.csv", dnf)
