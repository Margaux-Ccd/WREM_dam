function GUI_ecologicaldata(~,~,fig_hydropower_gui)

figecologicaldata=figure('Visible','on','Position',[300,100,600,620],...
    'numbertitle','off',...
    'name','Ecosystem Data',...
    'menubar','none',...
    'resize','on','color',[0.8 0.8 0.8]);


proc1=uicontrol('Style','push',...
    'string','Proceed',...
    'units','normalized',...
    'position',[0.125    0.017    0.75    0.05],...
    'enable','off');   
    %'enable','on');

 uicontrol('Style','push',...
    'string','Load the WUA curve',...
    'units','normalized',...
    'position',[0.1    0.47   0.2    0.06],...
    'callback',@getdatacurve);


poly = uicontrol('Style','push',...
    'string','Fit a 2° degree polynomial curve',...
    'units','normalized',...
    'position',[0.6    0.47    0.3    0.06],'enable','off');
    
WUA_curves = axes('visible','on','position',[0.1  0.1  0.8  0.35],...
    'units','normalized','XTickLabel','','YTickLabel','','Box','on');



% Imm = imread('fish.png');
% imshow(Imm);
%         RI = imref2d(size(Imm));
%         RI.XWorldLimits = [0 3];
%         RI.YWorldLimits = [0 5];
%         imshow(Imm,RI);

uicontrol('Style','text','String','Habitat suitability thresholds for the Brown Trout',...
    'horizontalalignment','center',...
    'units','normalized',...
    'position',[0.14  0.905    0.78    0.04],'background',[0.8 0.8 0.8]);

uicontrol('Style','text','String',{'The fish habitat indicator correspond to the maximal number of consecutive days under the thresholds';...
    'corresponding to the longest stress period for the fish population.'},...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.78    0.9    0.07],'background',[0.8 0.8 0.8]);

uipanel('units','normalized',...
    'position',[0.1    0.902   0.8    0.06],'backgroundcolor',[0.8 0.8 0.8]);

uicontrol('Style','text','String','Insert the flow threshold for juvenile fishes',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.65   0.4   0.08],'background',[0.8 0.8 0.8]);
but.threshold_young=uicontrol('style','edit','String','1.2','ForegroundColor',[0.65 0.65 0.65],...
    'units', 'normalized',...
    'position',[0.47  0.68    0.1    0.07],...
    'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive');
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
data=get(fig_hydropower_gui, 'UserData');
if isfield(data,'threshold_young_fish')==1 
    set(but.threshold_young, 'string',num2str(data.threshold_young_fish,'% 10.2f'))
end

uicontrol('Style','text','String','m3/s',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.6  0.65   0.05   0.08],'background',[0.8 0.8 0.8]);
but.help1=uicontrol('style','push','String','?',...
    'units', 'normalized',...
    'position',[0.7  0.68    0.1    0.07],'callback',@help1);

    function help1(~,~)
        figure('Visible','on','Position',[850,550,200,80],...
            'numbertitle','off',...
            'name','Help',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        uicontrol('Style','text','String','This value is obtained from weighted usable area WUA curve for juvenile fishes.',...
            'units','normalized',...
            'position',[0.1   0.1    0.8    0.8],'background',[0.8 0.8 0.8]);
    end

uicontrol('Style','text','String','Insert the flow threshold for adult fishes',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.55    0.4   0.08],'background',[0.8 0.8 0.8]);
but.threshold_adult=uicontrol('style','edit','String','0.73','ForegroundColor',[0.65 0.65 0.65],...
    'units', 'normalized',...
    'position',[0.47  0.58    0.1    0.07],...
    'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive');

data=get(fig_hydropower_gui, 'UserData');
if isfield(data,'threshold_adult_fish')==1 
    set(but.threshold_adult, 'string',num2str(data.threshold_adult_fish,'% 10.2f'))
end


uicontrol('Style','text','String','m3/s',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.6  0.55   0.05   0.08],'background',[0.8 0.8 0.8]);
but.help2=uicontrol('style','push','String','?',...
    'units', 'normalized',...
    'position',[0.7  0.58    0.1    0.07],'callback',@help2);

    function help2(~,~)
        figure('Visible','on','Position',[850,400,200,80],...
            'numbertitle','off',...
            'name','Help',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        uicontrol('Style','text','String','This value is obtained from weighted usable area WUA curve for adult fishes.',...
            'units','normalized',...
            'position',[0.1   0.1    0.8    0.8],'background',[0.8 0.8 0.8]);
    end

% set([but.threshold_young,but.threshold_adult],...
%     'callback',{@getdata,but,fig_hydropower_gui,data_pp});


    function getdata(source,~,but,fig_hydropower_gui,data_pp)
        
        switch source
            case but.threshold_young
                data=get(fig_hydropower_gui, 'UserData');
                data.threshold_young_fish=str2double(get(but.threshold_young,'string'));
                set(fig_hydropower_gui, 'UserData',data);
                
                %%%%%
                
            hold on
            plot(WUA_curves,[data.threshold_young_fish data.threshold_young_fish],[min(data_pp(:,2)) max(data_pp(:,2))],'--')
                
                %%%%%
                
            case but.threshold_adult
                data=get(fig_hydropower_gui, 'UserData');
                data.threshold_adult_fish=str2double(get(but.threshold_adult,'string'));
                set(fig_hydropower_gui, 'UserData',data);
        end
        
        data=get(fig_hydropower_gui, 'UserData');
        if isfield(data,'threshold_young_fish')==1 && isfield(data,'threshold_adult_fish')==1
            set(proc1, 'Enable','on','callback',{@proceed})
        end
        function proceed(~,~)
            set(figecologicaldata,'visible','off')
        end
        
     end

    function data_pp=getdatacurve(~,~)
        
        filename=uigetfile('*.csv');
        data_pp=csvread(filename);
        hold on
        cla(WUA_curves)
        plot(WUA_curves,data_pp(:,1),data_pp(:,2),'o-','MarkerFaceColor',...
            [110/255 110/255 110/255],...
            'MarkerEdgeColor',[110/255 110/255 110/255],...
            'MarkerSize',6)
        ylim([min(data_pp(:,2)) max(data_pp(:,2))])
       
        xlabel(WUA_curves,'River flow [m3/s]','FontSize',10)
        ylabel(WUA_curves,'WUA [-]','FontSize',10)
        grid(WUA_curves,'on')
        set(gca,'fontsize',8)
        
        set(poly,'enable','on','callback',{@fitpoly,data_pp})
        set([but.threshold_young,but.threshold_adult],...
    'callback',{@getdata,but,fig_hydropower_gui,data_pp});
        
    end

    function fitpoly(~,~,data_pp)
        f=polyfit(data_pp(:,1),data_pp(:,2),2);
        x=linspace(min(data_pp(:,1)),max(data_pp(:,1)),100);
        y=f(1)*x.^2+f(2)*x+f(3);
        hold on
        plot(WUA_curves,x,y,'r-','linewidth',2)
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
