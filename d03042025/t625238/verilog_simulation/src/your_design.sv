module SensorDataManager;
    int sensor_data[]; // Dynamic array for sensor data
    int num_sensors;
    
    initial begin
        num_sensors = 5; // Initial number of sensors
        sensor_data = new[num_sensors]; // Allocate memory
        
        // Initialize sensor data
        foreach (sensor_data[i]) begin
            sensor_data[i] = i * 10;
        end
        
        // Display initial sensor data
        $display("Initial Sensor Data:");
        foreach (sensor_data[i]) begin
            $display("Sensor[%0d] = %0d", i, sensor_data[i]);
        end
        
        // Resize dynamic array when number of sensors increases
        num_sensors = 8;
        sensor_data = new[num_sensors](sensor_data); // Preserve existing values
        
        // Initialize new sensor values
        for (int i = 5; i < num_sensors; i++) begin
            sensor_data[i] = i * 10;
        end
        
        // Display updated sensor data
        $display("Updated Sensor Data:");
        foreach (sensor_data[i]) begin
            $display("Sensor[%0d] = %0d", i, sensor_data[i]);
        end
        
        // Resize dynamic array when number of sensors decreases
        num_sensors = 3;
        sensor_data = new[num_sensors](sensor_data); // Truncate array
        
        // Display truncated sensor data
        $display("Truncated Sensor Data:");
        foreach (sensor_data[i]) begin
            $display("Sensor[%0d] = %0d", i, sensor_data[i]);
        end
        
        // Dump data for GTKWave visualization
        $dumpfile("output/sensor_data.vcd");
        $dumpvars(0, SensorDataManager);
    end
endmodule
