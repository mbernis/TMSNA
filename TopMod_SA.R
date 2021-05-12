library(tidyverse) 
library(cluster)  
library(RedditExtractoR) 
library(magrittr)
library(tm)
library(topicmodels)
library(tidytext)
library(wordcloud)
library(dplyr)
library(tidyr)
library(reshape2)

RedWomen <- reddit_urls(search_terms = "women", page_threshold = 1, sort_by = "relevance")


# Fetch comments from URLs scrapped
Com<-reddit_content(RedWomen$URL, wait_time = 2)


# Data-set operations
Corp<-data.frame(Com$comment)
colnames(Corp)<- "Texte"
Corp1<-data.frame(RedWomen$title)
colnames(Corp1)<- "Texte"
df<-rbind(Corp, Corp1)

# If needed, you can sample your data-set 
# df<-sample_n(df, 5000)

my.corpus<-Corpus(VectorSource(df$Texte)) 


# PRE-PROCESS YOUR DATA
my.corpus <- tm_map(my.corpus, removePunctuation)
my.corpus <- tm_map(my.corpus, stripWhitespace)
my.corpus <- tm_map(my.corpus, content_transformer(tolower))
my.corpus <- tm_map(my.corpus, removeWords, stopwords("english"))
my.corpus <- tm_map(my.corpus, removeNumbers)
my.corpus <- tm_map(my.corpus, function(x) iconv(enc2utf8(x), sub="byte"))


# Transform your data into a matrix
my.dtm <- DocumentTermMatrix(my.corpus, control = list(stopwords = TRUE))
raw.sum<-apply(my.dtm,1,FUN=sum)
dtm<-my.dtm[raw.sum!=0,]
head(dtm)


## LDA:Latent Dirichlet allocation, see https://www.tidytextmining.com/topicmodeling.html 
# Simplified version
ap_lda <- LDA(dtm, k = 8, method = "GIBBS", control = list(seed = 123))
ap_topics <- tidy(ap_lda, matrix = "beta")

ap_top_terms <- ap_topics %>%
  group_by(topic) %>%
  top_n(15, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

ap_top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(beta))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()


# SENTIMENT ANALYSIS OF THE TOPICS
#See https://www.tidytextmining.com/

#Explore bing: 
# Whats_in_bing<-get_sentiments("bing")

# Sentiment analysis applied on topic1
Top1<- subset(ap_topics, topic==1) %>%
  unnest_tokens(word, term)%>%
  top_n(500, beta) %>%
  filter(!str_detect(word, "[0-9]"),
         word != "") %>%
  mutate(word = gsub("s$", "", word))  

Top1 %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(scale=c(3,.05), colors = c("gray40", "gray90"))

