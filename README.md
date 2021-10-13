# Nuclei_Find-Measure_Stardist
This macro is useful for finding nuclei in tissue sample images using Stardist &amp; measuring their Green/Red Intensity

This macro is written in the ImageJ Macro Language.

## Running the script
The first screen to appear is the main splash screen displaying information about the script and its author.
The second dialog box warns the user to note what the file extension is and that the next screen is the directory location window.
Next, the user can select the working directory location.

The following window allows the user to set parameters for this script it includes the expected file extension.

The script first takes channel 3 and identifies cellular membranes and uses this metric to find the number of cells.

The total cellular area is determined by summing each found cells' area.

Next, each cell is indivually selected and the number of lipid droplets within this ROI is counted and measured using the analyse particles tool.

Results information is reported out into the spreadsheet and relevant windows and masks are saved before being closed.

## Output Data
An output spreadsheet is created with the following format:
| File Name 	| Image Number 	| Nuclei Number 	| Green Intensity 	| Red Intensity 	|
|-----------	|-------------	|-----------	|----------------------	|--------------------	|
|           	|             	|           	|                      	|                    	|

While the label image and detected ROIs are also saved within the output directory.
