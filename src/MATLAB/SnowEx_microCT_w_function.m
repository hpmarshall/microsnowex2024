%% Plots microCT morphometry from SnowEx sites
% Generates various microCT plots for multiple SnowEx sites.
% Data sourced via readSnowEx_microCT.m from NSIDC with user-defined inputs.
%
% Created by Sydney Baratta (CRREL), July 2024

base_path = 'C:\Users\sydne\Downloads\SnowEx\';
siteNums = {'2s7', '2s16', '9c16', '1s17', '2n13'};

data_microCT = readSnowEx_microCT(base_path, siteNums);

% Initialize a structure to store variables for each site
variables = struct;

% Loop through each site and assign variables
for i = 1:length(siteNums)
    site = siteNums{i};
    
    % Prepend 'variables_' to ensure valid field name
    variables_field = ['variables_', site];  % e.g., 'variables_2s7'
    
    % Assign variables to nested structure
    variables.(variables_field).avg_depth = data_microCT.(['site_', site]).x____________________________ (:, 2:end); % cm, a little weird due to .csv formatting
    variables.(variables_field).NumberofLayers = data_microCT.(['site_', site]).NumberOfLayers(:, 2:end); % #
    variables.(variables_field).LowerVerticalPosition = data_microCT.(['site_', site]).LowerVerticalPosition(:, 2:end); % mm
    variables.(variables_field).UpperVerticalPosition = data_microCT.(['site_', site]).UpperVerticalPosition(:, 2:end); % mm
    variables.(variables_field).PixelSize = data_microCT.(['site_', site]).PixelSize(:, 2:end); % um
    variables.(variables_field).LowerGreyThreshold = data_microCT.(['site_', site]).LowerGreyThreshold(:, 2:end); % no unit
    variables.(variables_field).UpperGreyThreshold = data_microCT.(['site_', site]).UpperGreyThreshold(:, 2:end); % no unit
    variables.(variables_field).TotalVOIVolume = data_microCT.(['site_', site]).TotalVOIVolume(:, 2:end); % mm³
    variables.(variables_field).ObjectVolume = data_microCT.(['site_', site]).ObjectVolume(:, 2:end); % mm³
    variables.(variables_field).PercentObjectVolume = data_microCT.(['site_', site]).PercentObjectVolume(:, 2:end); % %
    variables.(variables_field).TotalVOISurface = data_microCT.(['site_', site]).TotalVOISurface(:, 2:end); % mm²
    variables.(variables_field).ObjectSurface = data_microCT.(['site_', site]).ObjectSurface(:, 2:end); % mm²
    variables.(variables_field).IntersectionSurface = data_microCT.(['site_', site]).IntersectionSurface(:, 2:end); % mm²
    variables.(variables_field).ObjectSurface_VolumeRatio = data_microCT.(['site_', site]).ObjectSurface_VolumeRatio(:, 2:end); % 1/mm
    variables.(variables_field).ObjectSurfaceDensity = data_microCT.(['site_', site]).ObjectSurfaceDensity(:, 2:end); % 1/mm
    variables.(variables_field).SurfaceConvexityIndex = data_microCT.(['site_', site]).SurfaceConvexityIndex(:, 2:end); % 1/mm
    variables.(variables_field).Centroid_x = data_microCT.(['site_', site]).Centroid_x_(:, 2:end); % mm
    variables.(variables_field).Centroid_y = data_microCT.(['site_', site]).Centroid_y_(:, 2:end); % mm
    variables.(variables_field).Centroid_z = data_microCT.(['site_', site]).Centroid_z_(:, 2:end); % mm
    variables.(variables_field).MomentOfInertia_x = data_microCT.(['site_', site]).MomentOfInertia_x_(:, 2:end); % mm^5
    variables.(variables_field).MomentOfInertia_y = data_microCT.(['site_', site]).MomentOfInertia_y_(:, 2:end); % mm^5
    variables.(variables_field).MomentOfInertia_z = data_microCT.(['site_', site]).MomentOfInertia_z_(:, 2:end); % mm^5
    variables.(variables_field).PolarMomentOfInertia = data_microCT.(['site_', site]).PolarMomentOfInertia(:, 2:end); % mm^5
    variables.(variables_field).RadiusOfGyration_x = data_microCT.(['site_', site]).RadiusOfGyration_x_(:, 2:end); % mm
    variables.(variables_field).RadiusOfGyration_y = data_microCT.(['site_', site]).RadiusOfGyration_y_(:, 2:end); % mm
    variables.(variables_field).RadiusOfGyration_z = data_microCT.(['site_', site]).RadiusOfGyration_z_(:, 2:end); % mm
    variables.(variables_field).PolarRadiusOfGyration = data_microCT.(['site_', site]).PolarRadiusOfGyration(:, 2:end); % mm
    variables.(variables_field).ProductOfInertia_xy = data_microCT.(['site_', site]).ProductOfInertia_xy_(:, 2:end); % mm^5
    variables.(variables_field).ProductOfInertia_xz = data_microCT.(['site_', site]).ProductOfInertia_xz_(:, 2:end); % mm^5
    variables.(variables_field).ProductOfInertia_yz = data_microCT.(['site_', site]).ProductOfInertia_yz_(:, 2:end); % mm^5
    variables.(variables_field).TotalOrientation_theta = data_microCT.(['site_', site]).TotalOrientation_theta_(:, 2:end); % °
    variables.(variables_field).TotalOrientation_phi = data_microCT.(['site_', site]).TotalOrientation_phi_(:, 2:end); % °
    variables.(variables_field).StructureModelIndex = data_microCT.(['site_', site]).StructureModelIndex(:, 2:end); % no unit
    variables.(variables_field).StructureThickness = data_microCT.(['site_', site]).StructureThickness(:, 2:end); % mm
    variables.(variables_field).StructureLinearDensity = data_microCT.(['site_', site]).StructureLinearDensity(:, 2:end); % 1/mm
    variables.(variables_field).StructureSeparation = data_microCT.(['site_', site]).StructureSeparation(:, 2:end); % mm
    variables.(variables_field).FractalDimension = data_microCT.(['site_', site]).FractalDimension(:, 2:end); % no unit
    variables.(variables_field).NumberOfObjects = data_microCT.(['site_', site]).NumberOfObjects(:, 2:end); % no unit
    variables.(variables_field).NumberOfClosedPores = data_microCT.(['site_', site]).NumberOfClosedPores(:, 2:end); % no unit
    variables.(variables_field).VolumeOfClosedPores = data_microCT.(['site_', site]).VolumeOfClosedPores(:, 2:end); % mm³
    variables.(variables_field).SurfaceOfClosedPores = data_microCT.(['site_', site]).SurfaceOfClosedPores(:, 2:end); % mm²
    variables.(variables_field).ClosedPorosity_percent = data_microCT.(['site_', site]).ClosedPorosity_percent_(:, 2:end); % %
    variables.(variables_field).VolumeOfOpenPoreSpace = data_microCT.(['site_', site]).VolumeOfOpenPoreSpace(:, 2:end); % mm³
    variables.(variables_field).OpenPorosity_percent = data_microCT.(['site_', site]).OpenPorosity_percent_(:, 2:end); % %
    variables.(variables_field).TotalVolumeOfPoreSpace = data_microCT.(['site_', site]).TotalVolumeOfPoreSpace(:, 2:end); % mm³
    variables.(variables_field).TotalPorosity_percent = data_microCT.(['site_', site]).TotalPorosity_percent_(:, 2:end); % %
    variables.(variables_field).EulerNumber = data_microCT.(['site_', site]).EulerNumber(:, 2:end); % no unit
    variables.(variables_field).Connectivity = data_microCT.(['site_', site]).Connectivity(:, 2:end); % no unit
    variables.(variables_field).ConnectivityDensity = data_microCT.(['site_', site]).ConnectivityDensity(:, 2:end); % 1/mm³
    variables.(variables_field).DegreeOfAnisotropy = data_microCT.(['site_', site]).DegreeOfAnisotropy(:, 2:end);  % no unit
    variables.(variables_field).Eigenvalue1 = data_microCT.(['site_', site]).Eigenvalue1(:, 2:end); % no unit
    variables.(variables_field).Eigenvalue2 = data_microCT.(['site_', site]).Eigenvalue2(:, 2:end); % no unit
    variables.(variables_field).Eigenvalue3 = data_microCT.(['site_', site]).Eigenvalue3(:, 2:end); % no unit
    variables.(variables_field).SSA = data_microCT.(['site_', site]).SSA(:, 2:end); % m²/kg
end

%% Plotting
% Set default font to Times New Roman
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');

% Screen size and position calculations
screenSize = get(0, 'ScreenSize');  % Get screen size
screenWidth = screenSize(3);        % Width of the screen in pixels
screenHeight = screenSize(4);       % Height of the screen in pixels

% Adjust figure position based on indiv. screen size
fig_width = 400;    % desired width (in pixels)
fig_height = 700;   % desired height (in pixels)
fig_left = (screenWidth - fig_width) / 2;   % left position of the figure
fig_bottom = (screenHeight - fig_height) / 2; % bottom position of the figure

% Loop through each site and create a figure for each
for i = 1:length(siteNums)
    site = siteNums{i};
    
    fig = figure('Name', ['Site ', site], ...
                 'Position', [fig_left, fig_bottom, fig_width, fig_height]);
    
    % Plot SSA against height (labeled "avg depth", but is top height in cm)
    plot(variables.(['variables_', site]).SSA, variables.(['variables_', site]).avg_depth, ...
         'LineWidth', 2, 'Color', [0.53, 0.81, 0.92]);  % Sky blue color

    xlabel('SSA (m²/kg)', 'FontSize', 12);
    ylabel('Height (cm)', 'FontSize', 12);
    title(['Site ', site], 'FontSize', 12);
    grid on;
end

