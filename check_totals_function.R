library("readxl")
library("xlsx")
## getwd()

## CHECKS IF SUM OF PARTIAL COMPONENTS IS EQUAL TO TOT (1% of confidence range),
## if not proportionally redistributes the missing amounts over the different nutrients 

Check_totals <- function(source_file, Pos_x, Tot_x, To_add, quality_file){
  for (i in 1: nrow(source_file)){
    Summed_x <- 0
    for (j in Pos_x[1]:Pos_x[2]){
      ###sums nutrients of the same type
      Summed_x <- Summed_x + as.numeric(source_file[i, j])
    }
    ## add starch if needed
    if (To_add != 0){
      Summed_x <- Summed_x + as.numeric(source_file[i, To_add])
    }
    ## calculate difference between sum and total
    Rest_value <- as.numeric(source_file[i, Tot_x]) - Summed_x 
    ## if difference more than 1% redistribute it among the nutrients proportionally to their contribution to the sum
    if (Rest_value > (Tot_x/100)){
      for (j in Pos_x[1]:Pos_x[2]){
        if(Summed_x != 0){
          proportion <- as.numeric(source_file[i, j])/ Summed_x
          quality_file[i,j] <-'AVA+'
        } else{
          proportion <- 1/(length(Pos_x[1]:Pos_x[2]))
          quality_file[i,j] <-'MVR'
        }
        source_file[i, j] <- as.numeric(source_file[i, j]) + Rest_value * proportion
      }
    }
  }
  return(list(source_file, quality_file))
}
