#' Sleeps for the given number of seconds.
#' 
#' This function wraps the base Sys.sleep() function to make it mockable and
#' reachable inside unit tests.
#'
#' @param seconds `integer`. The maximum number of seconds to wait.
#' 
#' @importFrom checkmate assert_int
#'
#' @examplesIf FALSE
#' # Sleep for 1 second.
#' .sleep(1)
#' 
#' @keywords internal
#' @noRd
#' 
.sleep <- function(seconds) {
  
  assert_int(seconds)
  
  Sys.sleep(seconds)
}
