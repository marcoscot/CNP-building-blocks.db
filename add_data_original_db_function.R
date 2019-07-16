## your_file is destination file, file_to_add is data to add with column names = Id,
## Name, values..., value_to_add_location is the column number of the value to add so
## that you can iterate the function over different column numbers, i.e. food components

Add_data <- function(your_file, file_to_add, value_to_add_location){
  ## vector of food Ids
  all_names <- colnames(your_file)
  raw_data_OK <- file_to_add[,1]$Id
  raw_names <- colnames(file_to_add)
  Food_Id <- c(your_file[,1])
  rr <- length(Food_Id)
  conta <- 1
  ## for every line k in file_to_add
  for(k in 1:nrow(file_to_add)){
    ## if column name 
    {
      if(colnames(file_to_add[value_to_add_location]) %in% all_names){
        ## xpos is column number of value in your file
        xpos <- match(colnames(file_to_add[value_to_add_location]), all_names)
      }
      else{
        new_column <- c(rep(NA, nrow(your_file)))
        name_column <- colnames(file_to_add[value_to_add_location])
        your_file <- cbind(your_file, name_column = new_column)
        colnames(your_file)[ncol(your_file)] <- name_column
        all_names <- colnames(your_file)
        xpos <- match(colnames(file_to_add[value_to_add_location]), all_names)
      }
    }
    ##
    ## if food Id in your_file
    {
      if(raw_data_OK[k] %in% Food_Id){
        ## ypos is the line number of Food_Id in your_file
        ypos <- which(Food_Id == raw_data_OK[k])
        ## add value in corresponding column in your_file
        your_file[ypos,xpos] <- as.numeric(file_to_add[k, value_to_add_location])
      }
      else{
        ## add row with new data
        your_file[(rr + conta), 1] <- as.character(file_to_add[k, 1])
        your_file[(rr + conta), 2] <- as.character(file_to_add[k, 2])
        your_file[(rr + conta), xpos] <- as.numeric(file_to_add[k, value_to_add_location])
        conta <- conta + 1
      }
    }
    ##
    ##
  }
  return(your_file)
}
