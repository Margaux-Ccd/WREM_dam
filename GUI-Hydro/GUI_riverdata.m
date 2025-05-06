function GUI_riverdata(~,~,fig_hydropower_gui)

screen_size=get(0, 'ScreenSize');

figriverdata=figure('Visible','on','Position',[200,200,600,800],...
    'numbertitle','off',...
    'name','River Data',...
    'menubar','none',...
    'resize','on','color',[0.8 0.8 0.8]);

%% FLOW SERIES

levelseries = axes('Visible','on','Units','normalized',...
    'Position',[0.1,0.7,0.8,0.2],'XTickLabel','','YTickLabel','','Box','on');

but.insert_flow=uicontrol('Style','push',...
    'string','Load daily river flow [m3/s]',...
    'units','normalized',...
    'position',[0.1    0.93    0.3    0.04]);

uicontrol('Style','push',...
    'string','?',...
    'units','normalized',...
    'position',[0.45    0.93    0.07    0.04],...
    'callback',@help1a);


proc1=uicontrol('Style','push',...
    'string','Proceed',...
    'units','normalized',...
    'position',[0.65    0.05    0.25    0.04],...
    'enable','off');

uicontrol('Style','text','String','Insert the first year of the river flow data series',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.60    0.5   0.04],'background',[0.8 0.8 0.8]);
but.year1=uicontrol('style','edit','String','1983','ForegroundColor',[0.65 0.65 0.65],'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive',...
    'units', 'normalized',...
    'position',[0.1  0.58    0.1    0.03]);

%%%%%%%%%%%%%%%%%%%

    function clear(hObj, event) %#ok<INUSD>

  set(hObj, 'String', '', 'Enable', 'on','ForegroundColor',[0 0 0]);
  uicontrol(hObj); % This activates the edit box and 
                   % places the cursor in the box,
                   % ready for user input.

    end

    function print_string(hObj, event) %#ok<INUSD>

  get(hObj, 'String')

    end

%%%%%%%%%%%%%%%%%%%%%

data=get(fig_hydropower_gui, 'UserData');
if isfield(data,'year1')==1 
    set(but.year1, 'string',num2str(data.year1,'% 10.0f'))
end

set([but.year1,but.insert_flow],...
    'callback',{@getdata,but,fig_hydropower_gui});

    function help1a(~,~)
        figure('Visible','on','Position',[screen_size(3)/2,screen_size(4)/2,200,100],...
            'numbertitle','off',...
            'name','Help',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        uicontrol('Style','text','String','Load a csv file where the daily data of the river flow [m3/s] are listed. A minimum period of 20 years is required. The data must start from the 1th January.',...
            'units','normalized',...
            'position',[0.1   0.1    0.8    0.8],'background',[0.8 0.8 0.8]);
    end

    function data_flow=getdata(source,~,but,fig_hydropower_gui)
        
        switch source
            case but.insert_flow
                filename=uigetfile('*.csv');
                data=get(fig_hydropower_gui, 'UserData');
                data.I=csvread(filename);
                data_flow=data.I;
                set(fig_hydropower_gui, 'UserData',data);  %save it back before return
                
                cla(levelseries)
                plot(levelseries,(1:1:length(data.I))/365,data.I,'Color',...
                [0/255 0/255 139/255],'LineWidth',1.5)
                xlabel(levelseries,'Time [years]')        %%%%%
                ylabel(levelseries,'River flow [m3/s]')   %%%%%
                ylim(levelseries,[min(data.I) max(data.I)])
                xlim(levelseries,[0 length(data.I)/365])
                grid(levelseries,'on')
                
                uicontrol('Style','push',...
                'string','Plot the Flow Duration Curve',...
                'units','normalized',...
                'position',[0.1    0.49    0.3    0.04], 'Callback', {@setmap,data_flow});
                
            case but.year1
                data=get(fig_hydropower_gui, 'UserData');
                data.year1=str2double(get(but.year1,'string'));
                set(fig_hydropower_gui, 'UserData',data);
        end
        
        data=get(fig_hydropower_gui, 'UserData');
        if isfield(data,'I')==1
            if isfield(data,'year1')==1
                set(proc1, 'Enable','on','callback',{@proceed})
            end
        end
        function proceed(~,~)
            set(figriverdata,'visible','off')
        end
        
    end

%% FLOW DURATION CURVE

FDC = axes('Visible','on','Units','normalized',...
    'Position',[0.1,0.21,0.8,0.25],'XTickLabel','','YTickLabel','','Box','on');

% uicontrol('Style','push',...
%     'string','Plot the Flow Duration Curve',...
%     'units','normalized',...
%     'position',[0.1    0.49    0.3    0.04], 'Callback', {@setmap,data_flow});

uicontrol('Style','push',...
    'string','?',...
    'units','normalized',...
    'position',[0.45    0.49    0.07    0.04],...
    'callback',@help1b);

function help1b(~,~)
        figure('Visible','on','Position',[screen_size(3)/2,screen_size(4)/2,200,100],...
            'numbertitle','off',...
            'name','Help',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        uicontrol('Style','text','String',' The FDC shows the amount of time for which a given flow is equally or exceeded in a given period of time.',...
            'units','normalized',...
            'position',[0.1   0.1    0.8    0.8],'background',[0.8 0.8 0.8]);
end


function setmap(~,~,data_flow)

%datatest=data.I;
%axes(FDC)
cla(FDC)
%hold on
ytest = duration_plot(data_flow);

Q30=ytest.percentiles(101-30,2);
Q80=ytest.percentiles(101-80,2);
Q90=ytest.percentiles(101-90,2);
Q95=ytest.percentiles(101-95,2);
       
uicontrol('Style','text','String',...
    sprintf(['Q30 = ',num2str(Q30,'%10.2f'),' [m3/s]',...
    '\nQ80 = ',num2str(Q80,'%10.2f'),' [m3/s]'...
    '\nQ90 = ',num2str(Q90,'%10.2f'),' [m3/s]'...
    '\nQ95 = ',num2str(Q95,'%10.2f'),' [m3/s]']),...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.03    0.2   0.1],'background',[0.8 0.8 0.8]);

end




end

