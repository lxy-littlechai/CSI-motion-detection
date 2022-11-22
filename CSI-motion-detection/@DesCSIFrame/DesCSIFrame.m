classdef DesCSIFrame
    %DESCSIFRAME Summary of this class goes here
    %   Detailed explanation goes here

    properties
        MAC
        Des_Time
        Des_CSIMatrix
        Des_Amplitude

    end

    methods

        function obj = DesCSIFrame(file)

            if(isa(file, "RXSBundle"))
                standard = obj.RXSBundle2Standard(file);

            elseif(isa(file,"cell"))
                standard = obj.cell2Standard(file);

            end
            processData = obj.splitMACAddress(standard);
            obj.MAC = processData.MAC;
            obj.Des_Time = processData.Des_Time;
            obj.Des_CSIMatrix = processData.Des_CSIMatrix;
            obj.Des_Amplitude = processData.Des_Amplitude;
        end



    end
end

