#' List Database Tables in the omicidx database
#'
#' This function retrieves a list of all tables in the connected omicidx database.
#'
#' @param con A DBI connection object to the omicidx database.
#'
#' @return A data frame containing the names of all tables in the database.
#'
#' @examples
#' \dontrun{
#' con <- omicidx_duckdb_connection()
#' tables <- omicidx_db_tables(con)
#' print(tables)
#' }
#' @export
omicidx_db_tables <- function(con, schema = NULL) {
  if (!DBI::dbIsValid(con)) {
    stop("Invalid database connection.")
  }

  sql <- "SELECT table_schema || '.' || table_name FROM information_schema.tables"
  tbls <- DBI::dbGetQuery(con, sql)
  return(tbls)
}
