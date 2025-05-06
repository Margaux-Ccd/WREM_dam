function GUI_ecologicaldata(~,~,fig_hydropower_gui)

screen_size=get(0, 'ScreenSize');

figecologicaldata=figure('Visible','on','Position',[300,100,1000,700],...
    'numbertitle','off',...
    'name','Ecosystem Data',...
    'menubar','none',...
    'resize','on','color',[0.8 0.8 0.8]);

%% HEADER

uipanel('units','normalized',...
    'position',[0.1    0.902   0.8    0.06],'backgroundcolor',[0.8 0.8 0.8]);

uicontrol('Style','text','String','Habitat suitability thresholds for the Brown Trout',...
    'horizontalalignment','center',...
    'units','normalized',...
    'position',[0.14  0.905    0.78    0.04],'background',[0.8 0.8 0.8]);

uicontrol('Style','text','String',{'The fish habitat indicator correspond to the maximal number of consecutive days under the thresholds corresponding to the longest stress period for the fish population.'},...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.81    0.9    0.07],'background',[0.8 0.8 0.8]);


%% BUTTONS

% Proceed
proc=uicontrol('Style','push',...
    'string','Proceed',...
    'units','normalized',...
    'position',[0.1    0.03    0.8    0.05],...
    'enable','off');   

% Load the curve
 uicontrol('Style','push',...
    'string','Load the WUA curve for JUVENILE fishes',...
    'units','normalized',...
    'position',[0.1  0.74    0.25    0.05],...
    'callback',@getdatacurve1); %%%%%

 uicontrol('style','push','String','?',...
    'units', 'normalized',...
    'position',[0.4  0.74    0.05    0.05],'callback',@help001);

    function help001(~,~)
        figure('Visible','on','Position',[screen_size(3)/2,screen_size(4)/2,200,100],...
            'numbertitle','off',...
            'name','Help',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        uicontrol('Style','text','String','Load a 2-columns csv file. The first column corresponds to the flow rate [m3/s] and the second column corresponds to the Weighted Usable Area [-].',...
            'units','normalized',...
            'position',[0.1   0.1    0.8    0.8],'background',[0.8 0.8 0.8]);
    end


uicontrol('Style','push',...
    'string','Load the WUA curve for ADULT fishes',...
    'units','normalized',...
    'position',[0.55  0.74    0.25    0.05],...
    'callback',@getdatacurve2); %%%%%
    
uicontrol('style','push','String','?',...
    'units', 'normalized',...
    'position',[0.85  0.74    0.05    0.05],'callback',@help002);

    function help002(~,~)
        figure('Visible','on','Position',[screen_size(3)/2,screen_size(4)/2,200,100],...
            'numbertitle','off',...
            'name','Help',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        uicontrol('Style','text','String','Load a 2-columns csv file. The first column corresponds to the flow rate [m3/s] and the second column corresponds to the Weighted Usable Area [-].',...
            'units','normalized',...
            'position',[0.1   0.1    0.8    0.8],'background',[0.8 0.8 0.8]);
    end

% Fit the curve

poly1=uicontrol('Style','push',...
    'string','Fit a 2° degree polynomial curve',...
    'units','normalized',...
    'position',[0.1  0.22    0.35    0.05],...
    'callback',@fitpoly1); %%%%%

poly2=uicontrol('Style','push',...
    'string','Fit a 2° degree polynomial curve',...
    'units','normalized',...
    'position',[0.55  0.22    0.35    0.05],...
    'callback',@fitpoly2); %%%%%

%% AXES

WUA_curves1 = axes('visible','on','position',[0.1  0.35  0.35  0.35],...
    'units','normalized','XTickLabel','','YTickLabel','','Box','on');

WUA_curves2 = axes('visible','on','position',[0.55  0.35  0.35  0.35],...
    'units','normalized','XTickLabel','','YTickLabel','','Box','on');

%% PLOTS 

% Juvenile

data_pp1=0;
data_pp2=0;

    function [data_pp1,data_pp2]=getdatacurve1(~,~)
        
        filename=uigetfile('*.csv');
        data_pp1=csvread(filename);
        
        cla(WUA_curves1)
        plot(WUA_curves1,data_pp1(:,1),data_pp1(:,2),'o-','MarkerFaceColor',...
            [110/255 110/255 110/255],...
            'MarkerEdgeColor',[110/255 110/255 110/255],...
            'MarkerSize',6)
        axes(WUA_curves1)
        ylim([min(data_pp1(:,2))-50 max(data_pp1(:,2))+50])
        
        xlabel(WUA_curves1,'River flow [m3/s]','FontSize',10)
        ylabel(WUA_curves1,'WUA [-]','FontSize',10)
        grid(WUA_curves1,'on')
        set(gca,'fontsize',8)
        data_pp2=1;
        set([but.threshold_young,but.threshold_adult],...
    'callback',{@getdata,but,fig_hydropower_gui,data_pp1,data_pp2}); %add data_pp
        set(poly1,'enable','on','callback',{@fitpoly1,data_pp1})
        
    end

%     function fitpoly1(~,~,data_pp1)
%         f=polyfit(data_pp1(:,1),data_pp1(:,2),2);
%         x=linspace(min(data_pp1(:,1)),max(data_pp1(:,1)),100);
%         y=f(1)*x.^2+f(2)*x+f(3);
%         hold on
%         plot(WUA_curves1,x,y,'r-','linewidth',2)
%         data=get(fig_hydropower_gui,'UserData');
%         data.a=f(1);
%         data.b=f(2);
%         data.c=f(3);
%         set(fig_hydropower_gui,'UserData',data);
%         
% %         if isfield(data,'a')==1 && isfield(data,'b')==1 && isfield(data,'c')==1
% %             set(proc, 'Enable','on','callback',{@proceed})
% %         end
% %         function proceed(~,~)
% %             set(fig_powerplantdata,'visible','off')
% %         end
%         
%     end

% Adult

    function [data_pp2,data_pp1]=getdatacurve2(~,~)
        
        filename=uigetfile('*.csv');
        data_pp2=csvread(filename);
        %hold on
        %cla(WUA_curves2)
        plot(WUA_curves2,data_pp2(:,1),data_pp2(:,2),'o-','MarkerFaceColor',...
            [110/255 110/255 110/255],...
            'MarkerEdgeColor',[110/255 110/255 110/255],...
            'MarkerSize',6)
        axes(WUA_curves2)
        ylim([min(data_pp2(:,2))-50 max(data_pp2(:,2))+50])
       
        xlabel(WUA_curves2,'River flow [m3/s]','FontSize',10)
        ylabel(WUA_curves2,'WUA [-]','FontSize',10)
        grid(WUA_curves2,'on')
        set(gca,'fontsize',8)
        data_pp1=1;
        set([but.threshold_young,but.threshold_adult],...
    'callback',{@getdata,but,fig_hydropower_gui,data_pp1,data_pp2}); % add data_pp
        set(poly2,'enable','on','callback',{@fitpoly2,data_pp2})
    end

%     function fitpoly2(~,~,data_pp)
%         f=polyfit(data_pp(:,1),data_pp(:,2),2);
%         x=linspace(min(data_pp(:,1)),max(data_pp(:,1)),100);
%         y=f(1)*x.^2+f(2)*x+f(3);
%         hold on
%         plot(energy_flow,x,y,'r-','linewidth',2)
%         data=get(fig_hydropower_gui,'UserData');
%         data.a=f(1);
%         data.b=f(2);
%         data.c=f(3);
%         set(fig_hydropower_gui,'UserData',data);
%         
%         if isfield(data,'a')==1 && isfield(data,'b')==1 && isfield(data,'c')==1 && isfield(data,'Qmec')==1 && isfield(data,'Qn')==1  && isfield(data,'days_stop_machines')==1
%             set(proc, 'Enable','on','callback',{@proceed})
%         end
%         function proceed(~,~)
%             set(fig_powerplantdata,'visible','off')
%         end
%         
%     end

%% JUVENILE FISHES

uicontrol('Style','text','String','Insert the flow threshold for juvenile fishes :',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.15   0.4   0.05],'background',[0.8 0.8 0.8]);
but.threshold_young=uicontrol('style','edit','String','1.2','ForegroundColor',[0.65 0.65 0.65],...
    'units', 'normalized',...
    'position',[0.1  0.10    0.1    0.05],...
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
    'position',[0.23  0.09   0.05   0.04],'background',[0.8 0.8 0.8]);
but.help1=uicontrol('style','push','String','?',...
    'units', 'normalized',...
    'position',[0.35  0.10    0.1    0.05],'callback',@help1);

    function help1(~,~)
        figure('Visible','on','Position',[screen_size(3)/2,screen_size(4)/2,200,80],...
            'numbertitle','off',...
            'name','Help',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        uicontrol('Style','text','String','This value is obtained from weighted usable area WUA curve for juvenile fishes.',...
            'units','normalized',...
            'position',[0.1   0.1    0.8    0.8],'background',[0.8 0.8 0.8]);
    end

%% ADULT FISHES

uicontrol('Style','text','String','Insert the flow threshold for adult fishes :',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.55  0.15    0.4   0.05],'background',[0.8 0.8 0.8]);
but.threshold_adult=uicontrol('style','edit','String','0.73','ForegroundColor',[0.65 0.65 0.65],...
    'units', 'normalized',...
    'position',[0.55  0.10    0.1    0.05],...
    'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive');

data=get(fig_hydropower_gui, 'UserData');
if isfield(data,'threshold_adult_fish')==1 
    set(but.threshold_adult, 'string',num2str(data.threshold_adult_fish,'% 10.2f'))
end


uicontrol('Style','text','String','m3/s',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.68  0.09   0.05   0.04],'background',[0.8 0.8 0.8]);
but.help2=uicontrol('style','push','String','?',...
    'units', 'normalized',...
    'position',[0.8  0.10    0.1    0.05],'callback',@help2);

    function help2(~,~)
        figure('Visible','on','Position',[screen_size(3)/2,screen_size(4)/2,200,80],...
            'numbertitle','off',...
            'name','Help',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        uicontrol('Style','text','String','This value is obtained from weighted usable area WUA curve for adult fishes.',...
            'units','normalized',...
            'position',[0.1   0.1    0.8    0.8],'background',[0.8 0.8 0.8]);
    end



%% CHOICE OF THE THRESHOLDS

%  set([but.threshold_young,but.threshold_adult],...
%      'callback',{@getdata,but,fig_hydropower_gui}); % add data_pp

set([but.threshold_young,but.threshold_adult],...
    'callback',{@getdata,but,fig_hydropower_gui,data_pp1,data_pp2});

k1=0;
k2=0;

    function getdata(source,~,but,fig_hydropower_gui,data_pp1,data_pp2) % add data_pp
        
        switch source
            case but.threshold_young
                data=get(fig_hydropower_gui, 'UserData');
                data.threshold_young_fish=str2double(get(but.threshold_young,'string'));
                set(fig_hydropower_gui, 'UserData',data);    
            axes(WUA_curves1)
            
            if k1==1
            children = get(gca, 'children');
            delete(children(1))
            end
            
            if data_pp1==0
            else
            hold on
%             plot(WUA_curves1,[data.threshold_young_fish data.threshold_young_fish],[min(data_pp1(:,2))-50 max(data_pp1(:,2))+50],'r--','Linewidth',2)          
            plot(WUA_curves1,[data.threshold_young_fish data.threshold_young_fish],[0 50000],'r--','Linewidth',2)          
            end  
            k1=1;
      
            case but.threshold_adult
                data=get(fig_hydropower_gui, 'UserData');
                data.threshold_adult_fish=str2double(get(but.threshold_adult,'string'));
                set(fig_hydropower_gui, 'UserData',data);
            axes(WUA_curves2)
            
            if k2==1
            children = get(gca, 'children');
            delete(children(1))
            end
            
            if data_pp2==0
            else
            hold on
%             plot(WUA_curves2,[data.threshold_adult_fish data.threshold_adult_fish],[min(data_pp2(:,2))-50 max(data_pp2(:,2))+50],'r--','Linewidth',2)
            plot(WUA_curves2,[data.threshold_adult_fish data.threshold_adult_fish],[0 50000],'r--','Linewidth',2)
            end
            
            k2=1;
  
        end
        
        data=get(fig_hydropower_gui, 'UserData');
%         if isfield(data,'threshold_young_fish')==1 && isfield(data,'threshold_adult_fish')==1
%             set(proc1, 'Enable','on','callback',{@proceed})
%         end
%         function proceed(~,~)
%             set(figecologicaldata,'visible','off')
%         end
        
    end

    function fitpoly1(~,~,data_pp1)
        XX=data_pp1(:,1); %
        YY=data_pp1(:,2);%
        XXX=XX(XX<=data.threshold_young_fish);%
        
        
        
            if XXX(end)<data.threshold_young_fish
                XXX=[XXX; data.threshold_young_fish];
                inter_tre=interp1(XX,YY,data.threshold_young_fish);
                
                YYY=[YY(1:(length(XXX)-1)); inter_tre];%
            else
                YYY=YY(1:length(XXX));
            end
   
        
        f=polyfit(XXX,YYY,2);
        x=linspace(min(XXX),max(XXX),100);
        y=f(1)*x.^2+f(2)*x+f(3);
        hold on
        plot(WUA_curves1,x,y,'r-','linewidth',2)
        data=get(fig_hydropower_gui,'UserData');
        data.a1=f(1);
        data.b1=f(2);
        data.c1=f(3);
        set(fig_hydropower_gui,'UserData',data);
        if isfield(data,'a1')==1 && isfield(data,'a2')==1 && isfield(data,'threshold_young_fish')==1 && isfield(data,'threshold_adult_fish')==1
        set(proc, 'Enable','on','callback',{@proceed})
        end
    end

    function fitpoly2(~,~,data_pp2)
        XX=data_pp2(:,1); %
        YY=data_pp2(:,2);%
        XXX=XX(XX<=data.threshold_adult_fish);%

            if XXX(end)<data.threshold_adult_fish
                XXX=[XXX; data.threshold_adult_fish];
                inter_tre=interp1(XX,YY,data.threshold_adult_fish);
                
                YYY=[YY(1:(length(XXX)-1)); inter_tre];%
            else
                YYY=YY(1:length(XXX));
            end
        
        f=polyfit(XXX,YYY,2);
        x=linspace(min(XXX),max(XXX),100);
        y=f(1)*x.^2+f(2)*x+f(3);
        hold on
        plot(WUA_curves2,x,y,'r-','linewidth',2)
        data=get(fig_hydropower_gui,'UserData');
        data.a2=f(1);
        data.b2=f(2);
        data.c2=f(3);
        set(fig_hydropower_gui,'UserData',data);
        if isfield(data,'a1')==1 && isfield(data,'a2')==1 && isfield(data,'threshold_young_fish')==1 && isfield(data,'threshold_adult_fish')==1
        set(proc, 'Enable','on','callback',{@proceed})
        end
    end

%         if isfield(data,'a1')==1 && isfield(data,'a2')==1 && isfield(data,'threshold_young_fish')==1 && isfield(data,'threshold_adult_fish')==1
%         set(proc, 'Enable','on','callback',{@proceed})
%         end
        function proceed(~,~)
        set(figecologicaldata,'visible','off')
        end

end
