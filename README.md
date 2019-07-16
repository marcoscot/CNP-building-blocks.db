## CNP-building-blocks.db
R scripts for constructing a database on elemental composition (carbon, nitrogen and phosphorus) of food items; the project is based on four steps

### step 1
original and incomplete data sets are combined for the describing the content of macronutrients and constitutive molecules (e.g. proteins with amino acids) in more than 950 food items
- input: (i) **partial_db_original.xlsx** (it includes fatty acids and starch for 450 food items); (ii) **macronutrients details.xlsx** (with multiple sheets that include various details; e.g. carbon and nitrogen content in amino acids, sugar, protein and fat contents in more than 860 food items and phosphorus concentration in food)
- R scripts: (i) **add_data_original_db_function.R** (function that adds details on macronutrient and molecular composition of food items in a data set); (ii) **add_data_original_db.R** (script that calls the function add_data_original_db_function.R to integrate the incomplete dataset partial_db_original.xlsx (that only includes starch and fatty acids content for 450 food items) with more food items and concentration of various macromolecules (e.g. fats, sugars and proteins) and their constitutive molecules (e.g. fatty acids, carbohydrates and amino acids)
- output: **merged_db_original.xlsx** - such file includes the complete description of 955 food items in terms of macromolecules (i.e. total carbohydrates, protein and lipids) and their constitutive molecules (e.g. fatty acids: FA12_0 = C12:0, FA14_0 = C14:0, FA16_0 = C16:0, FA18_0 = C18:0, FA18_1 = C18:1, FA18_2 = C18:2, FA18_3 = C18:3, FA20_4 = C20:4, FA20_5 = C20:5, FA22_6 = C22:6) but still presents some issues (i.e. NA values and inconsistencies when comparing the total amounts of macromolecules vs. their constitutive building blocks)

### step 2
management of the data in merged_db_original.xlsx - first, NA values are classified as either zeros or proper missing values; second, for each food item a comparison between the total macronutrient content and the sum of its constitutive molecules is carried out
operations described in this step corresponds to the white boxes visualized in Figure 1 of Romeo et al. (to be submitted to Scientific Data). CNP-building-blocks.db: a comprehensive database about carbon, nitrogen and phosphorus content in simple and processed food.
- input: (i) **merged_db_original.xlsx** (for which evaluation of NA values and validation of building block composition vs. total macronutrient content must be performed for each food item); (ii) **macronutrients details.xlsx** (to import the concentration of molecules as amino acids, fatty acids and carbohydrates in different food items; the file also includes a classification of the various building block molecules into three categories of macromolecules - see column "Class" in the sheet "Element")
- R scripts: (i) **manage_NA_function.R** (function that classifies NA values as either zeros or non-zero values; i.e. in this latter case the total content of the macromolecule was evenly assigned to all its building blocks - this was the case of amino acids with respect to total amount of proteins); (ii) **check_totals_function.R** (function that compares the total amount of each macromolecule with the sum of the corresponding constitutive molecules - e.g. sum of amino acids vs. total protein concentration; if the difference exceeds by 1% in absolute value the total amount of macronutrient then such deviation is evenly redistributed among all partial components - either by adding or removing quantities of each building block molecule); (iii) **manage_NA---correct_total.R** (script that employs the two functions for dealing with NA values and inconsistencies between total macromolecules contents and their building block molecules; the script serves to obtain the first complete data output on food compositions and also produces a data quality file for technical validation)
- output: (i) **food_nutrient_composition_db.xlsx** (the file generated at this step is the first part of the database, which accounts for nutrient composition of food items; all molecules in the food nutrient composition database are expressed as grams per 100 grams of edible portion, fresh weight); (ii) **data_quality.xlsx** (file storing details on the type of changes made/record of modifications - if any - to obtain concentration values reported in the file food_nutrient_composition_db.xlsx) - possible codes displayed by the file: SD - source data, meaning that the value was available in original sources; ND - not defined, the value was not reported in the original sources and set to zero during the execution of the script; MVR - missing value recalculated, which means that the value was declared as NA in the original dataset but the execution of the script quantified the concentration of the element by evenly distributing among all molecules (e.g. amino acids) the total amount of the corresponding macronutrient category (e.g. proteins); AVA+ - available value adjusted in positive, value available in the original sources that was proportionally increased to match the sum of simple molecules with the total amount of the corresponding macronutrient category; AVA- - available value adjusted in negative, value available in the original sources that was proportionally decreased to match the sum of simple molecules with the total amount of the corresponding macronutrient category

### step 3
conversion of nutrient data stored in food_nutrient_composition_db.xlsx into corresponding elemental contents (i.e. the output file includes details on carbon, nitrogen and phosphorus contents in 955 food items)
- input: (i) **food_nutrient_composition_db.xlsx** (output of the previous step, it includes details on macromolecules and their constitutive building blocks for 955 food items; NA values and inconsistencies - i.e. lack of coherence between total contents of macromolecules and sums of the various molecules belonging to each macromolecule category - were removed by executing the scripts in step 2); (ii) **macronutrient_details.xlsx** (in particular, to import details on carbon and nitrogen concentration in the building block molecules of sugars, proteins and lipids - see columns "Component", "C" and "N" in the sheet "Element")
- R script: the commands in the file **nutrients_to_CNP_db.R** allow creating the comprehensive database on carbon, nitrogen and phosporous contents in 955 food items
- output: **food_elemental_composition_db.xlsx**, which represents the second part of the database (i.e. it summarizes elemental composition of 955 food items; all contents of the three elements are expressed as grams per 100 grams of edible portion, fresh weight)

### step 4
calculation of elemental composition (carbon, nitrogen and phosphorous) in 13 large food categories (e.g. vegetables, fruits, grains, seeds, meat and fish/seafood)
- input: (i) **food_elemental_composition_db.xlsx** (file including elemental composition of an extremely detailed list of food items; it was created in the previous step 3); (ii) **food_data_background.xlsx**, which provides a classification
- R script: the file **food_categories_average.R** is used to extract the subset of food items to consider for calculating the average carbon, nitrogen and phosphorous content in 13 large food categories; correspondence between single food items and the 13 categories is obtained trhough codes in the file food_data_background.xlsx
- output: **food_category_CNP_db.xlsx**, which reports average values of carbon, nitrogen and phosphorus in 13 large food categories (all contents of the three elements are expressed as grams per 100 grams of edible portion, fresh weight)
