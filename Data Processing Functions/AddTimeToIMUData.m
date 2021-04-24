function trial_data = AddTimeToIMUData(trial_data)
%ADDTIMETOTABLEOFTABLES Summary of this function goes here
%   Detailed explanation goes here
time_table = array2table(milliseconds(trial_data.timestamp - trial_data.timestamp(1)));
time_table.Properties.VariableNames = "time";
time_table.Properties.VariableDescriptions = "Time since motion start";
time_table.Properties.VariableUnits = "ms";

trial_data = horzcat(trial_data, time_table);
trial_data = movevars(trial_data,'time','After','timestamp');
end
