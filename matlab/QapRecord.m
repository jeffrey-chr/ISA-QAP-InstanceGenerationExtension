classdef QapRecord < handle
    %QAPRECORD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        maxinst
        values
        distances
        flows
    end
    
    methods
        function me = QapRecord(m)
            %QAPRECORD Construct an instance of this class
            %   Detailed explanation goes here
            me.maxinst = m;
            me.values = Inf*ones(me.maxinst,1);
            me.distances = cell(me.maxinst,1);
            me.flows = cell(me.maxinst,1);
        end
        
        function added= addIfBetter(me, v, d, f)
            better = (v < me.values);
            
            oldv = me.values;
            oldd = me.distances;
            oldf = me.flows;
            added = false;

            if any(better)
                wherebetter = find(better);
                insertat = wherebetter(1);
                oldv(insertat+1:me.maxinst) = oldv(insertat:me.maxinst-1);
                oldd(insertat+1:me.maxinst) = oldd(insertat:me.maxinst-1);
                oldf(insertat+1:me.maxinst) = oldf(insertat:me.maxinst-1);
                oldv(insertat) = v;
                oldd{insertat} = d;
                oldf{insertat} = f;

                me.values = oldv;
                me.distances = oldd;
                me.flows = oldf;

                fprintf("Updated QapRecord, new values: ")
                for i = 1:me.maxinst
                    fprintf("%0.2f, ",me.values(i))
                end
                fprintf("\n");
                fprintf("Second entry of best flow: %d\n", me.flows{1}(2,1))
                added= true;
            end

            
        end
    end
end

