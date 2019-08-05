### clean the working space
rm(list = ls(all = TRUE))

### setwd("directory")
library("readxl")
library("xlsx")
### getwd()

source("manage_NA_function.R")
source("check_totals_function.R")

### NEXT LINES FILL THE DATABASE AND CHECK IF SUM EQUALS TO TOTAL, IF NOT THEY MAKE CORRECTIONS
### reports code for data quality

element_file <- read_xlsx("macronutrient_details.xlsx", sheet = "Element")
source_file <- read.xlsx("merged_db_original.xlsx", header = TRUE, sheetIndex = 1, stringsAsFactors = FALSE)

data_quality <- data.frame(matrix(data= "SD", nrow = nrow(source_file), ncol = ncol(source_file)), stringsAsFactors = FALSE)
colnames(data_quality) <- colnames(source_file)
data_quality[,1:2] <- source_file[,1:2]

### data quality labels:
### SD: Source data -> data available from sources and not NA
### ND: not defined -> value not reported in original data and set to 0 
### MVR: missing value re-calculated -> single value not available, calculated by equally distributing tot value
### AVA+: available value adjusted + -> single value available, increased of proportional share to match tot value
### AVA-: available value adjusted - -> single value available, but exceeding tot value, reduced to match tot value

Index_S <- which(element_file[,4] == "S")
Index_P <- which(element_file[,4] == "P")
Index_L <- which(element_file[,4] == "L")

Names_S <- c(element_file[Index_S, 1])$Component
Names_P <- c(element_file[Index_P, 1])$Component
Names_L <- c(element_file[Index_L, 1])$Component

Pos_S <- c(16,25)
Pos_P <- c(26,43)
Pos_L <- c(3,12)

Tot_S <- 44
Tot_P <- 45
Tot_L <- 46

S_subtract <- 13
No_subtract <- 0
source_file[,S_subtract] <- ifelse(is.na(source_file[,S_subtract]) | source_file[,S_subtract] == "NA", 0, source_file[,S_subtract])

S_updated <- Manage_NA(source_file = source_file, element_file = element_file, Names_x = Names_S, Pos_x = Pos_S, Tot_x = Tot_S, Subtract = S_subtract, quality_file = data_quality)
quality_S <- S_updated[[2]]

### traceback()

P_updated <- Manage_NA(source_file = S_updated[[1]], element_file = element_file, Names_x = Names_P, Pos_x = Pos_P, Tot_x = Tot_P, Subtract = No_subtract, quality_file = quality_S)
quality_P <- P_updated[[2]]
L_updated <- Manage_NA(source_file = P_updated[[1]], element_file = element_file, Names_x = Names_L, Pos_x = Pos_L, Tot_x = Tot_L, Subtract = No_subtract, quality_file = quality_P)
quality_L <- L_updated[[2]]

L_check <- Check_totals(source_file = L_updated[[1]], Pos_x = Pos_L, Tot_x = Tot_L, To_add = No_subtract, quality_file = quality_L)
quality_cL <- L_check[[2]]
P_check <- Check_totals(source_file = L_check[[1]], Pos_P, Tot_P, No_subtract, quality_file = quality_cL)
quality_cP <- P_check[[2]]
S_check <- Check_totals(source_file = P_check[[1]], Pos_x = Pos_S, Tot_x = Tot_S, To_add = S_subtract, quality_file = quality_cP)
quality_cS <- S_check[[2]]

All_updated <- S_check[[1]]
for(i in 1:nrow(All_updated)){
	if(is.na(All_updated[i,"Fiber"]) == TRUE | All_updated[i,"Fiber"] == "NA"){
	All_updated[i,"Fiber"] = as.numeric(0)
	}
	if(is.na(All_updated[i,"Phosphorus"]) == TRUE | All_updated[i,"Phosphorus"] == "NA"){
	All_updated[i,"Phosphorus"] = as.numeric(0)
	}
}

###
###

### SAVE OUTPUTS IN NEW FILES

write.xlsx(quality_cS, "data_quality.xlsx", sheetName = "Data", row.names = FALSE, col.names = TRUE)
write.xlsx(All_updated, "food_nutrient_composition_db.xlsx", row.names = FALSE, col.names = TRUE)
