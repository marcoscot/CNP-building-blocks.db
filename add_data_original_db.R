### clean the working space
rm(list = ls(all = TRUE))

### SET DIRECTORY
### setwd("directory")
library("readxl")
library("xlsx")
### getwd()

source('add_data_original_db_function.R')

### ADD FIBERS
Food_final <- read_xlsx('partial_db_original.xlsx')
To_add <- read_xlsx('macronutrient_details.xlsx', sheet = 'Fiber')
Data_location <- 3

Updated_file <- Add_data(your_file = Food_final, file_to_add = To_add, value_to_add_location = Data_location)
Food_final <- Updated_file
### View(Updated_file)


### ADD P
To_add <- read_xlsx('macronutrient_details.xlsx', sheet = 'Phosphorous')
Data_location <- 3
Updated_file <- Add_data(your_file = Food_final, file_to_add = To_add, value_to_add_location = Data_location)
Food_final <- Updated_file


### ADD CARBOHYDRATES
To_add <- read_xlsx('macronutrient_details.xlsx', sheet = 'Carbohydrates')
for (x in 3:12){
    Food_final <- Updated_file
    Data_location <- x
  
    Updated_file <- Add_data(your_file = Food_final, file_to_add = To_add, value_to_add_location = Data_location)
    Food_final <- Updated_file
    
}


### ADD AMINOACIDS
To_add <- read_xlsx('macronutrient_details.xlsx', sheet = 'Aminoacids')
for (x in 3:20){
  Food_final <- Updated_file
  Data_location <- x
  
  Updated_file <- Add_data(your_file = Food_final,file_to_add =  To_add, value_to_add_location =  Data_location)
  Food_final <- Updated_file
}

##
##

### ADD TOT CARBOHYDRATES
To_add <- read_xlsx('macronutrient_details.xlsx', sheet = 'Sugar')
Data_location <- 3
Updated_file <- Add_data(your_file = Updated_file, file_to_add = To_add, value_to_add_location = Data_location)

### ADD TOT PROTEIN
To_add <- read_xlsx('macronutrient_details.xlsx', sheet = 'Protein')
Data_location <- 3
Updated_file <- Add_data(your_file = Updated_file, file_to_add = To_add, value_to_add_location = Data_location)

### ADD TOT LIPIDS
To_add <- read_xlsx('macronutrient_details.xlsx', sheet = 'Fat')
Data_location <- 3
Updated_file <- Add_data(your_file = Updated_file, file_to_add = To_add, value_to_add_location = Data_location)

##
##

### SAVE DATA IN A NEW FILE
write.xlsx(Updated_file, 'merged_db_original.xlsx', row.names = FALSE, col.names = TRUE)
