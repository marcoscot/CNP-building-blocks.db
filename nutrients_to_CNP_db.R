### clean the working space
rm(list = ls(all = TRUE))

### setwd("directory")
library("readxl")
library("xlsx")
### getwd()


### CREATE C N P DATABASE
element_file <- read_xlsx("macronutrient_details.xlsx", sheet = "Element", col_names = TRUE)
source_file <- read.xlsx(file = "food_nutrient_composition_db.xlsx", header = TRUE, sheetIndex = 1, stringsAsFactors = FALSE)

final_db <- data.frame(Id = rep(NA, nrow(source_file)), Food_name = rep(NA, nrow(source_file)), C = rep(NA, nrow(source_file)), N =  rep(NA, nrow(source_file)), P = rep(NA, nrow(source_file)))
P_position <- 15


### vector of nutrient names in source_file
nutrient_names <- c(colnames(source_file))

### vector of nutrient names in element_file
nutrient_column <- c()
for(i in 1: nrow(element_file)){
  nutrient_column[i] <- element_file[i,1]
}
nutrient_column <- unlist(nutrient_column)
## nutrient_column[1]

for(line in 1:nrow(source_file)){
    C_calc <- as.numeric(0)
    N_calc <- as.numeric(0)
    ### copy Id and Food_name
    for (x in 1:2){
		final_db[line,x] <- as.character(source_file[line,x])
    }
    ### copy P content
    final_db[line,"P"] <- ifelse(is.na(source_file[line,P_position]) | source_file[line,P_position] == "NA", 0, as.numeric(source_file[line,P_position]))
    ###
    ### for every nutrient column (note the last 3 columns are the tot carb, prot, etc., so are excluded)
    for (element in 3: (ncol(source_file)-3)){
      if ( element != 15){
        ### value = nutrient value
        value <- as.numeric(source_file[line,element])
        ### find row in element_file for that nutrient
        column_element_file <- which( nutrient_column == nutrient_names[element])
        ### add to C_calc and N_calc the nutrient % in terms of C & N
        C_calc <- C_calc + value * as.numeric(element_file[column_element_file,"C"])
        N_calc <- N_calc + value * as.numeric(element_file[column_element_file,"N"])
      }
    }
    final_db[line,"C"] <- as.numeric(C_calc)
    final_db[line,"N"] <- as.numeric(N_calc)
}

###
###

### alternative calculation of N content starting from conversion factors: (1) average value of 6.25;
### (2) various conversion factors proposed by Mariotti et al. (2008) - stored in an Excel file for transparency

new_db <- final_db
mariotti_classified <- read.xlsx(file = "Mariotti.xlsx", sheetName = "classified_Mariotti", header = TRUE, stringsAsFactors = FALSE)
mariotti_factors <- read.xlsx(file = "Mariotti.xlsx", sheetName = "Mariotti", header = TRUE, stringsAsFactors = FALSE)

constant_CF <- 6.25
new_db[,"N_constant_CF"] <- source_file[,"Protein"]/constant_CF

for(x in 1:nrow(new_db)){
	code <- mariotti_classified[x,"final_codes"]
	factor_row <- which(mariotti_factors[,"code"] == code)
	new_db[x,"N_Mariotti"] <- source_file[x,"Protein"]/mariotti_factors[factor_row,2]
}


### SAVE DATA IN A NEW FILE

write.xlsx(new_db, file = "food_elemental_composition_db.xlsx", col.names = TRUE, row.names = FALSE, append = TRUE)
