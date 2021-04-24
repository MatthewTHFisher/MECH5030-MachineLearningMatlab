function ArduinoStr2Table(src,~)
%ARDUINOSTR2TABLE Function attached to IMU String characteristic to convert
%string into a useable table.
%   Each time round a new row will be added to the table with the data of
%   accel, gyro and mag. Global declarations allow for accel, gyro or mag
%   to be switched off and still read into a useable table.
    global debug

    [data,~] = read(src, 'oldest');  % Can be either 'newest' or 'oldest'
    
    formatted_data = split(char(data),",");
    clear data
    
    global accel_enabled gyro_enabled mag_enabled
    
    timestamp = str2double(formatted_data{1});
    
    i = 2;
    
    %  IMU 1  //  Sternum
    if accel_enabled
        accelX_1 = str2double(formatted_data{i});
        accelY_1 = str2double(formatted_data{i+1});
        accelZ_1 = str2double(formatted_data{i+2});
        i=i+3;
    end
    
    if gyro_enabled
        gyroX_1 = str2double(formatted_data{i});
        gyroY_1 = str2double(formatted_data{i+1});
        gyroZ_1 = str2double(formatted_data{i+2});
        i=i+3;
    end
    
    if mag_enabled
        magX_1 = str2double(formatted_data{i});
        magY_1 = str2double(formatted_data{i+1});
        magZ_1 = str2double(formatted_data{i+2});
        i=i+3;
    end
    
    %  IMU 2  //  Upper Arm
    if accel_enabled
        accelX_2 = str2double(formatted_data{i});
        accelY_2 = str2double(formatted_data{i+1});
        accelZ_2 = str2double(formatted_data{i+2});
        i=i+3;
    end
    
    if gyro_enabled
        gyroX_2 = str2double(formatted_data{i});
        gyroY_2 = str2double(formatted_data{i+1});
        gyroZ_2 = str2double(formatted_data{i+2});
        i=i+3;
    end
    
    if mag_enabled
        magX_2 = str2double(formatted_data{i});
        magY_2 = str2double(formatted_data{i+1});
        magZ_2 = str2double(formatted_data{i+2});
        i=i+3;
    end
    
    %  IMU 3  //  Lower Arm
    if accel_enabled
        accelX_3 = str2double(formatted_data{i});
        accelY_3 = str2double(formatted_data{i+1});
        accelZ_3 = str2double(formatted_data{i+2});
        i=i+3;
    end
    
    if gyro_enabled
        gyroX_3 = str2double(formatted_data{i});
        gyroY_3 = str2double(formatted_data{i+1});
        gyroZ_3 = str2double(formatted_data{i+2});
        i=i+3;
    end
    
    if mag_enabled
        magX_3 = str2double(formatted_data{i});
        magY_3 = str2double(formatted_data{i+1});
        magZ_3 = str2double(formatted_data{i+2});
        i=i+3;
    end
    
    clear formatted_data i
    
    % Converting the data into a table
    if accel_enabled && gyro_enabled && mag_enabled
        T = table(timestamp, accelX_1, accelY_1, accelZ_1, gyroX_1, gyroY_1, gyroZ_1, magX_1, magY_1, magZ_1, accelX_2, accelY_2, accelZ_2, gyroX_2, gyroY_2, gyroZ_2, magX_2, magY_2, magZ_2 ,accelX_3, accelY_3, accelZ_3, gyroX_3, gyroY_3, gyroZ_3, magX_3, magY_3, magZ_3);
    elseif accel_enabled && gyro_enabled && ~mag_enabled
        T = table(timestamp, accelX_1, accelY_1, accelZ_1, gyroX_1, gyroY_1, gyroZ_1, accelX_2, accelY_2, accelZ_2, gyroX_2, gyroY_2, gyroZ_2, accelX_3, accelY_3, accelZ_3, gyroX_3, gyroY_3, gyroZ_3); 
    elseif accel_enabled && ~gyro_enabled && mag_enabled
        T = table(timestamp, accelX_1, accelY_1, accelZ_1, magX_1, magY_1, magZ_1, accelX_2, accelY_2, accelZ_2, magX_2, magY_2, magZ_2 ,accelX_3, accelY_3, accelZ_3, magX_3, magY_3, magZ_3);
    elseif ~accel_enabled && gyro_enabled && mag_enabled
        T = table(timestamp, gyroX_1, gyroY_1, gyroZ_1, magX_1, magY_1, magZ_1, gyroX_2, gyroY_2, gyroZ_2, magX_2, magY_2, magZ_2, gyroX_3, gyroY_3, gyroZ_3, magX_3, magY_3, magZ_3);
    elseif accel_enabled && ~gyro_enabled && ~mag_enabled
        T = table(timestamp, accelX_1, accelY_1, accelZ_1, accelX_2, accelY_2, accelZ_2,accelX_3, accelY_3, accelZ_3); 
    elseif ~accel_enabled && gyro_enabled && ~mag_enabled
        T = table(timestamp, gyroX_1, gyroY_1, gyroZ_1, gyroX_2, gyroY_2, gyroZ_2, gyroX_3, gyroY_3, gyroZ_3); 
    elseif ~accel_enabled && ~gyro_enabled && mag_enabled
        T = table(timestamp, magX_1, magY_1, magZ_1, magX_2, magY_2, magZ_2, magX_3, magY_3, magZ_3);
    else
        T = table(timestamp);
    end
    
    %Concating the most recent row to the end of a global variable
    %'data_table'
    global data_table
    data_table = [data_table; T];
    
    if debug == true
        disp(T);
    end
    
    % Adding variable units to the table (Performed only once)
    if isempty(data_table.Properties.VariableUnits)
        if accel_enabled && gyro_enabled && mag_enabled   %% All Enabled
            data_table.Properties.VariableUnits = {'ms','m/s^2','m/s^2','m/s^2','deg/s','deg/s','deg/s','uT','uT','uT','m/s^2','m/s^2','m/s^2','deg/s','deg/s','deg/s','uT','uT','uT','m/s^2','m/s^2','m/s^2','deg/s','deg/s','deg/s','uT','uT','uT'};
        elseif accel_enabled && gyro_enabled && ~mag_enabled   %% Mag Disabled
            data_table.Properties.VariableUnits = {'ms','m/s^2','m/s^2','m/s^2','deg/s','deg/s','deg/s','m/s^2','m/s^2','m/s^2','deg/s','deg/s','deg/s','m/s^2','m/s^2','m/s^2','deg/s','deg/s','deg/s'};
        elseif accel_enabled && ~gyro_enabled && mag_enabled   %% Gyro Disabled
            data_table.Properties.VariableUnits = {'ms','m/s^2','m/s^2','m/s^2','uT','uT','uT','m/s^2','m/s^2','m/s^2','uT','uT','uT','m/s^2','m/s^2','m/s^2','uT','uT','uT'};
        elseif ~accel_enabled && gyro_enabled && mag_enabled   %% Accel Disabled
            data_table.Properties.VariableUnits = {'ms','deg/s','deg/s','deg/s','uT','uT','uT','deg/s','deg/s','deg/s','uT','uT','uT','deg/s','deg/s','deg/s','uT','uT','uT'};
        elseif accel_enabled && ~gyro_enabled && ~mag_enabled   %% Only Accel
            data_table.Properties.VariableUnits = {'ms','m/s^2','m/s^2','m/s^2','m/s^2','m/s^2','m/s^2','m/s^2','m/s^2','m/s^2'};
        elseif ~accel_enabled && gyro_enabled && ~mag_enabled   %% Only Gyro
            data_table.Properties.VariableUnits = {'ms','deg/s','deg/s','deg/s','deg/s','deg/s','deg/s','deg/s','deg/s','deg/s'};
        elseif ~accel_enabled && ~gyro_enabled && mag_enabled   %% Only Mag
            data_table.Properties.VariableUnits = {'ms','uT','uT','uT','uT','uT','uT','uT','uT','uT'};
        else   %% No sensors enabled
            data_table.Properties.VariableUnits = {'ms'};
        end
    end
    
    % Adding variable descriptions to the table (Performed only once)
    if isempty(data_table.Properties.VariableDescriptions)
        if accel_enabled && gyro_enabled && mag_enabled   %% All enabled
            data_table.Properties.VariableDescriptions = {'Time since device on','Sternum Accel X','Sternum Accel Y','Sternum Accel Z','Sternum Gyro X','Sternum Gyro Y','Sternum Gyro Z','Sternum Mag X','Sternum Mag Y','Sternum Mag Z','Upper Arm Accel X','Upper Arm Accel Y','Upper Arm Accel Z','Upper Arm Gyro X','Upper Arm Gyro Y','Upper Arm Gyro Z','Upper Arm Mag X','Upper Arm Mag Y','Upper Arm Mag Z','Lower Arm Accel X','Lower Arm Accel Y','Lower Arm Accel Z','Lower Arm Gyro X','Lower Arm Gyro Y','Lower Arm Gyro Z','Lower Arm Mag X','Lower Arm Mag Y','Lower Arm Mag Z'};
        elseif accel_enabled && gyro_enabled && ~mag_enabled   %% Mag Disabled
            data_table.Properties.VariableDescriptions = {'Time since device on','Sternum Accel X','Sternum Accel Y','Sternum Accel Z','Sternum Gyro X','Sternum Gyro Y','Sternum Gyro Z','Upper Arm Accel X','Upper Arm Accel Y','Upper Arm Accel Z','Upper Arm Gyro X','Upper Arm Gyro Y','Upper Arm Gyro Z','Lower Arm Accel X','Lower Arm Accel Y','Lower Arm Accel Z','Lower Arm Gyro X','Lower Arm Gyro Y','Lower Arm Gyro Z'};
        elseif accel_enabled && ~gyro_enabled && mag_enabled   %% Gryo Disabled
            data_table.Properties.VariableDescriptions = {'Time since device on','Sternum Accel X','Sternum Accel Y','Sternum Accel Z','Sternum Mag X','Sternum Mag Y','Sternum Mag Z','Upper Arm Accel X','Upper Arm Accel Y','Upper Arm Accel Z','Upper Arm Mag X','Upper Arm Mag Y','Upper Arm Mag Z','Lower Arm Accel X','Lower Arm Accel Y','Lower Arm Accel Z','Lower Arm Mag X','Lower Arm Mag Y','Lower Arm Mag Z'};
        elseif ~accel_enabled && gyro_enabled && mag_enabled   %% Accel Disabled
            data_table.Properties.VariableDescriptions = {'Time since device on','Sternum Gyro X','Sternum Gyro Y','Sternum Gyro Z','Sternum Mag X','Sternum Mag Y','Sternum Mag Z','Upper Arm Gyro X','Upper Arm Gyro Y','Upper Arm Gyro Z','Upper Arm Mag X','Upper Arm Mag Y','Upper Arm Mag Z','Lower Arm Gyro X','Lower Arm Gyro Y','Lower Arm Gyro Z','Lower Arm Mag X','Lower Arm Mag Y','Lower Arm Mag Z'};
        elseif accel_enabled && ~gyro_enabled && ~mag_enabled   %% Only Accel 
            data_table.Properties.VariableDescriptions = {'Time since device on','Sternum Accel X','Sternum Accel Y','Sternum Accel Z','Upper Arm Accel X','Upper Arm Accel Y','Upper Arm Accel Z','Lower Arm Accel X','Lower Arm Accel Y','Lower Arm Accel Z'};
        elseif ~accel_enabled && gyro_enabled && ~mag_enabled   %% Only Gyro
            data_table.Properties.VariableDescriptions = {'Time since device on','Sternum Gyro X','Sternum Gyro Y','Sternum Gyro Z','Upper Arm Gyro X','Upper Arm Gyro Y','Upper Arm Gyro Z','Lower Arm Gyro X','Lower Arm Gyro Y','Lower Arm Gyro Z'};
        elseif ~accel_enabled && ~gyro_enabled && mag_enabled   %% Only Mag
            data_table.Properties.VariableDescriptions = {'Time since device on','Sternum Mag X','Sternum Mag Y','Sternum Mag Z','Upper Arm Mag X','Upper Arm Mag Y','Upper Arm Mag Z','Lower Arm Mag X','Lower Arm Mag Y','Lower Arm Mag Z'};
        else   %% No sensors enabled
            data_table.Properties.VariableDescriptions = {'Time since device on'};
        end
    end

    
end

