function [state,options,optchanged] = gaoutputfunc(options,state,flag)
persistent historyx
optchanged = false;
switch flag
    case 'init'
        initial = state.Population;
        assignin('base','gapopulationinitial',initial);
        historyx = zeros(size(initial,1),size(initial,2),1);
        historyx(:,:,1) = initial;
        assignin('base','gapopulationhistory',historyx);
	%
	case 'iter'
	%   
        disp(state.Generation)
        if rem(state.Generation,10) == 0
            ss = size(historyx,3);
            historyx(:,:,ss+1) = state.Population;
            assignin('base','gapopulationhistory',historyx);
        end
	case 'done'
        % Include the final population in the historyx.
        complete = state.Population;
        icount = state.Generation;
        ss = size(historyx,3);
        historyx(:,:,ss+1) = state.Population;
        assignin('base','gapopulationhistory',historyx);
        assignin('base','gapopulationcomplete',complete);
        assignin('base','gaicount',icount);
end
end

