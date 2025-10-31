#' R6 Class for Omicidx Database Interaction
#'
#' @description
#' The `Omicidx` R6 class provides an interface for interacting with the omicidx database.
#'
#' @examples 
#' # # Create a new Omicidx object
#' omicidx <- Omicidx$new()
#' # # List all table names in the database
#' omicidx$table_names()
#' # Get a dplyr table object for a specific table
#' sra_studies_tbl <- omicidx$tbl("sra_studies")
#' # Perform a dplyr query
#' result <- sra_studies_tbl |>
#'   filter(study_type == "RNA-Seq") |>
#'   head(10) |>
#'   collect()
#' print(result)
Omicidx <- R6::R6Class(
  "Omicidx",
  public = list(

    #' @field connection A DBI connection object to the omicidx database.
    connection = NULL,

    #' @field .dplyr_tbls A list to cache dplyr table objects.
    .dplyr_tbls = list(),

    #' @description
    #' Create a new `Omicidx` object
    #'
    #' @param con An optional DBI connection object. If NULL, a new connection will be created.
    #'
    #' @return A new `Omicidx` object.
    initialize = function(con = NULL) {
      if (!is.null(con)) {
        self$connection <- con
      } else {
        self$connection <- omicidx_duckdb_connection()
      }
    },

    #' @description
    #' Execute a SQL query on the omicidx database.
    #'
    #' @param query A string containing the SQL query to execute.
    #'
    #' @return A data frame containing the results of the query.
    sql = function(query) {
      DBI::dbGetQuery(self$connection, query)
    },

    #' @description
    #' List all table names in the omicidx database.
    #'
    #' @return A data frame containing the names of all tables in the database.
    table_names = function() {
      omicidx_db_tables(self$connection)
    },

    #' @description
    #' Get a dplyr table object for a specified table in the omicidx database.
    #'
    #' @details
    #' This method retrieves a dplyr table object for the specified table name.
    #' If the table has been previously accessed, it will return the cached version.
    #' If the table_name does not exist, an error will be raised.
    #'
    #' @param table_name A string specifying the name of the table.
    #'
    #' @return A dplyr table object for the specified table.
    tbl = function(table_name) {
      if (!(table_name %in% self$table_names()[,1])) {
        stop(paste0("Table '", table_name, "' does not exist in the database."))
      }
      if (table_name %in% names(self$.dplyr_tbls)) {
        return(self$.dplyr_tbls[[table_name]])
      }
      tbl <- dplyr::tbl(self$connection, table_name)
      self$.dplyr_tbls[[table_name]] <- tbl
      return(tbl)
    }
  )
)
