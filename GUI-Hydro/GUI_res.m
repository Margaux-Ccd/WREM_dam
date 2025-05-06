function GUI_res(~,~,fig_hydropower_gui)%(data,res)%
% This function control the all the data necessary to the model are inserted
% and if this is the case, start the simulation
% Then it plot the final figure with the efficiency plot

data=get(fig_hydropower_gui, 'UserData');

if  isfield(data,'I')==0 || isfield(data,'year1')==0
    errordlg('Missing data about the river.');

elseif isfield(data,'Qmfr')==0
    errordlg('Missing data about water allocation policies. Insert the minimal flow release.')

elseif data.policies(2)>0 && (isfield(data,'Qmfr2')==0 || isfield(data,'jdateQmfr2start')==0 || isfield(data,'jdateQmfrstart')==0)
    errordlg('Missing data about water allocation policies. Insert all the data necessary to test the minimal flow release with seasonality.')

elseif data.policies(3)>0 && isfield(data,'prop')==0
    errordlg('Missing data about water allocation policies. Insert all the data necessary to test the proportional policies.')

elseif data.policies(4)>0 && (isfield(data,'min_i')==0 ||  isfield(data,'max_i')==0 ||  isfield(data,'N_i')==0 ||  isfield(data,'min_j')==0 ||  isfield(data,'max_j')==0 ||  isfield(data,'N_j')==0  ||     isfield(data,'min_a')==0 ||  isfield(data,'max_a')==0 ||  isfield(data,'N_a')==0  ||     isfield(data,'min_b')==0 ||  isfield(data,'max_b')==0 ||  isfield(data,'N_b')==0)
    errordlg('Missing data about water allocation policies. Insert all the data necessary to test the non proportional policies.')

elseif sum(data.policies)==0
    errordlg('Missing data about water allocation policies. Select the policies you want to test and insert the requested data.')


elseif isfield(data,'a')==0 || isfield(data,'b')==0 || isfield(data,'c')==0 || isfield(data,'Qmec')==0 || isfield(data,'Qn')==0 || isfield(data,'days_stop_machines')==0
    errordlg('Missing data about the hydropower plant.')

elseif  isfield(data,'threshold_young_fish')==0 || isfield(data,'threshold_adult_fish')==0
    errordlg('Missing data about the ecosystem.')

else
   res=simulation(data);
end


%% Plot efficiency plot
if exist('res')==1
    
    screen_size=get(0, 'ScreenSize');
    
    effplot=figure('Visible','on','Position',[1,1,screen_size(3),screen_size(4)],...
        'numbertitle','off',...
        'menubar','none',...
        'name','Small Hydropower Plant Efficiency Plot',...
        'resize','on','color',[1 1 1]);
   
  
    uicontrol('Style','push',...
    'string','Save the screen as a pdf',...
        'units','normalized',...
    'position',[0.68   0.1    0.27    0.05],...
    'backgroundcolor',[1 1 1],...
    'callback',{@Save_pdf});


   % Efficiency plot
    finalplot=axes('Visible','on','Units','normalized',...
        'Position',[0.1,0.1,0.5,0.8],'Box','on','color','w');
    
    ymin=min(res.xy(:,2));
    ymax=max(res.xy(:,2));
    xmin=min(res.xy(:,1));
    xmax=max(res.xy(:,1));
    
    
    pos_Pareto=find(res.B1_Env_pareto_sort(:,3)==1);
    pos_Pareto_fermi=intersect(find(res.B1_Env_pareto_sort(:,3)==1),find(isnan(res.B1_Env_pareto_sort(:,4))==0));
    pos_Pareto_fermi_inverse=intersect(pos_Pareto_fermi,find(res.B1_Env_pareto_sort(:,4)>res.B1_Env_pareto_sort(:,5)));
    pos_Pareto_fermi_standard=intersect(pos_Pareto_fermi,find(res.B1_Env_pareto_sort(:,4)<res.B1_Env_pareto_sort(:,5)));
  
    %scenarios on the pareto frontier
    B1_Env_pareto_sort_PAR = res.B1_Env_pareto_sort(pos_Pareto_fermi,:);
    
    
    if isfield(res,'B1_fermi_inverse')==1
        hold on
        plot(finalplot,res.B1_fermi_inverse,res.Env_fermi_inverse,'o','MarkerSize',5,'MarkerFaceColor',[1 0.8 0.8],'MarkerEdgeColor',[1 0.8 0.8])
    end
       
    if isfield(res,'B1_fermi_standard')==1
        hold on
        plot(finalplot,res.B1_fermi_standard,res.Env_fermi_standard,'o','MarkerSize',5,'MarkerFaceColor',[0.8 0.8 0.8],'MarkerEdgeColor',[0.8 0.8 0.8])
    end
    
    plot(finalplot,res.B1_Env_pareto_sort(pos_Pareto,1),res.B1_Env_pareto_sort(pos_Pareto,2),'-r','linewidth',2)

    hold on
    B1_Env_pareto_sort_f_inverse=res.B1_Env_pareto_sort(pos_Pareto_fermi_inverse,:);
    inv_par=plot(finalplot,B1_Env_pareto_sort_f_inverse(:,1),B1_Env_pareto_sort_f_inverse(:,2),'o','MarkerSize',5,'MarkerFaceColor',[1 0.3 0.3],'MarkerEdgeColor',[1 0.3 0.3]);
         
    hold on
    B1_Env_pareto_sort_f_standard=res.B1_Env_pareto_sort(pos_Pareto_fermi_standard,:);
    stan_par=plot(finalplot,B1_Env_pareto_sort_f_standard(:,1),B1_Env_pareto_sort_f_standard(:,2),'o','MarkerSize',5,'MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5]);
       
    hold on
    plot(finalplot,res.B1_prop,res.Env_prop,'.k','MarkerSize',18)
    if data.policies(3)>0
        for i=1:length(data.prop)
            x=sprintf(['P',num2str(data.prop(i)*100,'% 10.0f'), '%%']);
            text(res.B1_prop(i)-0.03*(xmax-xmin),res.Env_prop(i)-0.03*(ymax-ymin),x,'Parent',finalplot,'BackgroundColor','none',...
                'EdgeColor','none','FontSize',8,'HorizontalAlignment','Left');
        end
    end
    hold on
    plot(finalplot,res.B1_Qmfr,res.Env_Qmfr,'vk','MarkerSize',8,'markerfacecolor',[0 0 0])
    text(res.B1_Qmfr-0.03*(xmax-xmin),res.Env_Qmfr-0.03*(ymax-ymin),'Qmfr','Parent',finalplot,'BackgroundColor','none',...
        'EdgeColor','none','FontSize',8,'HorizontalAlignment','Left');
    hold on
    plot(finalplot,res.B1_Qmfr2,res.Env_Qmfr2,'^k','MarkerSize',8,'markerfacecolor',[0.2 0.2 0.2])
    text(res.B1_Qmfr2-0.03*(xmax-xmin),res.Env_Qmfr2-0.03*(ymax-ymin),'Qmfr_{seas}','Parent',finalplot,'BackgroundColor','none',...
        'EdgeColor','none','FontSize',8,'HorizontalAlignment','Left');
    
    leg={};
    for i=1:8
        if i==1 && sum(res.B1_Env_pareto_sort(pos_Pareto,1))>0
            leg=[leg,{'Non proportional inverse repartition'}];
        end
        if i==2 && sum(res.B1_fermi_inverse)>0
            leg=[leg,{'Non proportional standard repartition'}];
        end
         if i==3 && sum(B1_Env_pareto_sort_f_inverse(:,1))>0
            leg=[leg,{'Pareto frontier'}];
         end
         if i==4 && sum(res.B1_fermi_standard)>0
            leg=[leg,{'Optimal non proportional inverse repartition'}];
         end
         if i==5 && sum(B1_Env_pareto_sort_f_standard(:,1))>0
            leg=[leg,{'Optimal non proportional standard repartition'}];
         end
        if i==6 && sum(res.B1_prop)>0
            leg=[leg,{'Proportional repartition'}];
        end
        if i==7 && sum(res.B1_Qmfr)>0
            leg=[leg,{'Minimal flow release'}];
        end
        if i==8 && sum(res.B1_Qmfr2)>0
            leg=[leg,{'Minimal flow release with seasonality'}];
        end
    end
            
            
    legend(finalplot,leg,...
        'Location','southwest')
    ylabel('Environmental Indicator [-]','Fontsize',15)
    xlabel('Energy Produced [GWh]','Fontsize',15)
    title('Small Hydropower Plant Efficiency Plot','Fontsize',15)
    ylim([ymin-0.1*(ymax-ymin) ymax+0.1*(ymax-ymin)])
    
  
    % Plot of the fermi function
    uicontrol('Style','text','fontsize',12,'ForeGroundColor',[1 0 0],...
        'string','Use the arrows to select a point on the Pareto frontier (red line) and plot the corresponding Fermi repartition function in the graphic below:',...
        'units','normalized',...
        'position',[0.68    0.81   0.27   0.09],'backgroundcolor',[1 1 1]);
    
    
    Fermiplot = axes('Units','normalized','Position',[0.68,0.55,0.27,0.25],'Box','on');
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
    
    uipanel('units','normalized',...
       'position',[0.68    0.18   0.27    0.28],'backgroundcolor',[1 1 1]);
    
end

PointNum=1;
k1=0;
set(effplot, 'KeyPressFcn', {@MyKeyFcn});

    function MyKeyFcn(~,event)
        point= findobj('MarkerEdgeColor','k');
        if exist('point')==1
            delete(point)
        end
        switch event.Key
            case {'downarrow', 'rightarrow'};
                if PointNum < length(B1_Env_pareto_sort_PAR(:,1));
                    PointNum = PointNum + 1;
                else PointNum < length(B1_Env_pareto_sort_PAR(:,1));
                    PointNum = length(B1_Env_pareto_sort_PAR(:,1));
                end                
            case {'uparrow', 'leftarrow'};
                if PointNum > 1;
                    PointNum = PointNum - 1;
                else
                    PointNum = 1;
                end
        end
        
        if B1_Env_pareto_sort_PAR(PointNum,4)>B1_Env_pareto_sort_PAR(PointNum,5)
        point=plot(finalplot,B1_Env_pareto_sort_PAR(PointNum,1),B1_Env_pareto_sort_PAR(PointNum,2),'o','MarkerSize',12,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 0]);
        else
        point=plot(finalplot,B1_Env_pareto_sort_PAR(PointNum,1),B1_Env_pareto_sort_PAR(PointNum,2),'o','MarkerSize',12,'MarkerFaceColor',[0.4 0.4 0.4],'MarkerEdgeColor',[0 0 0]);    
        end
        
        par_i=B1_Env_pareto_sort_PAR(PointNum,4);
        par_j=B1_Env_pareto_sort_PAR(PointNum,5);
        par_a=B1_Env_pareto_sort_PAR(PointNum,6);
        par_b=B1_Env_pareto_sort_PAR(PointNum,7);
        
        par_B1=B1_Env_pareto_sort_PAR(PointNum,1);
        par_Env=B1_Env_pareto_sort_PAR(PointNum,2);
        
        A=(exp(-par_a*par_b)+1)/(exp(par_a*(1-par_b))+1); M=(-A)/(1-A);
        Y=(1-M)*(exp(-par_a*par_b)+1);
        
        x=linspace(0,1,100);
        Fra_amb=(1-(Y./(exp(par_a*(x-par_b))+1)+M))*(par_j-par_i)+par_i;
        if B1_Env_pareto_sort_PAR(PointNum,4)>B1_Env_pareto_sort_PAR(PointNum,5)
            plot(Fermiplot,x,Fra_amb,'LineWidth',2,'color',[1 0.7 0.7])
            set(Fermiplot,'Ytick',[par_j,par_i],'YTickLabel',{'j', 'i'})
        elseif B1_Env_pareto_sort_PAR(PointNum,4)<B1_Env_pareto_sort_PAR(PointNum,5)
            plot(Fermiplot,x,Fra_amb,'LineWidth',2,'color',[0.7 0.7 0.7])
            set(Fermiplot,'Ytick',[par_i,par_j],'YTickLabel',{'i','j'})
        end
        
        set(Fermiplot,'Xtick',[0,1],'XTickLabel',{'I_{min}', 'I_{max}'})
        
        xlabel(Fermiplot,'River flow rate','FontSize',12)
        ylabel(Fermiplot,'Fraction left to the river','FontSize',12)
        xlim(Fermiplot,[-0.1 1.1])
        ylim(Fermiplot,[-0.1 1.1])
        grid(Fermiplot,'on')
        
        uicontrol('Style','text',...
            'string',sprintf(['River flow range for repartition: \n'...
            '\nI_min = ',num2str(data.Qmfr+data.Qmec,'%10.2f'), ' m3/s'... 
            '\nI_max = ',num2str((data.Qn+data.Qmec)/(1-par_j)+data.Qmfr+data.Qmec,'%10.2f'), ' m3/s '... 
            '\n\nParameter values of the Fermi function \n'...
            '\ni = ',num2str(par_i,'%10.2f'),'    (fract. at the beginning of the competition)', ...
            '\nj = ',num2str(par_j,'%10.2f'),'    (fract. at the end of the competition)', ... 
            '\na = ',num2str(par_a,'%10.2f'),'   (concavity of the curve)', ... 
            '\nb = ',num2str(par_b,'%10.2f'),'   (position of the inflexion point)']),...
            'fontsize',10,...  
            'units','normalized',...
            'horizontalalignment','left',... 
            'position',[0.7    0.195  0.23    0.25],'backgroundcolor',[1 1 1]);
       
        uipanel('units','normalized',...
        'position',[0.445    0.765   0.145    0.11],'backgroundcolor',[1 1 1]);
        
        uicontrol('Style','text','units','normalized',...
           'String', sprintf(['Non-Proportional Distribution :\n','\nEnvironmental Indicator = ',num2str(par_Env,'%10.3f'),' [-]','\nEnergy Produced = ',num2str(par_B1,'%10.3f'),' [GWh]']),...
           'Position', [0.45 0.77 0.135 0.09],'backgroundcolor',[1 1 1],'horizontalalignment','left');


       
       
       % Proportional distribution
uipanel('units','normalized',...
'position',[0.109    0.33   0.132    0.13],'backgroundcolor',[1 1 1]);
       
% popup = uicontrol('Style', 'popup','units','normalized',...
%            'String', {'10%','15%','20%','25%','30%','35%','40%','45%','50%'},...
%            'Position', [0.119 0.37 0.1 0.05],...
%            'Callback', @setmap);

for zzz=1:length(data.prop)
z_slide{zzz}=sprintf(['P', num2str(data.prop(zzz)*100,'% 10.0f'), '%%']);
end

popup = uicontrol('Style', 'popup','units','normalized',...
           'String', z_slide,...
           'Position', [0.119 0.37 0.1 0.05],...
           'Callback', @setmap);
% popup = uicontrol('Style', 'popup','units','normalized',...
%            'String', {['''',strrep(num2str(data.prop*100,'% 10.0f'), '        ', ''','''),'''']},...
%            'Position', [0.119 0.37 0.1 0.05],...
%            'Callback', @setmap);

     
        function [valll]=setmap(source,event2)
        
        %val=1;
        %valll=100;
        %val_change=val;
        %val = source.Value;
        %maps = source.String;
        % For R2014a and earlier: 
        if k1==1
        children = get(gca, 'children');
        delete(children(2))   
        elseif k1==2
        children = get(gca, 'children');
        delete(children(1))
        end
        
        val = get(source,'Value');
        
        k1=2;
        
        %maps = get(source,'String'); 

        %EnvIndic=maps{val};
        %colormap(newmap);
        upper_text=uicontrol('Style','text','String','Proportional distribution:','units','normalized',...
        'horizontalalignment','center',...       
        'Position', [0.11 0.42 0.12 0.03],'backgroundcolor',[1 1 1]);
        
        improv_text =  uicontrol('Style','text',...
        'String',sprintf(['Environmental Indicator = ',num2str(res.Env_prop(val),'%10.3f'),' [-]'...
        '\nEnergy Production = ',num2str(res.B1_prop(val),'%10.3f'),' GWh']),...
        'units','normalized',...
        'horizontalalignment','left',...
        'Position', [0.112 0.34 0.125 0.04],'backgroundcolor',[1 1 1]);
        
        uicontrol('Style','text','units','normalized',...
        'String', sprintf(['Environmental Improvement : ',num2str(((par_Env-res.Env_prop(val))/(res.Env_prop(val)))*100,'%10.1f'),' [%%]','\nProduction Improvement : ',num2str(((par_B1-res.B1_prop(val))/(res.B1_prop(val)))*100,'%10.1f'),' [%%]']),...
        'Position', [0.25 0.34 0.15 0.08],'backgroundcolor',[1 1 1],'horizontalalignment','left',...
        'fontsize',9,'ForegroundColor',[1 0 0],'FontWeight','bold');
    
        line_improv = plot(finalplot,[res.B1_prop(val) par_B1],[res.Env_prop(val) par_Env],'b-.','LineWidth',2);
    
        
        end
        
    k1=1;    
    end
           
    function Save_pdf(~,~)      
        
        h=gcf;
        set(h,'PaperOrientation','landscape');
        set(h,'PaperUnits','normalized');
        set(h,'PaperPosition', [0 0 1 1]);
        file = uiputfile('*.pdf');
        print(file, '-dpdf');
        
    end

end