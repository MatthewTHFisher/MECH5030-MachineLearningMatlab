function raw_data_table = LoadTrialData(folder_location, motion_folder_array)
%LOADDATARECORDINGS Summary of this function goes here
%   Detailed explanation goes here
    arm_folders = ["Left Arm","Right Arm"];

    %% Initialise a table with all recorded data
    raw_data_table = {};


    for arm = arm_folders
        if exist(string(folder_location)+"/"+string(arm), 'dir')

            %% Initialise a table to hold arm data
            arm_data_table = {};

            for motion = motion_folder_array

                if exist(string(folder_location)+"/"+string(arm)+"/"+string(motion), 'dir')

                    motion_data_array = {};

                    file_names = extractfield(dir(string(folder_location)+"/"+string(arm)+"/"+string(motion)+"/*.mat"),'name');

                    for file_name = file_names
                        motion_data_array = vertcat(motion_data_array,struct2cell(load(string(folder_location)+"/"+string(arm)+"/"+string(motion)+"/"+string(file_name))));
                    end

                    motion_data_array = cell2table(motion_data_array);
                    motion_data_array.Properties.VariableNames = "Trials";

                    arm_data_table{1,end+1} = motion_data_array;

                else
                    %disp("No data for "+string(arm)+", "+string(motion));
                    arm_data_table{1,end+1} = nan;
                end
            end

            arm_data_table = cell2table(arm_data_table);
            arm_data_table.Properties.VariableNames = motion_folder_array;

            raw_data_table{1, end+1} = arm_data_table;

        else
            %disp("No data for "+string(arm));
            raw_data_table{1, end+1} = nan;
        end
    end

    raw_data_table = cell2table(raw_data_table);
    raw_data_table.Properties.VariableNames = arm_folders;
end
