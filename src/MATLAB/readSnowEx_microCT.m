function data_microCT = readSnowEx_microCT(base_path, siteNums)

% readSnowEx_microCT reads SnowEx data downloaded directly from NSIDC and saved to a local file.
% Automates the extraction and structuring of data to make it easier to work with.

% DATA SOURCES
    % MAIN DATA PAGE: https://nsidc.org/data/snowex/data
    % Snow-pit data from: https://nsidc.org/data/snex20_gm_sp/versions/1
    % Laser SSA (IceCube): https://nsidc.org/data/snex20_ssa/versions/1
    % SMP data from: https://nsidc.org/data/snex20_smp/versions/1
    % MicroCT  data from: https://nsidc.org/data/snex20_gm_ctsm/versions/1

%   [DATA, SITEDETAILS] = READSNOWEX_MICROCT(BASE_PATH, SITENUM) reads
%   SnowPits data files from the SnowEx experiment, extracts morphometry
%   data and returns them in a structured format.
%
%   Inputs:
%   BASE_PATH   - Base path/local file where SnowPits data files are located.
%   SITENUM     - Site number identifier (e.g., '2S7', 'N13', etc).
%
%   Outputs:
%   DATA        - Structured data containing various morphometry variables per site
%
%   Example:
%   base_path = 'C:\path\to\your\data\';
%   siteNum = '2S7';
%   [data] = readSnowEx_microCT(base_path, siteNum);

    % Initialize the structure to store data
    data_microCT = struct();

    % Loop through each site number
    for i = 1:length(siteNums)
        site = siteNums{i};
        % Prepend 'site_' to make the field name valid
        site_fieldname = matlab.lang.makeValidName(['site_' site]);  % Ensure valid MATLAB variable name
        
        % Construct the full path to the CSV file
        filename = fullfile(base_path, sprintf('SNEX20_GM_CTSM_%s_Analysis.csv', site));
        
        % Read the CSV file into a table with correct data types
        opts = detectImportOptions(filename);
        opts.VariableTypes(2:end) = {'double'};  % Force all columns except the first one to be treated as double
        data_table = readtable(filename, opts);
        
        % Find the row index where variable names start
        variable_names_row = find(strcmp(data_table.Properties.VariableNames, 'MORPHOMETRY RESULTS'));
        
        % Extract 'avg depth' values from the appropriate row (which is the row above the column headers)
        avg_depth_row = variable_names_row - 1;
        avg_depth = data_table{avg_depth_row, 2:end};
        
        % Remove rows above 'avg depth' row and the 'MORPHOMETRY RESULTS' row
        data_table(1:variable_names_row, :) = [];
        
        % Convert the remaining rows to a table with variables as row headers
        variable_names = data_table{:, 1};
        variable_data = table2array(data_table(:, 2:end));
        
        % Initialize structure fields for the current site
        data_microCT.(site_fieldname) = struct();
        
        % Store avg depth directly under the site field
        data_microCT.(site_fieldname).avg_depth = avg_depth;
        
        % Loop through each variable and store data
        for j = 1:length(variable_names)
            variable_name = matlab.lang.makeValidName(variable_names{j});  % Ensure valid field name
            
            % Store variable data into the structure
            data_microCT.(site_fieldname).(variable_name) = variable_data(j, :);
        end
        
        % Clear temporary variables
        clear data_table avg_depth;
    end
end
