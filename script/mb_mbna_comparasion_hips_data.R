library(tidyverse)

# ------------------------------------------------------------
# 1. Load data
# ------------------------------------------------------------

plot_level <- read_csv("https://raw.githubusercontent.com/jdavis-132/hips/refs/heads/master/finalData/HIPS_INBREDS_V12_2.csv")

ear_level <- read_csv("https://raw.githubusercontent.com/jdavis-132/hips/refs/heads/master/finalData/HIPS_INBREDS_2022_2023_EARLEVEL_v3.1.csv")

# ------------------------------------------------------------
# 2. Check genotype differences
# ------------------------------------------------------------

setdiff(ear_level$genotype, plot_level$genotype)
setdiff(plot_level$genotype, ear_level$genotype)

# ------------------------------------------------------------
# 3. Filter MBNA and MB records
# ------------------------------------------------------------

mbna <- ear_level %>%
  filter(genotype == "MBNA") %>%
  select(qrCode, plotNumber, genotype, earLength, environment)

mb <- plot_level %>%
  filter(genotype == "MB") %>%
  select(qrCode, plotNumber, genotype, earLength, environment)

# ------------------------------------------------------------
# 4. Compare QR codes and plot numbers
# ------------------------------------------------------------

length(unique(mb$qrCode)) # 34
length(unique(mbna$qrCode)) # 34

setdiff(mbna$qrCode, mb$qrCode)
setdiff(mb$qrCode, mbna$qrCode)

intersect(mb$plotNumber, mbna$plotNumber)
setdiff(mb$plotNumber, mbna$plotNumber)

# ------------------------------------------------------------
# 5. Rename columns before joining
# ------------------------------------------------------------

mb <- mb %>%
  rename_with(~ paste0(.x, "_mb"))

mbna <- mbna %>%
  rename_with(~ paste0(.x, "_mbna"))

# ------------------------------------------------------------
# 6. Join MBNA and MB records by plot number
# ------------------------------------------------------------

common <- mbna %>%
  left_join(
    mb,
    by = c("plotNumber_mbna" = "plotNumber_mb")
  ) %>%
  select(
    genotype_mbna,
    genotype_mb,
    qrCode_mbna,
    qrCode_mb,
    plotNumber_mbna,
    environment_mbna,
    environment_mb,
    earLength_mbna,
    earLength_mb,
    everything()
  )

setdiff(common$qrCode_mbna, mb$qrCode_mb)

# ------------------------------------------------------------
# 7. Save output
# ------------------------------------------------------------

output_dir <- "PROJECTS/RAWDATA/data/Jun_8"

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
dir.exists(output_dir)

write_csv(
  common,
  file.path(output_dir, "MB_MBNA_Comparison_plot_N_based.csv")
)
