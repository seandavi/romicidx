.duckdb_file = "https://store.cancerdatasci.org/omicidx/omicidx.duckdb"


#' Establish a read-only connection to the OmicIDX DuckDB database.
#'
#' The omicidx DuckDB database is hosted remotely and accessed via the httpfs extension.
#' This function sets up a connection to the database for querying. The connection
#' is a normal DuckDB connection, but the database file is read-only.
#'
#' @return A DBI connection object to the OmicIDX DuckDB database.
#'
#' @examples
#' \dontrun{
#' con <- omicidx_duckdb_connection()
#' DBI::dbListTables(con)
#' # Example query
#' res <- DBI::dbGetQuery(con, "SELECT * FROM sra_runs LIMIT 10")
#' print(res)
#' }
#'
#' @export
omicidx_duckdb_connection <- function() {
  con <- DBI::dbConnect(duckdb::duckdb())
  DBI::dbExecute(con, "install 'httpfs'; LOAD 'httpfs'")
  DBI::dbExecute(con, paste0("ATTACH DATABASE '", .duckdb_file, "' AS omicidx"))
  DBI::dbExecute(con, "use omicidx")
  return(con)
}
