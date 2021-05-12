# TMSNA

This script was run with the keyword "men"

Description of the data-set
The data-set is made of all posts from Reddit that would include the word “men”.
Once the data are collected, the script pre-processes the data: it removes the punctuation, strips white space, removes English stop words, numbers, and special characters. Also, the words “man” and “men” were excluded from the analysis.

H value for clusterisation
To proceed to topic modelling, you need to find an indicator (H value), which tells if my data is clusterable. If the H value is below the threshold 0.5, then, it is significant, and the clusterisation is most probable. For the dataset RedMen, the H value is 0.099. In other words, this value is significant. 

Number of clusters
Now that I have tested the clusterisation of my data set, I need an indicator to choose the number of clusters to apply the topic modelling algorithm to my data set. For the data-set “men,” the number of clusters indicated is 2. For data-set “women,” it is 2 as well.

LDA
The value of k should be 2.
The 15 top values were retrieved. Two clusters only were not satisfying, and after trying with two, three, and fours clusters, and three clusters gave the best results. The results are as follows:

![bild](https://user-images.githubusercontent.com/37995197/117961619-9d09fb80-b31e-11eb-84a7-1b7cae061c37.png)

The code then permits to apply sentiment analysis for each cluster:

Cluster 1:
![bild](https://user-images.githubusercontent.com/37995197/117961728-bb6ff700-b31e-11eb-9f48-b26f98c08246.png)


Cluster 2: 
![bild](https://user-images.githubusercontent.com/37995197/117961755-c32f9b80-b31e-11eb-93da-1f432200ff3f.png)


Cluster 3:
![bild](https://user-images.githubusercontent.com/37995197/117961783-ca56a980-b31e-11eb-9492-2b7014f59adc.png)
