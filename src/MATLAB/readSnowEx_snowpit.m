function [data, sitedetails] = readSnowEx_snowpit(base_path, siteNum, date_str)

% readSnowEx_snowpit reads SnowEx data downloaded directly from NSIDC and saved to a local file.
% Automates the extraction and structuring of data to make it easier to work with.

% DATA SOURCES
    % MAIN DATA PAGE: https://nsidc.org/data/snowex/data
    % Snow-pit data from: https://nsidc.org/data/snex20_gm_sp/versions/1
    % Laser SSA (IceCube): https://nsidc.org/data/snex20_ssa/versions/1
    % SMP data from: https://nsidc.org/data/snex20_smp/versions/1
    % MicroCT  data from: https://nsidc.org/data/snex20_gm_ctsm/versions/1

%   [DATA, SITEDETAILS] = READSNOWEX_SNOWPIT(BASE_PATH, SITENUM, DATE_STR) reads
%   SnowPits data files from the SnowEx program, extracts data (e.g., 
%   temperature, density, LWC, stratigraphy) and site details, and returns 
%   them in a structured format.
%
%   Inputs:
%   BASE_PATH   - Base path/local file where SnowPits data files are located.
%   SITENUM     - Site number identifier (e.g., '2S7', 'N13', etc).
%   DATE_STR    - Date string identifier (e.g., '20200215').
%
%   Outputs:
%   DATA        - Structured data containing parsed temperature, density, LWC, 
%                 and stratigraphy data from SnowPits.
%   SITEDETAILS - Structured site details (e.g., atm. conditions at time of sample collection)
%
%   Example:
%   base_path = 'C:\path\to\your\data\';
%   siteNum = '2S7';
%   date_str = '20200208';
%   [data, sitedetails] = readSnowEx_snowpit(base_path, siteNum, date_str);

    % Construct file paths
    site_prefix = sprintf('SnowEx20_SnowPits_GMIOP_%s_%s', date_str, siteNum);

    % Read site details file
    siteDetails_file = fullfile(base_path, [site_prefix '_siteDetails_v01.csv']);
    siteDetails = readtable(siteDetails_file, 'Delimiter', ',', 'ReadVariableNames', false);
    siteDetails.Properties.VariableNames = strrep(siteDetails.Properties.VariableNames, '# ', '');

    % Initialize data structure
    data = struct();

    % Define data types and file suffixes
    data_types = {'temperature', 'density', 'LWC', 'stratigraphy'};
    suffixes = {'temperature_v01.csv', 'density_v01.csv', 'LWC_v01.csv', 'stratigraphy_v01.csv'};

    % Loop through each data type
    for i = 1:length(data_types)
        % Read data file
        data_file = fullfile(base_path, [site_prefix '_' suffixes{i}]);
        if exist(data_file, 'file')
            switch data_types{i}
                case 'temperature'
                    temp = readSnowExDataFile(data_file);
                    data.temp.easting = temp(1,2);
                    data.temp.northing = temp(2,2);
                    data.temp.height = temp(4:end,1); % top height (cm)
                    data.temp.temp = temp(4:end,2); % deg C
                case 'density'
                    dens = readSnowExDataFile(data_file);
                    data.dens.height = dens(4:end,1); % top height (cm)
                    data.dens.bottom = dens(4:end,2); % bottom height (cm)
                    data.dens.densA = dens(4:end,3); % kg/m³
                    data.dens.densB = dens(4:end,4); % kg/m³
                    if size(dens, 2) >= 5
                        data.dens.densC = dens(4:end,5); % kg/m³ (if present)
                    end
                case 'LWC'
                    lwc = readSnowExDataFile(data_file);
                    data.lwc.height = lwc(4:end,1); % top height (cm)
                    data.lwc.bottom = lwc(4:end,2); % bottom height (cm)
                    data.lwc.avgDens = lwc(4:end,3); % kg/m³
                    data.lwc.permA = lwc(4:end,4);
                    data.lwc.permB = lwc(4:end,5);
                    data.lwc.LWCvolA = lwc(4:end,6); % %
                    data.lwc.LWCvolB = lwc(4:end,7); % %
                case 'stratigraphy'
                    strat = readtable(data_file, 'Delimiter', ',', 'ReadVariableNames', false);
                    strat.Properties.VariableNames = {'Height', 'Bottom', 'GrainSize', 'GrainType', 'Hardness', 'Wetness', 'Comments'};
                    
                    categories = {'F', '4F', '1F', 'P', 'K', 'I'};
                    numerical_values = [1, 2, 3, 4, 5, 6]; % Assign numerical values

                    % Create a mapping between categories and numerical values using containers.Map
                    category_map = containers.Map(categories, numerical_values);

                    data.strat.height = strat.Height;
                    data.strat.bottom = strat.Bottom;
                    data.strat.grain_size = string(strat.GrainSize);
                    data.strat.grain_type = string(strat.GrainType);
                    data.strat.hardness = zeros(size(strat.Hardness)); % Preallocate numerical hardness data array

                    for j = 1:length(strat.Hardness)
                        category = strat.Hardness{j};
                        if isKey(category_map, category)
                            data.strat.hardness(j) = category_map(category);
                        else
                            error(['Category ' category ' is not defined in category_map.']);
                        end
                    end
            end
        else
            warning(['File ' data_file ' does not exist. Skipping...']);
        end
    end
    
    % Populate site details into data.site
    data.site = table2struct(siteDetails, 'ToScalar', true);
    
    % Extract sitedetails as a separate structure if needed
    sitedetails = data.site;
end

function data = readSnowExDataFile(file_path)
    [data, ~, ~] = xlsread(file_path);
end
