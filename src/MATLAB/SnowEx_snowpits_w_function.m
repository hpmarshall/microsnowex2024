%% Plots snow-pit stratigraphy from SnowEx sites
% Generates snow-pit plots and site details for multiple SnowEx sites.
% Data sourced via readSnowEx_snowpit.m from NSIDC with user-defined inputs.
% Requires Matlab's Mapping Toolbox.
%
% Created by Sydney Baratta (CRREL), July 2024

%% Define site numbers and date strings
base_path = 'C:\Users\sydne\Downloads\SnowEx\';  % Enter folder with data
site_list = {'2S7', '2S16', '9C16', '1S17', '2N13'}; % Example site numbers
date_str_list = {'20200208', '20200208', '20200205', '20200208', '20200206'}; % Example date strings

%% Plotting
% Set default font to Times New Roman
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');

% Define categories and corresponding numerical values
categories = {'F', '4F', '1F', 'P', 'K', 'I'}; % Categories
numerical_values = 1:length(categories); % Assign numerical values
markers = repmat({'o'}, 1, length(categories)); % Marker symbols for each category
colors = lines(length(categories)); % Color for each category

% Create a mapping between categories and numerical values using containers.Map
category_map = containers.Map(categories, numerical_values);

% Initialize cell arrays to store data and site details
all_data = cell(length(site_list), 1);
latitudes = zeros(length(site_list), 1);
longitudes = zeros(length(site_list), 1);

% Loop through each site
for i = 1:length(site_list)
    % Get site code and date string for the current iteration
    siteNum = site_list{i};
    date_str = date_str_list{i};

    % Call the readSnowExData function to retrieve data and site details
    [data, sitedetails] = readSnowEx_snowpit(base_path, siteNum, date_str);

    % Extract UTM coordinates and other details from sitedetails
    utmZone = sitedetails.Var2{5}; % Assuming Var2 is a cell array
    utmEasting = sitedetails.Var2{6};
    utmNorthing = sitedetails.Var2{7};
    slope = sitedetails.Var2{8}; 
    aspect = sitedetails.Var2{9}; 
    airTemp = sitedetails.Var2{10}; 
    totalDepth = sitedetails.Var2{11}; 
    surveyors = sitedetails.Var2{12}; 
    WISe_serialNo = sitedetails.Var2{13}; 
    weather = sitedetails.Var2{14}; 
    precip = sitedetails.Var2{15}; 
    sky = sitedetails.Var2{16}; 
    wind = sitedetails.Var2{17}; 
    groundCondition = sitedetails.Var2{18}; 
    groundRoughness = sitedetails.Var2{19}; 
    groundVegetation = sitedetails.Var2{20}; 
    vegetationHeight = sitedetails.Var2{21}; 
    treeCanopy = sitedetails.Var2{22}; 
    comments = sitedetails.Var2{23}; 
    
    % Convert UTM zone format from "12N" to "12 N" (necessary for utm2deg)
    utmZoneFormatted = [utmZone(1:2), ' ', utmZone(3)];

    % Convert UTM coordinates to lat/lon using utm2deg
    [lat, lon] = utm2deg(str2double(utmEasting), str2double(utmNorthing), utmZoneFormatted);

    % Stores the lat/lon for the current site
    latitudes(i) = lat;
    longitudes(i) = lon;

    % Create a new figure for each site
    fig = figure('Name', ['Data Overview for Site ', siteNum]);

    % Adjust figure position based on indiv. screen size
    fig_width = 700; % desired width (in pixels)
    fig_height = 700; % desired height (in pixels)
    screen_size = get(0, 'ScreenSize');
    fig_position = [screen_size(3)/2 - fig_width/2, screen_size(4)/2 - fig_height/2, fig_width, fig_height];
    set(fig, 'Position', fig_position);

    % ---------------------------
    % Site Details Table (top)
    subplot(3, 2, [1, 2]); % Site Details position

    % Adjust subplot parameters
    axis off; % Turn off axis

    % Prepare site details as text labels
    site_details = {
        {'Site Number:', siteNum};
        {'Date:', date_str};
        {'UTM Zone:', utmZoneFormatted};
        {'UTM Easting (m):', utmEasting};
        {'UTM Northing (m):', utmNorthing};
        {'Slope (deg):', slope};
        {'Aspect (deg):', aspect};
        {'Air Temperature (°C):', airTemp};
        {'Total Depth (cm):', totalDepth};
        {'Surveyors:', surveyors};
        {'WISe Serial No.:', WISe_serialNo};
        {'Weather:', weather};
        {'Precipitation:', precip};
        {'Sky:', sky};
        {'Wind:', wind};
        {'Ground Condition:', groundCondition};
        {'Ground Roughness:', groundRoughness};
        {'Ground Vegetation:', groundVegetation};
        {'Vegetation Height:', vegetationHeight};
        {'Tree Canopy:', treeCanopy};
        {'Comments:', comments};
    };

    % Calculate column positions for two columns
    num_details = length(site_details);
    num_columns = 2; % Number of columns
    column_height = ceil(num_details / num_columns);

    % Determine subplot positions
    subplot_width = 0.5; % Width of each subplot
    subplot_height = 1.2; % Height of each subplot
    subplot_left_margin = -0.05; % Left margin of subplot
    subplot_bottom_margin = -0.45; % Bottom margin of subplot

    % Display each line of site details in columns
    for k = 1:num_details
        col = mod(k - 1, num_columns) + 1; % Determine current column
        row = ceil(k / num_columns); % Determine current row

        % Calculate vertical position dynamically based on subplot position and column
        if col == 1
            x_position = subplot_left_margin;
            value_x_position = subplot_left_margin + 0.23;
        else
            x_position = subplot_left_margin + subplot_width + 0.1; % Adjust 0.1 for spacing between columns
            value_x_position = x_position + 0.23; % Adjust number (0.23) for spacing between label and value
        end

        y_position = 1 - (subplot_bottom_margin + row * (subplot_height / column_height));

        % Extract label and value from site_details
        label = site_details{k}{1};
        value = site_details{k}{2};

        % Display current site detail line with bold font for label
        text(x_position, y_position, label, ...
             'FontName', 'Times New Roman', 'FontSize', 8.5, 'FontWeight', 'bold', 'Units', 'normalized', ...
             'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');

        % Display value with regular font next to the label, prevent wrapping
        text(value_x_position, y_position, value, ...
             'FontName', 'Times New Roman', 'FontSize', 8.5, 'Units', 'normalized', ...
             'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'Interpreter', 'none', 'FontName', 'FixedWidth');

    end

    % ---------------------------
    % Snow-pit plot (left)
    ax3 = subplot(3, 2, [3, 5]);
    hold(ax3, 'on');
    agg_y_values = cell(1, length(categories));

    for j = 1:length(categories)
        category = categories{j};
        idx = find(data.strat.hardness == category_map(category));
        if ~isempty(idx)
            agg_y_values{j} = data.strat.height(idx);
        else
            agg_y_values{j} = []; % Assign empty array for categories with no data
        end
        scatter(ax3, ones(size(agg_y_values{j})) * j, agg_y_values{j}, 50, colors(j, :), markers{j}, 'filled');
    end

    hold(ax3, 'off');
    set(ax3, 'XTick', 1:length(categories), 'XTickLabel', categories, 'XDir', 'reverse');
    xlim(ax3, [0.5, length(categories) + 0.5]);

    % Filter out empty cells and make every snow-pit plot start at 0 cm (ground "height")
    valid_agg_y_values = agg_y_values(~cellfun(@isempty, agg_y_values)); % Filter out empty cells
    if ~isempty(valid_agg_y_values)
        max_y_value = max(cellfun(@max, valid_agg_y_values)); % Calculate maximum y-value
    else
        max_y_value = 0; % Handle case where all cells are empty
    end
    ylim(ax3, [0, max_y_value]); % Set y-axis limit to start at zero

    xlabel(ax3, 'Hand Hardness');
    ylabel(ax3, 'Height (cm)');
    legend(ax3, categories, 'Location', 'southwest');
    grid(ax3, 'on');

    % Create a new axes for the temperature vs. height data
    ax4 = axes('Position', ax3.Position, ...
               'XAxisLocation', 'top', ...
               'YAxisLocation', 'right', ...
               'Color', 'none');
    line(data.temp.temp, data.temp.height, 'Parent', ax4, 'LineWidth', 2, 'Color', [0.1, 0.1, 0.1]);

    ax4.XColor = 'k';
    ax4.YColor = 'k';
    xlabel(ax4, 'Temperature (°C)');
    ylabel(ax4, 'Height (cm)');
    ylim(ax4, [0, max(data.temp.height)]); % Set y-axis limit to start at zero

    % Synchronize y-limits of ax3 and ax4
    linkprop([ax3, ax4], 'YLim');

    % ---------------------------
    % Stratigraphy table (right)
    ax5 = subplot(3, 2, [4, 6]);
    max_length = max([length(data.dens.height), length(data.lwc.avgDens), length(data.lwc.LWCvolA), length(data.lwc.permA)]);
    dens_height = [data.dens.height; NaN(max_length - length(data.dens.height), 1)];
    lwc_avgDens = [data.lwc.avgDens; NaN(max_length - length(data.lwc.avgDens), 1)];
    lwc_LWCvolA = [data.lwc.LWCvolA; NaN(max_length - length(data.lwc.LWCvolA), 1)];
    lwc_permA = [data.lwc.permA; NaN(max_length - length(data.lwc.permA), 1)];

    % Define column names for the stratigraphy table
    column_names = {'Height (cm)', 'Avg Density (kg/m³)', 'LWC Volume (%)', 'Permeability'};

    hTable2 = uitable('Data', [dens_height, lwc_avgDens, lwc_LWCvolA, lwc_permA], ...
                      'ColumnName', column_names, 'RowName', {}, ...
                      'Units', 'Normalized', 'Position', [0.55, 0.1, 0.4, 0.55]);

    hTable2.FontName = 'Times New Roman';
    hTable2.FontSize = 10; % Adjust font size as needed
    set(gca, 'Visible', 'off');
    title(['Stratigraphy for Site ', siteNum, ' on ', date_str]);
    set(gcf, 'Color', [0.93, 0.91, 0.91]);
    
end

%% SnowEx Map of Site(s)
% Define the geographic limits for current SnowEx states
state_limits = struct(...
    'Colorado', struct('latlim', [36, 42], 'lonlim', [-109, -102]), ...
    'Idaho', struct('latlim', [42, 49], 'lonlim', [-117, -111]), ...
    'Alaska', struct('latlim', [54, 72], 'lonlim', [-170, -130]), ...
    'Utah', struct('latlim', [37, 42], 'lonlim', [-114, -109]), ...
    'Montana', struct('latlim', [44, 49], 'lonlim', [-116, -104]), ...
    'California', struct('latlim', [32, 42], 'lonlim', [-124, -114]), ...
    'NewMexico', struct('latlim', [31, 37], 'lonlim', [-109, -103]));

% Identify which state the sites are in
in_state = false;
state_name = '';

for state = fieldnames(state_limits)'
    state = state{1}; % Extract string from cell
    limits = state_limits.(state);
    
    % Check if any site falls within the state's limits
    if all(latitudes >= limits.latlim(1) & latitudes <= limits.latlim(2)) && ...
       all(longitudes >= limits.lonlim(1) & longitudes <= limits.lonlim(2))
        in_state = true;
        state_name = state;
        break;
    end
end

% Create main map and inset map in the same figure
figure('Name','Site Map');

% Main site map (zoomed-in view of site(s))
ax_main = geoaxes; % Create geographic axes for the main map
hold(ax_main, 'on');

% Plot site locations on main map
geoscatter(ax_main, latitudes, longitudes, 'r', 'filled');
geobasemap(ax_main, 'satellite');
title(ax_main, 'Site Map');

% Add site number labels with markers on the main map
for i = 1:length(site_list)
    % Marker points
    geoplot(ax_main, latitudes(i), longitudes(i), 'ro', 'MarkerSize', 2, 'MarkerFaceColor', 'r');
    % Customized labels with white border with offset from marker
    text(ax_main, latitudes(i) + 0.001, longitudes(i) + 0.001, site_list{i}, ...
         'FontSize', 10, 'Color', 'black', 'BackgroundColor', 'white', ...
         'EdgeColor', 'black', 'LineWidth', 1, 'Margin', 2);
end

% Compute lat/lon ranges based on site locations for inset map
buffer = 0.02; % Buffer around the sites for better visibility
min_lat = min(latitudes) - buffer;
max_lat = max(latitudes) + buffer;
min_lon = min(longitudes) - buffer;
max_lon = max(longitudes) + buffer;

% Calculates the zoomed-out limits for inset map
zoom_out_factor = 85; % Adjust as needed, this just works well for Grand Mesa

% Expand the boundaries based on zoom out factor
min_lat_inset = min_lat - zoom_out_factor * (max_lat - min_lat);
max_lat_inset = max_lat + zoom_out_factor * (max_lat - min_lat);
min_lon_inset = min_lon - zoom_out_factor * (max_lon - min_lon);
max_lon_inset = max_lon + zoom_out_factor * (max_lon - min_lon);

% Inset Map (Zoomed-out View)
inset_width = 0.2; % Width of the inset map relative to main map
inset_height = 0.2; % Height of the inset map relative to main map
inset_position = [0.18, 0.71, inset_width, inset_height]; % Position of the inset map (adjust as needed)

ax_inset = geoaxes('Position', inset_position, 'Parent', gcf); % Position the inset map
hold(ax_inset, 'on');

% Determine if the sites are within any state and adjust inset map accordingly
if in_state
    % Use specific state's basemap
    geobasemap(ax_inset, 'colorterrain'); % Example: 'colorterrain' for the state
    
    % Label the state name
    text_options = {'FontSize', 9, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
                    'Color', 'black', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top'};
    
    text(mean(limits.latlim), mean(limits.lonlim), upper(state_name), text_options{:});
end


% Set the geographic limits for the inset map
geolimits(ax_inset, [min_lat_inset, max_lat_inset], [min_lon_inset, max_lon_inset]);

% Draws a red box around the area of the main map on the inset map
main_map_bounds_lat = [min_lat, max_lat, max_lat, min_lat, min_lat];
main_map_bounds_lon = [min_lon, min_lon, max_lon, max_lon, min_lon];
geoplot(ax_inset, main_map_bounds_lat, main_map_bounds_lon, 'rs', 'LineWidth', 2); % Red box around the area of the main map

set(gcf, 'Color', [0.93, 0.91, 0.91]);
