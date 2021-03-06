#' Query for source definition
#' @importFrom dplyr rename_all
#' @importFrom dplyr left_join
#' @importFrom dplyr rename_all
#' @export

query_cui_relationships <-
        function(cui) {
                sql_statement <-
                        paste0("SELECT * FROM MRREL WHERE CUI1 = '", cui, "';")

                output_01 <- submit_query(sql_statement = sql_statement)

                if (nrow(output) > 0) {
                        sql_statement <-
                                paste0("SELECT * FROM MRCONSO WHERE CUI IN (", paste(paste0("'",output$CUI2, "'"), collapse = ", "), ");"
                                       )
                        output_02 <- submit_query(sql_statement = sql_statement)
                        output_02 <-
                                output_02 %>%
                                dplyr::rename_all(function(x) paste0("MRCONSO_", x))
                }

                output <- dplyr::left_join(output_01,
                                           output_02,
                                           by = c("CUI2" = "MRCONSO_CUI"),
                                           suffix = c(".mrrel", ".mrconso"))

                output <- split(output, output$REL)
                return(output)
        }
