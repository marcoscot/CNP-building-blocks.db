# CNP-building-blocks.db
R scripts for constructing a database on elemental composition (carbon, nitrogen and phosphorus) of food items

the project is based on four steps

(1) original and incomplete data sets are combined for the comprehensive description concerning the content of macronutrients and constitutive molecules (e.g. proteins with amino acids) in more than 950 food items
- input files: (i) partial_db_original.xlsx (it includes fatty acids and starch for 450 food items); (ii) macronutrients details.xlsx (with multiple sheets that include various details; e.g. carbon and nitrogen content in amino acids, sugar, protein and fat contents in more than 860 food items and phosphorus concentration in food)
- R scripts: (i) add_data_original_db_function.R (function that adds details on macronutrient and molecular composition of food items in a data set); (ii) add_data_original_db.R (script that calls the function add_data_original_db_function.R to integrate the incomplete dataset partial_db_original.xlsx (that only includes starch and fatty acids content for 450 food items) with more food items and concentration of various macromolecules (e.g. fats, sugars and proteins) and their constitutive molecules (e.g. fatty acids, carbohydrates and amino acids)
- output: merged_db_original.xlsx - such file includes the complete description of 955 food items in terms of macromolecules (i.e. total carbohydrates, protein and lipids) and their constitutive molecules (e.g. fatty acids: FA12_0 = C12:0, FA14_0 = C14:0, FA16_0 = C16:0, FA18_0 = C18:0, FA18_1 = C18:1, FA18_2 = C18:2, FA18_3 = C18:3, FA20_4 = C20:4, FA20_5 = C20:5, FA22_6 = C22:6); the output generated at this step is the first part of the database: nutrient composition of food items

(2) management of the data in the merged_db_original.xlsx file - first, NA values are classified as either zeros or proper missing values; second, for each food item a comparison between the total macronutrient content and the sum of its constitutive molecules is carried out
operations described in this step corresponds to the white boxes visualized in Figure 1 of Romeo et al. (to be submitted to Scientific Data). CNP-building-blocks.db: a comprehensive database about carbon, nitrogen and phosphorus content in simple and processed food.
- input files: (i) merged_db_original.xlsx (for which evaluation of NA values and validation of building block composition vs. total macronutrient content must be performed for each food item); (ii) macronutrients details.xlsx (to import details on carbon and nitrogen concentration in the building block molecules of sugars, proteins and lipids - see the sheet "Element")
- R scripts: 

The transformation of NA values and the balancing are obtained from the complete database of original data and the scripts "Manage NA $+$ correct total.R", "Manage NA function.R", and "Check totals function.R". The file obtained is the "Food\_nutrient\_composition\_db.xlsx".
