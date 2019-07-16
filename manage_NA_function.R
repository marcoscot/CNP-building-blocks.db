### the function classifies the NA values as either zeros or non zero values

library("readxl")
library("xlsx")
## getwd()

Manage_NA <- function(source_file, element_file, Names_x, Pos_x,Tot_x, Subtract, quality_file){
  for(i in 1:nrow(source_file)){
    x <- which(is.na(source_file[i,])|source_file[i, ] =='NA' )
    if(length(x)!=0){
    for( y in 1:length(x)){quality_file[i,x[y]] <- 'ND'}
    }
    if (is.na(source_file[i, Tot_x])){
      source_file[i, Tot_x] = as.numeric(0)
    }
    if (is.na(source_file[i, 13])|source_file[i, 13] =='NA'  ){
      source_file[i, 13] = as.numeric(0)
    }
    if (is.na(source_file[i, 15])|source_file[i, 15] =='NA'  ){
      source_file[i, 13] = as.numeric(0)
    }
    ## if all the values of the same category (S,P,L) are NA
    if(sum(is.na(source_file[i, Names_x])) == length(Names_x)){
      Tot_amount_x <- as.numeric(source_file[i,Tot_x])
      ## subtract starch from tot carbohydrates to have sugars
      if(Subtract != 0){
        Tot_amount_x <- Tot_amount_x - as.numeric(source_file[i, Subtract])
        ## if more starch than tot carbs, reduce starch 
        if(Tot_amount_x<0){
          source_file[i, Subtract] <- as.numeric(source_file[i, Subtract])+ Tot_amount_x
          quality_file[i, Subtract] <- 'AVA-'
          for (j in Pos_x[1]:Pos_x[2]){
            if (is.na(source_file[i,j]) | source_file[i,j] =='NA'){
              source_file[i,j] <- 0
            }
          }
          next
        }
      }
      ## assign to every nutrient an equal share of the total 
      for (j in Pos_x[1]:Pos_x[2]){
        source_file[i, j] <- Tot_amount_x/ length(Names_x)
        if (source_file[i, j] != 0) {quality_file[i, j] <- 'MVR'}
      }
    } else{
      ## if only some values are NA then set to 0
      for (j in Pos_x[1]:Pos_x[2]){
        if (is.na(source_file[i,j]) | source_file[i,j] =='NA'){
          source_file[i,j] <- 0
        }
      }
    }
  }
  return(list(source_file, quality_file))
}