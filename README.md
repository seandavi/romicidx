# omicidx

<!-- badges: start -->
<!-- badges: end -->

## Overview

`omicidx` provides relational database (SQL, dbplyr) access to public omics metadata including SRA, GEO, BioSample, and BioProject. The package connects to a remote DuckDB database containing links to daily-updated parquet files stored in cloud storage.

## Installation

You can install the development version of omicidx from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("seandavi/romicidx")
```

## Usage

### Establishing a Connection

Connect to the OmicIDX DuckDB database:

``` r
library(omicidx)

con <- omicidx_duckdb_connection()
```

This creates a read-only connection to the remote database. The database doesn't contain data directly but links to parquet files in cloud storage.

### Listing Available Tables

``` r
tables <- DBI::dbListTables(con)
print(tables)
```

### Querying with SQL

Use standard SQL queries via DBI:

``` r
# Get first 10 rows from sra_runs table
res <- DBI::dbGetQuery(con, "SELECT * FROM sra_runs LIMIT 10")
print(res)
```

### Using dplyr

The connection works seamlessly with dplyr for data manipulation:

``` r
library(dplyr)

# Access a table
sra_studies_tbl <- tbl(con, "sra_studies")

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

The package uses DuckDB's httpfs extension to connect to a remote read-only database. When you query tables, DuckDB fetches the necessary parquet files from cloud storage on demand, providing efficient access to large-scale omics metadata without downloading entire datasets.

## License

MIT + file LICENSE
