# Loading packages upfront ----

if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)
if (!require("readxl")) install.packages("readxl")
library(readxl)
if (!require("cluster")) install.packages("cluster")
library(cluster)
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)


# Load data ----

data <- read_excel("Merged Dataset.xlsx")

data_wide <- data %>%
  pivot_wider(
    names_from = "Trade Type",
    values_from = "Trade Amount"
  )


# Aggregate to country level ----

data_country <- data_wide %>%
  group_by(`Country Name`, Region, `Income Group`) %>%
  summarise(
    avg_export = mean(Export, na.rm = TRUE),
    avg_import = mean(Import, na.rm = TRUE),
    avg_manufacturing = mean(Manufacturing, na.rm = TRUE)
  ) %>%
  ungroup()


# Standardize numeric variables ----

data_scaled <- data_country %>%
  select(avg_export, avg_import, avg_manufacturing) %>%
  scale()


# Determining k ----

## Silhouette Scores for Different Values of k ----

### Initialise lists for models & scores
fits <- list()
scores <- numeric()

### Loop Through Different Values of k
for (k in 2:10) {
  model <- kmeans(data_scaled, centers = k) # Train the model for k
  fits[[k]] <- model # Append the model to fits
  # Calculate the silhouette score
  silhouette_scores <- silhouette(model$cluster, dist(data_scaled))
  scores[k] <- mean(silhouette_scores[, 3]) # Add to list of scores
}

### Create a data frame for plotting the scores
scores_df <- data.frame(k = 2:10, silhouette_score = scores[2:10])
ggplot(scores_df, aes(x = k, y = silhouette_score)) +
  geom_line() +
  geom_point() +
  labs(title = "Silhouette Scores for Different Values of k",
       x = "Number of Clusters (k)",
       y = "Average Silhouette Score")

### 2 or 3 clusters are good choices.


## Elbow method to determine k ----
set.seed(703)
wss <- numeric()

for (k in 1:10) {
  km <- kmeans(data_scaled, centers = k, nstart = 25)
  wss[k] <- km$tot.withinss
}

### Plot WSS vs k
plot(1:10, wss, type = "b", 
     xlab = "Number of Clusters (k)", 
     ylab = "Total Within-Cluster Sum of Squares", 
     main = "Elbow Method for Determining k")

### 3 clusters are good choice as the total wss dropped sharply.


## Pick best k ----
best_k <- 3


# Run K-means clustering ----

set.seed(703)
final_model <- kmeans(data_scaled, centers = best_k, nstart = 25)
data_country$cluster <- as.factor(final_model$cluster)


# Sihouette Score to evaluate cluster quality ----

## Compute score for each point
silhouette_scores <- silhouette(final_model$cluster, dist(data_scaled))

## Calculate the average silhouette score (3rd column)
avg_silhouette_score <- mean(silhouette_scores[, 3])

## Print the average silhouette score
print(avg_silhouette_score)


# Summary statistics of clusters ----

## Cluster sizes
table(data_country$cluster)

## Distribution by Region and Income Group
table(data_country$cluster, data_country$Region)
table(data_country$cluster, data_country$`Income Group`)

## Cluster averages for numeric variables
cluster_profiles <- data_country %>%
  group_by(cluster) %>%
  summarise(
    avg_export = mean(avg_export),
    avg_import = mean(avg_import),
    avg_manufacturing = mean(avg_manufacturing)
  )
print(cluster_profiles)


# Visualization ----

## Identify the top 5 points by avg_import
top_points <- data_country %>%
  top_n(5, wt = avg_import)

## Plot of Export vs Import by clusters ----
ggplot(data_country, aes(x = avg_export, y = avg_import, color = cluster)) +
  geom_point(size = 3) +
  geom_text(data = top_points, 
            aes(label = `Country Name`), 
            vjust = -1, hjust = 0.5, size = 3,
            show.legend = FALSE) +
  labs(title = "Country Clusters by Trade Value",
       x = "Average Export",
       y = "Average Import",
       color = "Cluster") +
  theme_minimal()


## Boxplot of cluster profile ----
cluster_long_full <- data_country %>%
  pivot_longer(cols = c(avg_export, avg_import, avg_manufacturing), 
               names_to = "variable", values_to = "value")

ggplot(cluster_long_full, aes(x = cluster, y = value, fill = cluster)) +
  geom_boxplot(show.legend = FALSE) +
  facet_wrap(~ variable, scales = "free_y") +
  labs(title = "Cluster Profiles: Export, Import, and Manufacturing Distributions",
       x = "Cluster",
       y = "Value")
