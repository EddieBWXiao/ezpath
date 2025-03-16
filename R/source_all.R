#' Source R Scripts with path relative to current working directory
#'
#' @description
#' Applying source() to batch load R scripts from a directory.
#' Optionally, sourced functions can go into a dedicated environment.
#' 
#' @param path Directory containing R scripts to source. Caution should be exercised when directory contains a mix of R functions and scripts.
#' @param pattern File pattern to match, defaults to all .R files. 
#' @param envir Optional environment for the sourced code. When specified, 
#'        functions can be accessed via \code{envir$function_name} notation.
#'        Defaults to global environment.
#'
#' @details
#' This function streamlines working with collections of R scripts by loading
#' them all at once. Similar to MATLAB addpath() for scripts containing functions.
#' When using the \code{envir} parameter, it creates a contained
#' namespace that prevents function name conflicts, and enables module-like access
#' patterns (i.e., access with envir$function_name; similar to \code{dplyr::filter()} or Python's \code{numpy.array()}).
#' 
#' 
#' @return
#' Returns \code{invisible(NULL)} when no environment is specified.
#' Returns the environment invisibly (via \code{invisible(envir)}) when an environment is provided.
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
#' # Create a dedicated environment for utility functions
#' utils_env <- new.env()
#' source_all("utils", envir = utils_env)
#' # Access functions using $ notation
#' utils_env$my_function()
#'
#' # Method chaining 
#' utils_env <- source_all("utils", envir = new.env())
#' utils_env$my_function()
#'
#' @seealso 
#' \code{\link[base]{source}} for sourcing individual files
#' \code{\link[base]{sys.source}} for sourcing files into specific environments
#' \code{\link[base]{list.files}} for the underlying file listing mechanism
#'
#' @export
source_all <- function(path, pattern = "\\.R$", envir = NULL) {
  # List files matching the pattern in the specified directory
  files.sources = list.files(path = path, pattern = pattern, full.names = TRUE)
  
  # Provide feedback if no matching files are found
  if (length(files.sources) == 0) {
    message("No files matching the pattern were found in the specified directory.")
    if (!is.null(envir)){
      return(invisible(envir))}
    else{
      return(invisible(NULL))
    }
  }
  
  # Main commands applying source()
  if (is.null(envir)) {
    # Source into global environment
    invisible(sapply(files.sources, source))
    return(invisible(NULL))
  } else {
    # Source into specified environment
    invisible(sapply(files.sources, function(file) {
      sys.source(file, envir = envir)
    }))
    return(invisible(envir))
  }
}