#' @import tidyverse
#' @import googleway
#' @import htmlwidgets
#' @import webshot
#' @import raster
#' @import png
#' @import plotwidgets
#' @import httr
#' @import sp
#' @import sf

if(F){
  roxygen2::roxygenise("~/Documents/github/googletraffic")
}

#' Make Google Traffic Raster
#' 
#' Make a raster from Google traffic data, where each pixel has one of four values
#' indicating traffic volume (no traffic, light, moderate, and heavy).
#' 
#' @param location Vector of latitude and longitude
#' @param height Height
#' @param width Width
#' @param zoom Zoom level; integer from 0 to 20. For more information, see [here](https://wiki.openstreetmap.org/wiki/Zoom_levels)
#' @param webshot_delay How long to wait for google traffic layer to render. Larger height/widths require longer delay times.
#'
#' @return Returns a georeferenced raster file. The file can contain the following values: 1 = no traffic; 2 = light traffic; 3 = moderate traffic; 4 = heavy traffic.
#' @export
gt_make_raster <- function(location,
                           height,
                           width,
                           zoom,
                           webshot_delay,
                           google_key){
  
  ## Filename; as html
  filename_html <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".html")
  
  ## Make html
  gt_make_html(location = location,
               height = height,
               width = width,
               zoom = zoom,
               filename = filename_html,
               google_key = google_key)
  
  ## Make raster
  r <- gt_html_to_raster(filename = filename_html,
                         location = location,
                         height = height,
                         width = width,
                         zoom = zoom,
                         webshot_delay = webshot_delay)
  
  ## Delete html file
  unlink(filename_html)
  
  return(r)
}