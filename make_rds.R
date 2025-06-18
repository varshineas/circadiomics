# make_rds.R
# Generate preprocessed .rds files for Shiny app

library(readr)
library(dplyr)
library(tidyr)

# Create /Data folder if it doesn't exist
if (!dir.exists("Data")) dir.create("Data")

message("Reading and processing files...")

# 1. Gene Info Metadata (genomic coordinates)
gene_info_file <- "Data/GeneInfo_ProteinCoding.txt"
if (file.exists(gene_info_file)) {
  gene_info_metadata <- read_tsv(gene_info_file, show_col_types = FALSE)
  saveRDS(gene_info_metadata, "Data/gene_info_metadata.rds")
  
  gene_list <- sort(unique(gene_info_metadata$GeneSymbol))
  saveRDS(gene_list, "Data/gene_list.rds")
  message("aved: gene_info_metadata.rds and gene_list.rds")
} else {
  warning("Missing file: GeneInfo_ProteinCoding.txt")
}

# 2. Aging DE data
aging_file <- "Data/Master_AgingDE.txt"
if (file.exists(aging_file)) {
  aging <- read_tsv(aging_file, show_col_types = FALSE)
  
  aging_clean <- aging %>%
    select(GeneSymbol, starts_with("log2FoldChange"), starts_with("padj")) %>%
    rename(Gene = GeneSymbol)
  
  saveRDS(aging_clean, "Data/aging_clean.rds")
  message("Saved: aging_clean.rds")
} else {
  warning("Missing file: Master_AgingDE.txt")
}

# 3. Circadian Summary
circadian_file <- "Data/Master_Circadian.txt"
if (file.exists(circadian_file)) {
  circadian <- read_tsv(circadian_file, show_col_types = FALSE)
  
  circadian_clean <- circadian %>%
    select(GeneSymbol, Group, Phase, `Daily Fold Change`, max_mean, min_mean) %>%
    rename(
      Condition = Group,
      Gene = GeneSymbol,
      FoldChange = `Daily Fold Change`,
      MaxExpr = max_mean,
      MinExpr = min_mean
    ) %>%
    mutate(
      Age = ifelse(grepl("06mo", Condition), "Young", "Aged"),
      Diet = gsub("06mo_|19mo_", "", Condition),
      Tissue = "Liver"
    )
  
  saveRDS(circadian_clean, "Data/circadian_clean.rds")
  message("✓ Saved: circadian_clean.rds")
} else {
  warning("Missing file: Master_Circadian.txt")
}

message("All RDS files are generated (if source files were found).")
