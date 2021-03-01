function mttCreateSystemMdl(model)

model_name = mttDetachText(model.source,'/') ;
icd = mttCreateSystemMdl_ICD(model) ;

NumInputs = length(icd.input_namelist) ;
NumOutputs = length(icd.output_namelist) ;
MaxInterfaces = max(NumInputs,NumOutputs) ;

new_system(model_name) ;
open_system(model_name) ;
set_param(model_name,'Location',[50 100 850 250+20*MaxInterfaces]) ;

left = 100 ;
top = 25 ;
width = 600 ;
height = 25*(5+MaxInterfaces)  ;

position_vector = [left,top,left+width,top+height] ;

ModelHndl = add_block(...
    'simulink3/Subsystems/Subsystem',...
    [model_name,'/Model'],...
    'Position',position_vector,...
    'BackgroundColor','yellow',...
    'FontName','Helvetica',...
    'FontSize',num2str(16)) ;


system = [model_name,'/Model'] ;

set_param(system,'Location',[200 250 1050 285+30*MaxInterfaces]) ;

Line = get_param(system,'Lines') ;
for i = 1:length(Line)
    SrcBlock = get_param(Line(i).SrcBlock,'Name') ;
    DstBlock = get_param(Line(i).DstBlock,'Name') ;
    SrcPort = num2str(Line(i).SrcPort) ;
    DstPort = num2str(Line(i).DstPort) ;
    
    delete_line(system,[SrcBlock,'/',SrcPort],[DstBlock,'/',DstPort]) ;
end

Block = get_param(system,'Blocks') ;
for i = 1:length(Block)
    delete_block([system,'/',Block{i}]) ;
end


left = 125 ;
centre_left = 250 ;
centre = 350 ;
centre_right = 580 ;
right = 670 ;

top = 20 ;
down = 30 ;

port_width = 40 ;
port_height = 15 ;
port_spacing = down ;

mux_width = 5 ;
mux_height = NumInputs*port_spacing ;

demux_width = 5 ;
demux_height = NumOutputs*port_spacing ;

sfun_width = 150 ;
sfun_height = 30 ;

left_vertical_offset = (NumInputs*port_spacing - sfun_height)/2 ;
right_vertical_offset = (NumOutputs*port_spacing - sfun_height)/2 ;

vertical_offset = max(left_vertical_offset,right_vertical_offset) ;
datum = top + vertical_offset ;



top = datum - left_vertical_offset ;

for i = 1:NumInputs
    position_vector = [...
            left,...
            top + (i-1)*port_spacing,...
            left + port_width,...
            top + (i-1)*port_spacing + port_height] ;
        
    InHndl(i) = add_block(...
        'simulink3/Sources/In1',...
        [system,'/',icd.input_namelist{i}],...
        'Position',position_vector) ;
end

position_vector = [...
        centre_left,...
        top-port_height/3,...
        centre_left+mux_width,...
        top+mux_height-port_height/3] ;

MuxHndl = add_block(...
    'simulink3/Signals & Systems/Mux',...
    [system,'/InputMapping'],...
    'Position',position_vector,...
    'Inputs',num2str(NumInputs)) ;

position_vector = [...
        centre,...
        top+left_vertical_offset-sfun_height/2,...
        centre+sfun_width,...
        top+left_vertical_offset+sfun_height] ;

SfunHndl = add_block(...
    'simulink3/Functions & Tables/S-Function',...
    [system,'/sfun'],...
    'Position',position_vector,...
    'FunctionName',[model_name,'_sfun'],...
    'BackgroundColor','yellow',...
    'FontName','Helvetica',...
    'FontSize',num2str(16)) ;



top = datum - right_vertical_offset ;

position_vector = [...
        centre_right,...
        top-port_height/3,...
        centre_right+demux_width,...
        top+demux_height-port_height/3] ;

DemuxHndl = add_block(...
    'simulink3/Signals & Systems/Demux',...
    [system,'/OutputMapping'],...
    'Position',position_vector,...
    'Outputs',num2str(NumOutputs)) ;

for i = 1:NumOutputs
    position_vector = [...
            right,...
            top + (i-1)*port_spacing,...
            right + port_width,...
            top + (i-1)*port_spacing + port_height] ;
        
    OutHndl(i) = add_block(...
        'simulink3/Sinks/Out1',...
        [system,'/',icd.output_namelist{i}],...
        'Position',position_vector) ;
end



for i = 1:NumInputs
    port = num2str(i) ;
    InLineHndl(i) = add_line(system,...
        [icd.input_namelist{i},'/1'],['InputMapping/',port]) ;
end

SfunInLineHndl = add_line(system,'InputMapping/1','sfun/1') ;
set_param(SfunInLineHndl,'Name','_Input') ;

SfunOutLineHndl = add_line(system,'sfun/1','OutputMapping/1') ;
set_param(SfunOutLineHndl,'Name','_Output') ;

for i = 1:NumOutputs
    port = num2str(i) ;
    OutLineHndl(i) = add_line(system,...
        ['OutputMapping/',port],[icd.output_namelist{i},'/1']) ;
end

