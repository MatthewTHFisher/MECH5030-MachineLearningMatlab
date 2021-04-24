function table_of_tables = AddTimeToTrialData(table_of_tables)
%ADDTIMETOTABLEOFTABLES Summary of this function goes here
%   Detailed explanation goes here
    for arm = 1:width(table_of_tables)
        arm_data = table_of_tables{1,arm};

        if isa(arm_data, 'table') %% Check to make sure arm data is a table
            for motion = 1:width(arm_data)
                if isa(arm_data{1,motion}, 'table') || isa(arm_data{1,motion},'cell') %% Check to make sure motion data isn't NaN
                    motion_data = arm_data{1,motion}{1,1};

                    num_of_trials = height(motion_data);

                    for trial = 1:num_of_trials
                        if num_of_trials > 1
                            trial_data = motion_data{trial,1}{1,1};
                        else
                            trial_data = motion_data{trial,1};
                        end

                        trial_data = AddTimeToIMUData(trial_data);

                        if num_of_trials > 1
                            table_of_tables{1,arm}{1,motion}{1,1}{trial,1}{1,1} = trial_data;
                        else
                            table_of_tables{1,arm}{1,motion}{1,1}{trial,1} = trial_data;
                        end
                    end
                end
            end
        end
    end
end
