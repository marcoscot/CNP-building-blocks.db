### clean the working space
rm(list = ls(all = TRUE))

### setwd("directory")
library("readxl")
library("xlsx")
### getwd()

### commands that calculate the average CNP content of food categories (i.e. vegetables, fruits...)

### dataframe with around 300 foods with the codes 
code_file <- read_xlsx("food_data_background.xlsx", sheet = "Codes")

### dataframe with food category list to fill in with the average CNP for each food category
Avg <- read_xlsx("food_data_background.xlsx", sheet = "Average food types")

### dataframe of all food items with CNP content (but no codes for food types)
Food_db <- read.xlsx(file = "food_elemental_composition_db.xlsx", sheetIndex = 1, header = TRUE, stringsAsFactors = FALSE)

### list of food codes (F, V...)
Code_list = Avg$Code

### commands to create dataframe with the number of elements in code_file for every food code (V, S, F...)
Tot_code <- data.frame(matrix(NA, nrow = 1, ncol = length(Code_list)))
colnames(Tot_code)<- c(1:13)

### commands that fill the df Tot_code with the values and change the colnames to Number_of_C/F/S...
for(element in 1:length(Code_list)){
	name <- Code_list[element]
	Num_element <- paste("Number_of_", name, sep = "")
	value <- sum(code_file$Codes == name, na.rm = TRUE)
	colnames(Tot_code)[ element] <- Num_element
	Tot_code[1,element] <- value
}

### from code_file check the code name and the food_id to find the element in Food_db,
### in the line of the corresponding code in Avg sum the value for CNP
first_lines <- 310
eleme_types <- rep(0,nrow(Avg))
names(eleme_types) <- Avg$Code
for(line in 1:first_lines){
	Food_type <- as.character(code_file[line,"Codes"])
	sel_code <- which(Avg$Code == Food_type)
	eleme_types[sel_code] <- eleme_types[sel_code] + 1
	db_line <- which(as.numeric(Food_db$Id) == as.numeric(code_file[line,1]))
	Avg_line <- which(Code_list == Food_type)
	Avg[Avg_line,"C"] <- Avg[Avg_line,"C"] + as.numeric(Food_db[db_line,"C"])
	Avg[Avg_line,"N"] <- Avg[Avg_line,"N"] + as.numeric(Food_db[db_line,"N"])
	Avg[Avg_line,"P"] <- Avg[Avg_line,"P"] + as.numeric(Food_db[db_line,"P"])
}

### do the average from the totals by dividing for the number of elements
for(column in 3:5){
	for(i in 1:length(Code_list)){
	Avg[i,column] <- Avg[i,column]/eleme_types[i]
	}
}
Avg2 <- as.data.frame(Avg)

###
###

### SAVE THE OUTPUT IN A NEW FILE

write.xlsx(Avg2, file= "food_category_CNP_db.xlsx", sheetName = "Food cat comp",
col.names = TRUE, row.names = FALSE, append = TRUE)
