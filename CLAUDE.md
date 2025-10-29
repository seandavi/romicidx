# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`omicidx` is an R package that provides relational database (SQL, dbplyr) access to public omics metadata including SRA, GEO, BioSample, and BioProject. The underlying data are scraped daily from sources and stored as parquet files in cloud storage.

The package connects to a remote read-only DuckDB database hosted at `https://store.cancerdatasci.org/omicidx/omicidx.duckdb` using the httpfs extension. The database itself contains links to parquet files rather than direct data storage.

## Package Development Commands

### Documentation
- Build documentation: `Rscript -e "roxygen2::roxygenize()"`
- Build pkgdown site: `Rscript -e "pkgdown::build_site()"`

### Package Building
- Check package: `R CMD check .`
- Install package locally: `Rscript -e "devtools::install()"`
- Load package for development: `Rscript -e "devtools::load_all()"`

### Vignettes
- Build vignettes: `Rscript -e "devtools::build_vignettes()"`
- Vignettes use Quarto engine (specified in DESCRIPTION as VignetteBuilder)

## Architecture

### Core Functions (R/duckdb_connection.R)

The package has a simple architecture with two main exported functions:

1. **`get_omicidx_duckdb_location()`** - Returns the URL of the remote DuckDB database file
2. **`omicidx_duckdb_connection()`** - Establishes a read-only connection to the remote database by:
   - Creating a local DuckDB connection
   - Installing and loading the httpfs extension
   - Attaching the remote database with ATTACH DATABASE
   - Setting the active database with USE

### Database Connection Pattern

The connection pattern is unique: it creates a local DuckDB instance, then attaches a remote read-only database via httpfs. Users can query the remote data using standard DBI or dplyr operations, but the actual data files (parquet) are fetched from cloud storage on demand.

### Available Tables

The database contains tables including:
- `sra_runs`
- `sra_studies`
- Other omics metadata tables (exact list available via `DBI::dbListTables(con)`)

## Dependencies

Core dependencies (from DESCRIPTION):
- DBI - database interface
- duckdb - DuckDB R client
- dplyr - data manipulation

The package requires the httpfs extension for DuckDB to access remote database files over HTTP/HTTPS.

## Documentation Site

The package uses pkgdown for documentation site generation, deployed to GitHub Pages via GitHub Actions on push to main branch. The workflow includes Quarto setup for rendering vignettes.
