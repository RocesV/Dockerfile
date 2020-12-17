## Installing packages for Docker image

mypkgs <- c("R.utils","BiocManager","GenomicFeatures", "GenomicRanges", "dplyr", "data.table", "ggplot2", "reshape2", "pheatmap", "RColorBrewer")
logicals <- is.element(mypkgs, installed.packages()[,1])
tmp <- base::sapply(mypkgs[!logicals], FUN = function(x){
  if(x != "GenomicFeatures" & x != "Gviz" & x != "CNEr" & x != "GenomicRanges")
    install.packages(x, repos = "https://cloud.r-project.org/")
  if(x == "GenomicFeatures"){
    BiocManager::install("GenomicFeatures")
  }
  if(x == "Gviz"){
    BiocManager::install("Gviz")
  }
  if(x == "CNEr"){
    BiocManager::install("CNEr")
  }
  if(x == "GenomicRanges"){
    BiocManager::install("GenomicRanges")
  }
})