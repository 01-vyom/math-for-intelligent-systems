#= A3.2) Using Julia, find the nearest neighbor of a = (1, 3, 4) among the vectors
x1 = (4,3,5), x2 = (0.4,10,50), x3 = (1,4,10), x4 = (30,40,50).
Report the minimum distance of a to x1, . . . , x4. Also, find which of x1, . . . , x4 makes the smallest
angle with a and report that angle.
=#
using LinearAlgebra
a=[1,3,4]
xn = [[4,3,5],[0.4,10,50],[1,4,10],[30,40,50]]
dist = []
angle = []
for i in 1:4
    ntp = norm(a-xn[i])
    # println("Distance of a from x$i $ntp")
    push!(dist, ntp)
end
println("Minimum distance from a to x1,...,x4 is ",string(minimum(dist)))
for i in 1:4
    atp = acos((a'xn[i])/(norm(a)*norm(xn[i])))
    # println("Angle between a and x$i $atp")
    push!(angle, atp)
end
println("Minimum angle between a and x1,...,x4 is ",string(minimum(angle)))
#= A4.2) In this problem you will use k-means to cluster 300 Wikipedia articles selected from 5 broad groups of topics. 
The Julia file wikipedia_corpus.jl contains the histograms as a list of 300 1000-vectors in the variable article_histograms. 
It also provides the list of article titles in article_titles and a list of the 1000 words used to create the histograms in dictionary.
The file kmeans.jl provides a Julia implementation of the k-means algorithm in the function kmeans. The kmeans function accepts a 
list of vectors to cluster along with the number of clusters, k, and returns three things: the centroids as a list of vectors,
a list containing the index of each vector’s closest centroid, and a list of the value of J after each iteration of k-means. 
Each time the function kmeans is invoked it initializes the centroids by randomly assigning the data points to k groups and 
taking the k representatives as the means of the groups. 
(This means that if you run kmeans twice, with the same data, you might get different results.)
For example, here is an example of running k-means with k = 8 and finding the 30th article’s centroid.
>
include("wikipedia_corpus.jl")
include("kmeans.jl")
using Kmeans
centroids, labels, j_hist = kmeans(article_histograms, 8)
centroids[labels[30]]
>
The list labels contains the index of each vector’s closest centroid, so if the 30th entry in labels is 7, then
the 30th vector’s closest centroid is the 7th entry in centroids.
There are many ways to explore your results. For example, you could print the titles of all articles in a cluster.
> article_titles[labels .== 7]
Alternatively, you could find a topic’s most common words by ordering dictionary by the size of its centroid’s entries. 
A larger entry for a word implies it was more common in articles from that topic.
> dictionary[sortperm(centroids[7],rev=true)]
(a) For each of k = 2, k = 5, and k = 10 run k-means twice, and plot J (vertically) versus iteration (horizontally) for the 
two runs on the same plot. Create your plot by passing a vector containing the value of J at each iteration to PyPlot’s plot function. 
Comment briefly on your results.
(b) Choose a value of k from part (a) and investigate your results by looking at the words and article titles associated with each centroid. 
Feel free to visit Wikipedia if an article’s content is unclear from its title. Give a short description of the topics your 
clustering discovered along with the 3 most common words from each topic. If the topics do not make sense pick another value of k.
=#
#a)
include("wikipedia_corpus.jl")
include("kmeans.jl")
using Statistics
using LinearAlgebra
using SparseArrays
using Plots
pyplot()
#b)
centroids, labels, j_hist = Kmeans.kmeans(article_histograms, 2);
centroids_2, labels_2, j_hist_2 = Kmeans.kmeans(article_histograms, 2);
itr1 = []
itr2 = []
for i in 1:length(j_hist)
    push!(itr1,i) 
end
for i in 1:length(j_hist_2)
    push!(itr2,i) 
end
plot(itr1,j_hist,label="Iteration 1",title="2 Centroids")
plot!(itr2,j_hist_2,label="Iteration 2")
centroids, labels, j_hist = Kmeans.kmeans(article_histograms, 5);
centroids_2, labels_2, j_hist_2 = Kmeans.kmeans(article_histograms, 5);
itr1 = []
itr2 = []
for i in 1:length(j_hist)
    push!(itr1,i) 
end
for i in 1:length(j_hist_2)
    push!(itr2,i) 
end
plot(itr1,j_hist,label="Iteration 1",title="5 Centroids")
plot!(itr2,j_hist_2,label="Iteration 2")
centroids, labels, j_hist = Kmeans.kmeans(article_histograms, 10);
centroids_2, labels_2, j_hist_2 = Kmeans.kmeans(article_histograms, 10);
itr1 = []
itr2 = []
for i in 1:length(j_hist)
    push!(itr1,i) 
end
for i in 1:length(j_hist_2)
    push!(itr2,i) 
end
plot(itr1,j_hist,label="Iteration 1",title="10 Centroids")
plot!(itr2,j_hist_2,label="Iteration 2")
#b)
open("Cluster_Data.txt", "w") do file
    for i in 1:10
        topic = "Topic Number: "*string(i)
        titles = article_titles[labels_2 .== i]
        words = dictionary[sortperm(centroids_2[i],rev=true)]
        ans = topic*"\nTitles: "*join(titles,",")*" \nCommon Words: "*join(words,",")*"\n\n"
        write(file, ans)
    end
end
