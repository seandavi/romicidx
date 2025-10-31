
<!-- README.md is generated from README.Rmd. Please edit that file -->

# romicidx

<!-- badges: start -->

<!-- badges: end -->

## Overview

`omicidx` provides relational database (SQL, dbplyr) access to public
omics metadata including SRA, GEO, BioSample, and BioProject. The
package connects to a remote DuckDB database containing links to
daily-updated parquet files stored in cloud storage.

## Installation

You can install the development version of omicidx from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("seandavi/romicidx")
#> Using GitHub PAT from the git credential store.
#> Downloading GitHub repo seandavi/romicidx@HEAD
#> pillar   (1.11.0 -> 1.11.1) [CRAN]
#> stringr  (1.5.1  -> 1.5.2 ) [CRAN]
#> magrittr (2.0.3  -> 2.0.4 ) [CRAN]
#> duckdb   (1.3.2  -> 1.4.1 ) [CRAN]
#> Installing 4 packages: pillar, stringr, magrittr, duckdb
#> Installing packages into '/private/var/folders/41/lf3t3prs7d1467m30dvgxksw0000gp/T/RtmpSmxP9q/temp_libpath3084f2d0bd7'
#> (as 'lib' is unspecified)
#> 
#> The downloaded binary packages are in
#>  /var/folders/41/lf3t3prs7d1467m30dvgxksw0000gp/T//RtmpdUiDIw/downloaded_packages
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#> * checking for file ‘/private/var/folders/41/lf3t3prs7d1467m30dvgxksw0000gp/T/RtmpdUiDIw/remotes7a093291e033/seandavi-romicidx-78ab6fa/DESCRIPTION’ ... OK
#> * preparing ‘romicidx’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> Omitted ‘LazyData’ from DESCRIPTION
#>   NB: this package now depends on R (>= 4.1.0)
#>   WARNING: Added dependency on R >= 4.1.0 because package code uses the
#>   pipe |> or function shorthand \(...) syntax added in R 4.1.0.
#>   File(s) using such syntax:
#>     ‘Omicidx.Rd’
#> * building ‘romicidx_0.2.1.tar.gz’
#> Installing package into '/private/var/folders/41/lf3t3prs7d1467m30dvgxksw0000gp/T/RtmpSmxP9q/temp_libpath3084f2d0bd7'
#> (as 'lib' is unspecified)
```

## Usage

### Omicidx R6 Class

The `OmicIDX` R6 class provides methods to connect to the DuckDB
database and perform queries.

``` r
library(romicidx)
#> Loading required package: DBI
#> Loading required package: duckdb
#> Loading required package: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> Loading required package: dbplyr
#> 
#> Attaching package: 'dbplyr'
#> The following objects are masked from 'package:dplyr':
#> 
#>     ident, sql
#> Loading required package: R6
omicidx <- Omicidx$new()
```

To list available tables:

``` r
tables <- omicidx$table_names()
print(tables)
#>    ((table_schema || '.') || table_name)
#> 1                          main._catalog
#> 2                      mart.sra_metadata
#> 3                    raw.ncbi_biosamples
#> 4                    raw.sra_experiments
#> 5                           raw.sra_runs
#> 6                        raw.sra_samples
#> 7                        raw.sra_studies
#> 8              staging.stg_geo_platforms
#> 9                staging.stg_geo_samples
#> 10                staging.stg_geo_series
#> 11          staging.stg_ncbi_bioprojects
#> 12           staging.stg_ncbi_biosamples
#> 13            staging.stg_sra_accessions
#> 14           staging.stg_sra_experiments
#> 15                  staging.stg_sra_runs
#> 16               staging.stg_sra_samples
#> 17               staging.stg_sra_studies
```

The `omicidx` object also provides methods to perform sql queries and
dplyr operations.

``` r
# SQL query
res <- omicidx$sql("SELECT * FROM staging.stg_sra_runs LIMIT 10")
print(res)
#>     accession experiment_accession title run_center run_date center_name
#> 1  SRR4652455           SRX2310319  <NA>       <NA>     <NA>        <NA>
#> 2  SRR4661781           SRX2310320  <NA>       <NA>     <NA>        <NA>
#> 3  SRR4661782           SRX2310321  <NA>       <NA>     <NA>        <NA>
#> 4  SRR4661783           SRX2310322  <NA>       <NA>     <NA>        <NA>
#> 5  SRR4661784           SRX2310323  <NA>       <NA>     <NA>        <NA>
#> 6  SRR4661785           SRX2310324  <NA>       <NA>     <NA>        <NA>
#> 7  SRR4661786           SRX2310325  <NA>       <NA>     <NA>        <NA>
#> 8  SRR4661787           SRX2310326  <NA>       <NA>     <NA>        <NA>
#> 9  SRR4661788           SRX2310327  <NA>       <NA>     <NA>        <NA>
#> 10 SRR4661789           SRX2310328  <NA>       <NA>     <NA>        <NA>
#>    broker_name                                        alias  GEO
#> 1         <NA> P0028_MT_I2722_TTCATACG_L001_R1_001.fastq.gz <NA>
#> 2         <NA>             FSL_E2-0214_R1.trimmedP.fastq.gz <NA>
#> 3         <NA>             FSL_K6-1142_R2.trimmedP.fastq.gz <NA>
#> 4         <NA>             FSL_K6-1030_R2.trimmedP.fastq.gz <NA>
#> 5         <NA>             FSL_H8-0481_R1.trimmedP.fastq.gz <NA>
#> 6         <NA>             FSL_H7-0909_R1.trimmedP.fastq.gz <NA>
#> 7         <NA>             FSL_H7-0676_R1.trimmedP.fastq.gz <NA>
#> 8         <NA>             FSL_F4-0079_R2.trimmedP.fastq.gz <NA>
#> 9         <NA>             FSL_H8-0063_R1.trimmedP.fastq.gz <NA>
#> 10        <NA>             FSL_H8-0534_R2.trimmedP.fastq.gz <NA>
#>                                                     identifiers attributes
#> 1  P0028_MT_I2722_TTCATACG_L001_R1_001.fastq.gz, SUB2043882, NA       NULL
#> 2              FSL_E2-0214_R1.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 3              FSL_K6-1142_R2.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 4              FSL_K6-1030_R2.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 5              FSL_H8-0481_R1.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 6              FSL_H7-0909_R1.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 7              FSL_H7-0676_R1.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 8              FSL_F4-0079_R2.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 9              FSL_H8-0063_R1.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 10             FSL_H8-0534_R2.trimmedP.fastq.gz, SUB2043904, NA       NULL
#>    qualities has_complete_run_info          _loaded_at
#> 1                            FALSE 2025-10-30 23:06:34
#> 2                            FALSE 2025-10-30 23:06:34
#> 3                            FALSE 2025-10-30 23:06:34
#> 4                            FALSE 2025-10-30 23:06:34
#> 5                            FALSE 2025-10-30 23:06:34
#> 6                            FALSE 2025-10-30 23:06:34
#> 7                            FALSE 2025-10-30 23:06:34
#> 8                            FALSE 2025-10-30 23:06:34
#> 9                            FALSE 2025-10-30 23:06:34
#> 10                           FALSE 2025-10-30 23:06:34
```

``` r
# dplyr query
sra_studies_tbl <- omicidx$tbl("staging.stg_sra_studies")
result <- sra_studies_tbl |>
  head(10) |>
  collect()
print(result)
#> # A tibble: 10 × 17
#>    accession study_accession title   description abstract study_type center_name
#>    <chr>     <chr>           <chr>   <chr>       <chr>    <chr>      <chr>      
#>  1 SRP009395 SRP009395       Subtro… <NA>        The sco… Metagenom… Biodiversi…
#>  2 SRP009396 SRP009396       Identi… <NA>        The aim… Other      GEO        
#>  3 SRP009397 SRP009397       Entamo… <NA>        Parasit… Whole Gen… JCVI       
#>  4 SRP009399 SRP009399       Genome… <NA>        Backgro… Whole Gen… Umass Medi…
#>  5 SRP009401 SRP009401       Transc… <NA>        Sacchar… Transcrip… GEO        
#>  6 ERP001015 ERP001015       Antarc… Pyrosequen… The ext… Metagenom… ICTAR      
#>  7 SRP009402 SRP009402       Charac… <NA>        The pre… Transcrip… Graduate U…
#>  8 SRP009404 SRP009404       Transc… <NA>        To unde… Transcrip… Shanghai O…
#>  9 SRP009407 SRP009407       Cheese… <NA>        Grana T… Metagenom… IASMA rese…
#> 10 SRP009408 SRP009408       MicroR… <NA>        Backgro… Transcrip… GEO        
#> # ℹ 10 more variables: broker_name <chr>, alias <chr>, BioProject <chr>,
#> #   GEO <chr>, pubmed_ids <list>, has_complete_metadata <lgl>,
#> #   attributes <list>, identifiers <list>, xrefs <list>, `_loaded_at` <dttm>
```

### Duckdb Connection and SQL Queries

Connect to the OmicIDX DuckDB database:

``` r
library(omicidx)
#> 
#> Attaching package: 'omicidx'
#> The following object is masked from 'package:romicidx':
#> 
#>     omicidx_duckdb_connection

con <- omicidx_duckdb_connection()
```

This creates a read-only connection to the remote database. The database
doesn’t contain data directly but links to parquet files in cloud
storage.

### Listing Available Tables

``` r
tables <- DBI::dbListTables(con)
print(tables)
#>  [1] "_catalog"             "ncbi_biosamples"      "sra_experiments"     
#>  [4] "sra_metadata"         "sra_runs"             "sra_samples"         
#>  [7] "sra_studies"          "stg_geo_platforms"    "stg_geo_samples"     
#> [10] "stg_geo_series"       "stg_ncbi_bioprojects" "stg_ncbi_biosamples" 
#> [13] "stg_sra_accessions"   "stg_sra_experiments"  "stg_sra_runs"        
#> [16] "stg_sra_samples"      "stg_sra_studies"
```

### Querying with SQL

Use standard SQL queries via DBI:

``` r
# Get first 10 rows from sra_runs table
res <- DBI::dbGetQuery(con, "SELECT * FROM staging.stg_sra_runs LIMIT 10")
print(res)
#>     accession experiment_accession title run_center run_date center_name
#> 1  SRR4652455           SRX2310319  <NA>       <NA>     <NA>        <NA>
#> 2  SRR4661781           SRX2310320  <NA>       <NA>     <NA>        <NA>
#> 3  SRR4661782           SRX2310321  <NA>       <NA>     <NA>        <NA>
#> 4  SRR4661783           SRX2310322  <NA>       <NA>     <NA>        <NA>
#> 5  SRR4661784           SRX2310323  <NA>       <NA>     <NA>        <NA>
#> 6  SRR4661785           SRX2310324  <NA>       <NA>     <NA>        <NA>
#> 7  SRR4661786           SRX2310325  <NA>       <NA>     <NA>        <NA>
#> 8  SRR4661787           SRX2310326  <NA>       <NA>     <NA>        <NA>
#> 9  SRR4661788           SRX2310327  <NA>       <NA>     <NA>        <NA>
#> 10 SRR4661789           SRX2310328  <NA>       <NA>     <NA>        <NA>
#>    broker_name                                        alias  GEO
#> 1         <NA> P0028_MT_I2722_TTCATACG_L001_R1_001.fastq.gz <NA>
#> 2         <NA>             FSL_E2-0214_R1.trimmedP.fastq.gz <NA>
#> 3         <NA>             FSL_K6-1142_R2.trimmedP.fastq.gz <NA>
#> 4         <NA>             FSL_K6-1030_R2.trimmedP.fastq.gz <NA>
#> 5         <NA>             FSL_H8-0481_R1.trimmedP.fastq.gz <NA>
#> 6         <NA>             FSL_H7-0909_R1.trimmedP.fastq.gz <NA>
#> 7         <NA>             FSL_H7-0676_R1.trimmedP.fastq.gz <NA>
#> 8         <NA>             FSL_F4-0079_R2.trimmedP.fastq.gz <NA>
#> 9         <NA>             FSL_H8-0063_R1.trimmedP.fastq.gz <NA>
#> 10        <NA>             FSL_H8-0534_R2.trimmedP.fastq.gz <NA>
#>                                                     identifiers attributes
#> 1  P0028_MT_I2722_TTCATACG_L001_R1_001.fastq.gz, SUB2043882, NA       NULL
#> 2              FSL_E2-0214_R1.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 3              FSL_K6-1142_R2.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 4              FSL_K6-1030_R2.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 5              FSL_H8-0481_R1.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 6              FSL_H7-0909_R1.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 7              FSL_H7-0676_R1.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 8              FSL_F4-0079_R2.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 9              FSL_H8-0063_R1.trimmedP.fastq.gz, SUB2043904, NA       NULL
#> 10             FSL_H8-0534_R2.trimmedP.fastq.gz, SUB2043904, NA       NULL
#>    qualities has_complete_run_info          _loaded_at
#> 1                            FALSE 2025-10-30 23:06:34
#> 2                            FALSE 2025-10-30 23:06:34
#> 3                            FALSE 2025-10-30 23:06:34
#> 4                            FALSE 2025-10-30 23:06:34
#> 5                            FALSE 2025-10-30 23:06:34
#> 6                            FALSE 2025-10-30 23:06:34
#> 7                            FALSE 2025-10-30 23:06:34
#> 8                            FALSE 2025-10-30 23:06:34
#> 9                            FALSE 2025-10-30 23:06:34
#> 10                           FALSE 2025-10-30 23:06:34
```

### Using dplyr

The connection works seamlessly with dplyr for data manipulation:

``` r
library(dplyr)

# Access a table
sra_studies_tbl <- tbl(con, "staging.stg_sra_studies")

# Query with dplyr syntax
result <- sra_studies_tbl |>
  head(10) |>
  collect()

# More complex queries
studies_by_type <- sra_studies_tbl |>
  group_by(study_type) |>
  count() |>
  arrange(desc(n)) |>
  head(20) |>
  collect()
```

## How It Works

The package uses DuckDB’s httpfs extension to connect to a remote
read-only database. When you query tables, DuckDB fetches the necessary
parquet files from cloud storage on demand, providing efficient access
to large-scale omics metadata without downloading entire datasets.

## License

MIT + file LICENSE
