# CNP-building-blocks.db
R scripts for constructing a database on elemental composition (carbon, nitrogen and phosphorus) of food items

the project is based on four steps

(1) original and incomplete data sets are combined for the comprehensive description concerning the content of macronutrients and constitutive molecules (e.g. proteins with amino acids) in more than 900 food items
- input files: (i) partial_db_original.xlsx (it includes fatty acids and starch for 449 food items); (ii) macronutrients details.xlsx (with multiple sheets that include various details; e.g. carbon and nitrogen content in amino acids, sugar, protein and fat contents in more than 860 food items and phosphorus concentration in food)
- R scripts: (i) add_data_original_db_function.R ()
- output: 


The original files "Partial\_db\_original.xlsx', and "macronutrients details.xlsx" include the raw data from the original sources. A complete database of original data ("Merged\_db\_original.xlsx") is obtained with the scripts "Add\_data\_original\_db.R", and "Add\_data\_original\_db\_function.R".
