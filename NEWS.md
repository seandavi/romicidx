# romicidx 0.2.1

## Bug Fixes

* Fixed an issue where the staging schema was incorrectly referenced in examples.

# romicidx 0.2.0

## New Features

* Implemented R6 classes for database connections.
  * Table listing
  * sql execution
  * dplyr interface to tables

# omicidx 0.1.0

## Initial release

* Initial release of the omicidx package for accessing public omics metadata via a relational database.
* Paired with the omicidx database hosted in cloudflare R2 storage.
* Leverages the DBI and duckdb packages for database connectivity.