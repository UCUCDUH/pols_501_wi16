library("dplyr")

# Author: Nick Cooper, package NCmisc
functions_in_file <- function (filename, alphabetic = TRUE) {
    if (!file.exists(filename)) {
        stop("couldn't find file ", filename)
    }
    if (!get.ext(filename) == "R") {
        warning("expecting *.R file, will try to proceed")
    }
    tmp <- getParseData(parse(filename, keep.source = TRUE))
    crit <- quote(token == "SYMBOL_FUNCTION_CALL")
    tmp <- dplyr::filter(tmp, .dots = crit)
    tmp <- unique(if (alphabetic) {
        sort(tmp$text)
    }
    else {
        tmp$text
    })
    src <- paste(as.vector(sapply(tmp, find)))
    outlist <- tapply(tmp, factor(src), c)
    return(outlist)
}

