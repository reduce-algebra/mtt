function mttWriteSystemApps(model)
	if ~isfield(model,'app')
    	return ;
	end

    filename = [model.source,'_include_apps.h'] ;
    fid = fopen(filename,'w') ;
    
    mttNotify(['...creating ',filename]) ;
    mttWriteNewLine ;
    
    fprintf(fid,['// Applications for Ordinary Differential Equations\n']) ;
    fprintf(fid,'\n') ;
    fprintf(fid,['// file: ',filename,'\n']) ;
    fprintf(fid,['// written by MTT on ',datestr(now),'\n']) ;
    
    fprintf(fid,'\n\n') ;
    
    for i = 1:length(model.app)
        app_inclusion = ['#include "',model.app{i},'"\n'] ;
        fprintf(fid,app_inclusion) ;
    end
    
    fclose(fid) ;