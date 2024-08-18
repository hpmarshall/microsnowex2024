import os
import pandas as pd

def readSnowEx_microCT(base_path, siteNums):
    """
    Reads SnowEx MicroCT data files from the specified base path for given site numbers.
    
    Parameters:
    - base_path (str): The base directory where SnowPits data files are located.
    - siteNums (list): List of site number identifiers (e.g., ['2S7', 'N13']).
    
    Returns:
    - data_microCT (dict): A dictionary containing structured data with morphometry variables for each site.
    """
    # Initialize the dictionary to store data
    data_microCT = {}

    # Loop through each site number
    for site in siteNums:
        # Create a valid field name by prepending 'site_' to the site number
        site_fieldname = f"site_{site}"

        # Construct the full path to the Excel file
        filename = os.path.join(base_path, f"SNEX20_GM_CTSM_{site}_Analysis.xlsx")
        
        # Read the Excel file into a pandas DataFrame
        data_df = pd.read_excel(filename, engine='openpyxl')

        # Find the row index where variable names start
        variable_names_row = data_df[data_df.columns[0]].tolist().index('MORPHOMETRY RESULTS')
        
        # Extract 'avg depth' values from the appropriate row (which is the row above the column headers)
        avg_depth_row = variable_names_row - 1
        avg_depth = data_df.iloc[avg_depth_row, 1:].values
        
        # Remove rows above 'avg depth' row and the 'MORPHOMETRY RESULTS' row
        data_df = data_df.iloc[(variable_names_row + 1):, :]

        # Get the variable names and corresponding data
        variable_names = data_df.iloc[:, 0].values
        variable_data = data_df.iloc[:, 1:].to_numpy()

        # Initialize a dictionary for the current site
        site_data = {
            'avg_depth': avg_depth
        }
        
        # Store each variable's data into the dictionary
        for i, variable_name in enumerate(variable_names):
            variable_name = str(variable_name) # ensure this is a string
            variable_name = variable_name.replace(' ', '_')  # Ensure valid dictionary key
            site_data[variable_name] = variable_data[i, :]
        
        # Assign the site's data to the main dictionary
        data_microCT[site_fieldname] = site_data

    return data_microCT

# Example usage:
# base_path = '/path/to/your/data/'
# siteNums = ['2S7', 'N13']
# data = readSnowEx_microCT(base_path, siteNums)
