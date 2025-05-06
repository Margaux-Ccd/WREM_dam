function GUI_powerplantdata(~,~,fig_hydropower_gui)

screen_size=get(0, 'ScreenSize');

fig_powerplantdata=figure('Visible','on','Position',[300,100,450,500],...
    'numbertitle','off',...
    'name','Power Plant Data',...
    'menubar','none',...
    'resize','on','color',[0.8 0.8 0.8]);

uipanel('units','normalized',...
    'position',[0.1    0.902   0.8    0.06],'backgroundcolor',[0.8 0.8 0.8]);

uicontrol('Style','text','String','Characteristics of the SHPP',...
    'horizontalalignment','center',...
    'units','normalized',...
    'position',[0.14  0.905    0.72    0.04],'background',[0.8 0.8 0.8]);

uicontrol('Style','text','String','Minimal operating flow rate of the power plant',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.8    0.6    0.05],'background',[0.8 0.8 0.8]);
but.Qmec=uicontrol('style','edit','String','0.45','ForegroundColor',[0.65 0.65 0.65],'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive',...
    'units', 'normalized',...
    'position',[0.7  0.82    0.1    0.04]);

%%%%%%%%%%%%%%%%%%%%

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

uicontrol('Style','text','String','m3/s',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.83  0.8    0.8    0.05],'background',[0.8 0.8 0.8]);
data=get(fig_hydropower_gui, 'UserData');
if isfield(data,'Qmec')==1 
    set(but.Qmec, 'string',num2str(data.Qmec,'% 10.2f'))
end

uicontrol('Style','text','String','Maximal operating flow rate of the turbine (nominal flow rate)',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.73    0.5   0.07],'background',[0.8 0.8 0.8]);
but.Qn=uicontrol('style','edit','String','4.5','ForegroundColor',[0.65 0.65 0.65],'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive',...
    'units', 'normalized',...
    'position',[0.7  0.75    0.1    0.04]);
uicontrol('Style','text','String','m3/s',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.83  0.73    0.8    0.05],'background',[0.8 0.8 0.8]);
if isfield(data,'Qn')==1 
    set(but.Qn, 'string',num2str(data.Qn,'% 10.2f'))
end

uicontrol('Style','text','String','Number of days a year in which the power plant stops due to maintenance works',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.66    0.5   0.07],'background',[0.8 0.8 0.8]);
but.days_stop_machines=uicontrol('style','edit','String','5','ForegroundColor',[0.65 0.65 0.65],'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive',...
    'units', 'normalized',...
    'position',[0.7  0.68    0.1    0.04]);
if isfield(data,'days_stop_machines')==1 
    set(but.days_stop_machines, 'string',num2str(data.days_stop_machines,'% 10.0f'))
end

set([but.Qmec,but.Qn,but.days_stop_machines],...
    'callback',{@qvalue,but,fig_hydropower_gui});

uicontrol('Style','push',...
    'string','Load the power data of SHPP',...
    'units','normalized',...
    'position',[0.1    0.58   0.7    0.06],...
    'callback',@getdata);

uicontrol('Style','push',...
    'string','?',...
    'units','normalized',...
    'position',[0.83    0.58    0.07    0.06],...
    'callback',@help1a);

    function help1a(~,~)
        figure('Visible','on','Position',[screen_size(3)/2,screen_size(4)/2,200,120],...
            'numbertitle','off',...
            'name','Help',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        uicontrol('Style','text','String','Load a csv file. The flow rate [m3/s] is listed in the first column and the correspondent energy producted [kW] in the second column.',...
            'units','normalized',...
            'position',[0.1   0.1    0.8    0.8],'background',[0.8 0.8 0.8]);
    end

energy_flow = axes('Visible','on','Units','normalized',...
    'Position',[0.10,0.26,0.8,0.28],'XTickLabel','','YTickLabel','','Box','on');

poly=uicontrol('Style','push',...
    'string','Fit a 2° degree polynomial curve',...
    'units','normalized',...
    'position',[0.1    0.15    0.8    0.06],'enable','off');

proc=uicontrol('Style','push',...
    'string','Proceed',...
    'units','normalized',...
    'position',[0.1    0.05    0.8    0.06],'enable','off');

    function qvalue(source,~,but,fig_hydropower_gui)
        switch source
            case but.Qmec
                data=get(fig_hydropower_gui,'UserData');
                data.Qmec=str2double(get(but.Qmec,'string'));
                set(fig_hydropower_gui,'UserData',data);
            case but.Qn
                data=get(fig_hydropower_gui,'UserData');
                data.Qn=str2double(get(but.Qn,'string'));
                set(fig_hydropower_gui,'UserData',data);
            case but.days_stop_machines
                data=get(fig_hydropower_gui,'UserData');
                data.days_stop_machines=str2double(get(but.days_stop_machines,'string'));
                set(fig_hydropower_gui,'UserData',data);
        end
        if isfield(data,'a')==1 && isfield(data,'b')==1 && isfield(data,'c')==1 && isfield(data,'Qmec')==1 && isfield(data,'Qn')==1 && isfield(data,'days_stop_machines')==1
            set(proc, 'Enable','on','callback',{@proceed})
        end
        function proceed(~,~)
            set(fig_powerplantdata,'visible','off')
        end
    end

    function data_pp=getdata(~,~)
        
        filename=uigetfile('*.csv');
        data_pp=csvread(filename);
        
        cla(energy_flow)
        plot(energy_flow,data_pp(:,1),data_pp(:,2),'o','MarkerFaceColor',...
            [110/255 110/255 110/255],...
            'MarkerEdgeColor',[110/255 110/255 110/255],...
            'MarkerSize',6)
        xlabel(energy_flow,'Turbined flow [m3/s]','FontSize',10)
        ylabel(energy_flow,'Power [kW]','FontSize',10)
        grid(energy_flow,'on')
        set(gca,'fontsize',8)
        
        set(poly,'enable','on','callback',{@fitpoly,data_pp})
        
    end

    function fitpoly(~,~,data_pp)
        f=polyfit(data_pp(:,1),data_pp(:,2),2);
        x=linspace(min(data_pp(:,1)),max(data_pp(:,1)),100);
        y=f(1)*x.^2+f(2)*x+f(3);
        hold on
        plot(energy_flow,x,y,'r-','linewidth',2)
        data=get(fig_hydropower_gui,'UserData');
        data.a=f(1);
        data.b=f(2);
        data.c=f(3);
        set(fig_hydropower_gui,'UserData',data);
        
        if isfield(data,'a')==1 && isfield(data,'b')==1 && isfield(data,'c')==1 && isfield(data,'Qmec')==1 && isfield(data,'Qn')==1  && isfield(data,'days_stop_machines')==1
            set(proc, 'Enable','on','callback',{@proceed})
        end
        function proceed(~,~)
            set(fig_powerplantdata,'visible','off')
        end
        
    end


end
%Qmec, coef_A, coef_B, coef_C, Qn