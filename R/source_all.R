#' Source R Scripts with path relative to current working directory
#'
#' @description
#' Sources all R scripts (or files matching a specified pattern) from a given directory.
#' This function is useful for batch loading multiple script files in a single command.
#'
#' @param path A character string specifying the directory containing the R scripts to source.
#' @param pattern A regular expression string to match the filenames to be sourced. 
#'        Defaults to \code{"\\.R$"} which matches all files with the ".R" extension.
#'
#' @details
#' This function enables users to load multiple R scripts at once from a specified directory.
#' It finds all files in the specified directory that match the given pattern and sources each one.
#'
#' Note: This function cannot handle R scripts that contain code outside of function definitions.
#' It is best used with files that define functions or variables without executing side effects.
#'
#' @return
#' Returns \code{invisible(NULL)}. The primary effect is sourcing the files, not returning a value.
#'
#' @examples
#' # Source all R files in a "helpers" subdirectory
#' source_all("helpers")
#'
#' # Source only files with names starting with "util_" in the "utils" directory
#' source_all("utils", pattern = "^util_.*\\.R$")
#'
#' # Source all R files in the parent directory
#' source_all("..")
#'
#' @seealso 
#' \code{\link[base]{source}} for sourcing individual files
#' \code{\link[base]{list.files}} for the underlying file listing mechanism
#'
#' @export
source_all <- function(path, pattern = "\\.R$") {
  # List files matching the pattern in the specified directory
  files.sources = list.files(path = path, pattern = pattern, full.names = TRUE)
  
  # Provide feedback if no matching files are found
  if (length(files.sources) == 0) {
    message("No files matching the pattern were found in the specified directory.")
  }
  
  # Source all matching files
  sapply(files.sources, source)
  
  return(invisible(NULL))
}