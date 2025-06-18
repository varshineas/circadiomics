library(shiny)
library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)

# ---- Load Data ----
gene_list <- readRDS("Data/gene_list.rds")
gene_info <- readRDS("Data/gene_info_metadata.rds")
aging_clean <- readRDS("Data/aging_clean.rds")
circadian_clean <- readRDS("Data/circadian_clean.rds")
cycling_long <- readRDS("Data/cycling_long.rds")

# ---- Color Palette ----
condition_colors <- c(
  "AL" = "black",
  "CR-spread" = "#5e3c99",
  "CR-day" = "#e66101",
  "CR-night" = "#1b9e77"
)
