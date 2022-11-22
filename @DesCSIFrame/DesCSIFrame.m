classdef DesCSIFrame

    properties
        CSIFrame

    end

    methods

        function obj = DesCSIFrame(file)

            if(isa(file, "RXSBundle"))
                standard = obj.RXSBundle2Standard(file);

            elseif(isa(file,"cell"))
                standard = obj.cell2Standard(file);

            end
            obj.CSIFrame = obj.splitMACAddress(standard);
        end



    end
end

