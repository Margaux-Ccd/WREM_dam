function GUI_waterallocation(~,~,fig_hydropower_gui)

figwaterallocation=figure('Visible','on','Position',[300,200,600,400],...
    'numbertitle','off',...
    'name','Water allocation policies',...
    'menubar','none',...
    'resize','on','color',[0.8 0.8 0.8]);

uipanel('units','normalized',...
    'position',[0.1    0.87   0.8    0.07],'backgroundcolor',[0.8 0.8 0.8]);

uicontrol('Style','text','String','Water allocation policies',...
    'horizontalalignment','center',...
    'units','normalized',...
    'position',[0.14  0.89    0.72    0.03],'background',[0.8 0.8 0.8]);



data=get(fig_hydropower_gui, 'UserData');
if isfield(data,'policies')==0
    data.policies=[0,0,0,0];
end
set(fig_hydropower_gui, 'UserData',data);

but.proc1=uicontrol('Style','push',...
    'string','Proceed',...
    'units','normalized',...
    'position',[0.6    0.08    0.3    0.07],...
    'enable','off');
if isfield(data,'Qmfr')==1 && isfield(data,'policies')==1
    if sum(data.policies)>0
        set(but.proc1, 'Enable','on','callback',{@proceed,fig_hydropower_gui})
    elseif sum(data.policies)==0
        set(but.proc1, 'Enable','off','callback',{@proceed,fig_hydropower_gui})
    end
end

uicontrol('Style','text','String','Insert the minimal flow release ',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.75   0.3   0.05],'background',[0.8 0.8 0.8]);
but.Qmfr=uicontrol('style','edit','String','0.38','ForegroundColor',[0.65 0.65 0.65],'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive',...
    'units', 'normalized',...
    'position',[0.44  0.75    0.1    0.06]);

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
    'position',[0.55  0.75   0.05   0.05],'background',[0.8 0.8 0.8]);
data=get(fig_hydropower_gui, 'UserData');
if isfield(data,'Qmfr')==1
    set(but.Qmfr, 'string',num2str(data.Qmfr,'% 10.2f'))
end

uicontrol('Style','text','String','And select the water allocation policies you want to test',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.58    0.7   0.08],'background',[0.8 0.8 0.8]);

but.tick_Qmfr=uicontrol('Style','checkbox','String','Minimal flow release',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.5    0.7   0.08],'background',[0.8 0.8 0.8]);
if data.policies(1)>0
    set(but.tick_Qmfr,'value',1)
end

but.tick_Qmfr2=uicontrol('Style','checkbox','String','Minimal flow release with seasonality',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.4    0.7   0.08],'background',[0.8 0.8 0.8]);
but.callback_Qmfr2=uicontrol('Style','push',...
    'string','Insert data',...
    'units','normalized',...
    'position',[0.6    0.41    0.3    0.07],...
    'enable','off','callback',{@callback_Qmfr2,fig_hydropower_gui});
if data.policies(2)>0
    set(but.tick_Qmfr2,'value',1)
    set(but.callback_Qmfr2,'enable','on')
end

but.tick_prop=uicontrol('Style','checkbox','String','Proportional repartition rules',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.3    0.7   0.08],'background',[0.8 0.8 0.8]);
but.callback_prop=uicontrol('Style','push',...
    'string','Choose the proportional rules',...
    'units','normalized',...
    'position',[0.6    0.31    0.3    0.07],...
    'enable','off','callback',{@callback_prop,fig_hydropower_gui});
if data.policies(3)>0
    set(but.tick_prop,'value',1)
    set(but.callback_prop,'enable','on')
end

but.tick_fermi=uicontrol('Style','checkbox','String','Non proportional repartition rules (Fermi functions)',...
    'horizontalalignment','left',...
    'units','normalized',...
    'position',[0.1  0.2    0.7   0.08],'background',[0.8 0.8 0.8]);
but.callback_fermi=uicontrol('Style','push',...
    'string','Choose the non proportional rules',...
    'units','normalized',...
    'position',[0.6    0.21    0.3    0.07],...
    'enable','off','callback',{@callback_fermi,fig_hydropower_gui});
if data.policies(4)>0
    set(but.tick_fermi,'value',1)
    set(but.callback_fermi,'enable','on')
end


set([but.Qmfr,but.tick_Qmfr,but.tick_Qmfr2,but.tick_prop,but.tick_fermi,but.proc1],...
    'callback',{@tick,but,fig_hydropower_gui});

% code for the policies I want to test
% 1 0 0 0 minimal flow requirement
% 0 1 0 0 minimal flow requirement with 2 threshold
% 0 0 1 0 proportional policies
% 0 0 0 1 non-proportional policies



    function tick(source,~,but,fig_hydropower_gui)
        switch source
            case but.Qmfr
                data=get(fig_hydropower_gui, 'UserData');
                data.Qmfr=str2double(get(but.Qmfr,'string'));
                set(fig_hydropower_gui,'UserData',data)
            case but.tick_Qmfr
                if (get(but.tick_Qmfr,'Value') == get(but.tick_Qmfr,'Max'))
                    data=get(fig_hydropower_gui, 'UserData');
                    data.policies(1)=1;
                    set(fig_hydropower_gui, 'UserData',data);
                else
                    data=get(fig_hydropower_gui, 'UserData');
                    data.policies(1)=0;
                    set(fig_hydropower_gui, 'UserData',data);
                end
                
            case but.tick_Qmfr2
                if (get(but.tick_Qmfr2,'Value') == get(but.tick_Qmfr2,'Max'))
                    set(but.callback_Qmfr2, 'Enable','on')
                    data=get(fig_hydropower_gui, 'UserData');
                    data.policies(2)=1;
                    set(fig_hydropower_gui, 'UserData',data);
                else
                    data=get(fig_hydropower_gui, 'UserData');
                    data.policies(2)=0;
                    set(fig_hydropower_gui, 'UserData',data);
                    set(but.callback_Qmfr2, 'Enable','off')
                end
                
            case but.tick_prop
                if (get(but.tick_prop,'Value') == get(but.tick_prop,'Max'))
                    set(but.callback_prop, 'Enable','on')
                    data=get(fig_hydropower_gui, 'UserData');
                    data.policies(3)=1;
                    set(fig_hydropower_gui, 'UserData',data);
                else
                    set(but.callback_prop, 'Enable','off')
                    data=get(fig_hydropower_gui, 'UserData');
                    data.policies(3)=0;
                    set(fig_hydropower_gui, 'UserData',data);
                end
                
            case but.tick_fermi
                if (get(but.tick_fermi,'Value') == get(but.tick_fermi,'Max'))
                    set(but.callback_fermi, 'Enable','on')
                    data=get(fig_hydropower_gui, 'UserData');
                    data.policies(4)=1;
                    set(fig_hydropower_gui, 'UserData',data);
                else
                    set(but.callback_fermi, 'Enable','off')
                    data=get(fig_hydropower_gui, 'UserData');
                    data.policies(4)=0;
                    set(fig_hydropower_gui, 'UserData',data);
                end
        end
        
        data=get(fig_hydropower_gui, 'UserData');
        
        if isfield(data,'Qmfr')==1
            if sum(data.policies)>0
                set(but.proc1, 'Enable','on','callback',{@proceed,fig_hydropower_gui})
            elseif sum(data.policies)==0
                set(but.proc1, 'Enable','off','callback',{@proceed,fig_hydropower_gui})
            end
        end
        
              
    end


    function proceed(~,~,fig_hydropower_gui)
        data=get(fig_hydropower_gui, 'UserData');
        if data.policies(2)>0 && (isfield(data,'Qmfr2')==0 || isfield(data,'jdateQmfr2start')==0 || isfield(data,'jdateQmfrstart')==0)
            errordlg('Insert all the data necessary to test the minimal flow release with seasonality')
            
        elseif data.policies(3)>0 && isfield(data,'prop')==0
            errordlg('Insert all the data necessary to test the proportional policies')
            
        elseif data.policies(4)>0 && (isfield(data,'min_i')==0 ||  isfield(data,'max_i')==0 ||  isfield(data,'N_i')==0 ||  isfield(data,'min_j')==0 ||  isfield(data,'max_j')==0 ||  isfield(data,'N_j')==0  ||     isfield(data,'min_a')==0 ||  isfield(data,'max_a')==0 ||  isfield(data,'N_a')==0  ||     isfield(data,'min_b')==0 ||  isfield(data,'max_b')==0 ||  isfield(data,'N_b')==0)
            errordlg('Insert all the data necessary to test the non proportional policies')
        else
            set(figwaterallocation,'visible','off')
        end
        
    end

    function callback_Qmfr2(~,~,fig_hydropower_gui)
        
        fig_Qmfr2=figure('Visible','on','Position',[300,200,500,300],...
            'numbertitle','off',...
            'name','Minimal flow release with seasonality',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        
        uipanel('units','normalized',...
            'position',[0.1    0.8   0.8    0.1],'backgroundcolor',[0.8 0.8 0.8]);
        
        uicontrol('Style','text','String','Minimal flow release with seasonality',...
            'horizontalalignment','center',...
            'units','normalized',...
            'position',[0.14  0.825    0.72    0.04],'background',[0.8 0.8 0.8]);
        
        
        uicontrol('Style','text','String','Insert the higher threshold of the minimal flow release',...
            'horizontalalignment','left',...
            'units','normalized',...
            'position',[0.1  0.65  0.56   0.06],'background',[0.8 0.8 0.8]);
        bu1.Qmfr2=uicontrol('style','edit','String','0.6','ForegroundColor',[0.65 0.65 0.65],'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive',...
            'units', 'normalized',...
            'position',[0.7  0.65    0.1    0.1]);
        uicontrol('Style','text','String','m3/s',...
            'horizontalalignment','left',...
            'units','normalized',...
            'position',[0.85  0.65   0.05   0.05],'background',[0.8 0.8 0.8]);
        data=get(fig_hydropower_gui, 'UserData');
        if isfield(data,'Qmfr2')==1
            set(bu1.Qmfr2, 'string',num2str(data.Qmfr2,'% 10.2f'))
        end
        
        uicontrol('Style','text','String','Insert the julian date correspondent to the beginning of the higher threshold of the minimal flow release',...
            'horizontalalignment','left',...
            'units','normalized',...
            'position',[0.1  0.5  0.56   0.1],'background',[0.8 0.8 0.8]);
        bu1.jdateQmfr2start=uicontrol('style','edit','String','90','ForegroundColor',[0.65 0.65 0.65],'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive',...
            'units', 'normalized',...
            'position',[0.7  0.5    0.1    0.1]);
        data=get(fig_hydropower_gui, 'UserData');
        if isfield(data,'jdateQmfr2start')==1
            set(bu1.jdateQmfr2start, 'string',num2str(data.jdateQmfr2start,'% 10.0f'))
        end
        
        uicontrol('Style','text','String','Insert the julian date correspondent to the beginning of the lower threshold of the minimal flow release',...
            'horizontalalignment','left',...
            'units','normalized',...
            'position',[0.1  0.35  0.56   0.1],'background',[0.8 0.8 0.8]);
        bu1.jdateQmfrstart=uicontrol('style','edit','String','272','ForegroundColor',[0.65 0.65 0.65],'Callback', @print_string,'ButtonDownFcn', @clear,'Enable','Inactive',...
            'units', 'normalized',...
            'position',[0.7  0.35   0.1    0.1]);
        data=get(fig_hydropower_gui, 'UserData');
        if isfield(data,'jdateQmfrstart')==1
            set(bu1.jdateQmfrstart, 'string',num2str(data.jdateQmfrstart,'% 10.0f'))
        end
        
        proc2=uicontrol('Style','push',...
            'string','Proceed',...
            'units','normalized',...
            'position',[0.65    0.1    0.25    0.1],...
            'enable','off');
        
        set([bu1.Qmfr2,bu1.jdateQmfr2start,bu1.jdateQmfrstart],...
            'callback',{@getdata,bu1,fig_hydropower_gui});
        
        function getdata(source,~,bu1,fig_hydropower_gui)
            
            switch source
                case bu1.Qmfr2
                    data=get(fig_hydropower_gui, 'UserData');
                    data.Qmfr2=str2double(get(bu1.Qmfr2,'string'));
                    set(fig_hydropower_gui, 'UserData',data);
                    
                case bu1.jdateQmfr2start
                    data=get(fig_hydropower_gui, 'UserData');
                    data.jdateQmfr2start=str2double(get(bu1.jdateQmfr2start,'string'));
                    set(fig_hydropower_gui, 'UserData',data);
                    
                case bu1.jdateQmfrstart
                    data=get(fig_hydropower_gui, 'UserData');
                    data.jdateQmfrstart=str2double(get(bu1.jdateQmfrstart,'string'));
                    set(fig_hydropower_gui, 'UserData',data);
            end
            
            data=get(fig_hydropower_gui, 'UserData');
            if isfield(data,'Qmfr2')==1 && isfield(data,'jdateQmfr2start')==1 && isfield(data,'jdateQmfrstart')==1
                set(proc2, 'Enable','on','callback',{@proceed})
            end
            function proceed(~,~)
                set(fig_Qmfr2,'visible','off')
            end
            
        end
        
    end

    function callback_prop(~,~,fig_hydropower_gui)
        fig_prop=figure('Visible','on','Position',[300,200,600,250],...
            'numbertitle','off',...
            'name','Proportional repartition rules',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        
        uipanel('units','normalized',...
            'position',[0.1    0.8   0.8    0.1],'backgroundcolor',[0.8 0.8 0.8]);
        
        uicontrol('Style','text','String','Proportional repartition rules',...
            'horizontalalignment','center',...
            'units','normalized',...
            'position',[0.14  0.825    0.72    0.05],'background',[0.8 0.8 0.8]);
        
        but2.def_par=uicontrol('Style','push',...
            'string','Use default values',...
            'units','normalized',...
            'position',[0.1    0.6    0.3    0.1]);
        
        uicontrol('Style','text','String',{'Insert the fixed percetages of the incoming river flow left to the environment.';'The inserted values must be separated by a whitespace.'},...
            'horizontalalignment','left',...
            'units','normalized',...
            'position',[0.1  0.35  0.8  0.2],'background',[0.8 0.8 0.8]);
        but2.prop=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.1  0.3   0.77    0.1]);
        uicontrol('Style','text','String','%',...
            'horizontalalignment','left',...
            'units','normalized',...
            'position',[0.88  0.28  0.1  0.1],'background',[0.8 0.8 0.8]);
        
        data=get(fig_hydropower_gui, 'UserData');
        if isfield(data,'prop')==1
            set(but2.prop, 'string',num2str(data.prop*100,'% 10.0f'))
        end
        
        but2.proc=uicontrol('Style','push',...
            'string','Proceed',...
            'units','normalized',...
            'position',[0.65    0.1    0.25    0.1],...
            'enable','off');
        
        set([but2.prop,but2.def_par],'callback',{@insertprop,but2,fig_hydropower_gui})
        
        
        
        function insertprop(source,~,but2,fig_hydropower_gui)
            
            switch source
                
                case but2.def_par
                    prop=[10 15 20 25 30 35 40 45 50]/100;
                    set(but2.prop,'string',num2str(prop*100))
                case but2.prop
                    
                    prop=str2num(get(but2.prop,'string'))/100;
            end
            
            data=get(fig_hydropower_gui, 'UserData');
            data.prop=prop;
            set(fig_hydropower_gui, 'UserData',data);
            
            if isfield(data,'prop')==1
                set(but2.proc, 'Enable','on','callback',{@proceed})
            end
            function proceed(~,~)
                set(fig_prop,'visible','off')
            end
            
        end
    end

    function callback_fermi(~,~,fig_hydropower_gui)
        
        fig_fermi=figure('Visible','on','Position',[300,100,600,500],...
            'numbertitle','off',...
            'name','Non proportional repartition rules (Fermi functions)',...
            'menubar','none',...
            'resize','on','color',[0.8 0.8 0.8]);
        
        uipanel('units','normalized',...
            'position',[0.1    0.91   0.8    0.06],'backgroundcolor',[0.8 0.8 0.8]);
        
        uicontrol('Style','text','String','Non proportional repartition rules (Fermi functions)',...
            'horizontalalignment','center',...
            'units','normalized',...
            'position',[0.14  0.92    0.72    0.03],'background',[0.8 0.8 0.8]);
        
        but3.def_par=uicontrol('Style','push',...
            'string','Use default values',...
            'units','normalized',...
            'position',[0.1    0.8    0.3    0.05]);
        
        %parameter i
        uicontrol('Style','text',...
            'string','Parameter i   [0-1]',...
            'horizontalalignment','left',...
            'units','normalized',...
            'position',[0.1    0.72    0.2    0.03],'background',[0.8 0.8 0.8]);
        but3.min_i=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.32  0.72    0.08    0.04]);
        uicontrol('Style','text',...
            'string','Min value',...
            'units','normalized',...
            'position',[0.4   0.72    0.1    0.03],'background',[0.8 0.8 0.8]);
        but3.max_i=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.52  0.72    0.08    0.04]);
        uicontrol('Style','text',...
            'string','Max value',...
            'units','normalized',...
            'position',[0.6   0.72    0.1    0.03],'background',[0.8 0.8 0.8]);
        but3.N_i=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.72  0.72    0.08    0.04]);
        uicontrol('Style','text',...
            'string','N° of steps',...
            'units','normalized',...
            'position',[0.8   0.72    0.1    0.03],'background',[0.8 0.8 0.8]);
        data=get(fig_hydropower_gui, 'UserData');
        if isfield(data,'fermi_i')==1
            set(but3.min_i, 'string',num2str(data.fermi_i(1),'% 10.2f'))
            set(but3.max_i, 'string',num2str(data.fermi_i(end),'% 10.2f'))
            set(but3.N_i, 'string',num2str(length(data.fermi_i),'% 10.0f'))
        end
        
        %parameter j
        uicontrol('Style','text',...
            'string','Parameter j   [0-1]',...
            'horizontalalignment','left',...
            'units','normalized',...
            'position',[0.1    0.67   0.2    0.03],'background',[0.8 0.8 0.8]);
        but3.min_j=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.32  0.67   0.08    0.04]);
        uicontrol('Style','text',...
            'string','Min value',...
            'units','normalized',...
            'position',[0.4   0.67   0.1    0.03],'background',[0.8 0.8 0.8]);
        but3.max_j=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.52  0.67   0.08    0.04]);
        uicontrol('Style','text',...
            'string','Max value',...
            'units','normalized',...
            'position',[0.6   0.67   0.1    0.03],'background',[0.8 0.8 0.8]);
        but3.N_j=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.72  0.67   0.08    0.04]);
        uicontrol('Style','text',...
            'string','N° of steps',...
            'units','normalized',...
            'position',[0.8   0.67   0.1    0.03],'background',[0.8 0.8 0.8]);
        data=get(fig_hydropower_gui, 'UserData');
        if isfield(data,'fermi_j')==1
            set(but3.min_j, 'string',num2str(data.fermi_j(1),'% 10.2f'))
            set(but3.max_j, 'string',num2str(data.fermi_j(end),'% 10.2f'))
            set(but3.N_j, 'string',num2str(length(data.fermi_j),'% 10.0f'))
        end
        
        %parameter a
        uicontrol('Style','text',...
            'string','Parameter a  [2-8]',...
            'horizontalalignment','left',...
            'units','normalized',...
            'position',[0.1    0.62    0.2    0.03],'background',[0.8 0.8 0.8]);
        but3.min_a=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.32  0.62    0.08    0.04]);
        uicontrol('Style','text',...
            'string','Min value',...
            'units','normalized',...
            'position',[0.4   0.62    0.1    0.03],'background',[0.8 0.8 0.8]);
        but3.max_a=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.52  0.62    0.08    0.04]);
        uicontrol('Style','text',...
            'string','Max value',...
            'units','normalized',...
            'position',[0.60   0.62    0.1    0.03],'background',[0.8 0.8 0.8]);
        but3.N_a=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.72  0.62    0.08    0.04]);
        uicontrol('Style','text',...
            'string','N° of steps',...
            'units','normalized',...
            'position',[0.8   0.62    0.1    0.03],'background',[0.8 0.8 0.8]);
        data=get(fig_hydropower_gui, 'UserData');
        if isfield(data,'fermi_a')==1
            set(but3.min_a, 'string',num2str(data.fermi_a(1),'% 10.2f'))
            set(but3.max_a, 'string',num2str(data.fermi_a(end),'% 10.2f'))
            set(but3.N_a, 'string',num2str(length(data.fermi_a),'% 10.0f'))
        end
        
        %parameter b
        uicontrol('Style','text',...
            'string','Parameter b  [0-1]',...
            'horizontalalignment','left',...
            'units','normalized',...
            'position',[0.1    0.57   0.2    0.03],'background',[0.8 0.8 0.8]);
        but3.min_b=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.32  0.57   0.08    0.04]);
        uicontrol('Style','text',...
            'string','Min value',...
            'units','normalized',...
            'position',[0.4   0.57   0.1    0.03],'background',[0.8 0.8 0.8]);
        but3.max_b=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.52  0.57   0.08    0.04]);
        uicontrol('Style','text',...
            'string','Max value',...
            'units','normalized',...
            'position',[0.6   0.57   0.1    0.03],'background',[0.8 0.8 0.8]);
        but3.N_b=uicontrol('style','edit',...
            'units', 'normalized',...
            'position',[0.72  0.57   0.08    0.04]);
        uicontrol('Style','text',...
            'string','N° of steps',...
            'units','normalized',...
            'position',[0.8   0.57   0.1    0.03],'background',[0.8 0.8 0.8]);
        data=get(fig_hydropower_gui, 'UserData');
        if isfield(data,'fermi_b')==1
            set(but3.min_b, 'string',num2str(data.fermi_b(1),'% 10.2f'))
            set(but3.max_b, 'string',num2str(data.fermi_b(end),'% 10.2f'))
            set(but3.N_b, 'string',num2str(length(data.fermi_b),'% 10.0f'))
        end
        
        
        but3.proc=uicontrol('Style','push',...
            'string','Proceed',...
            'units','normalized',...
            'position',[0.6    0.1    0.3   0.05],...
            'enable','off');
        
        
        set([but3.def_par,but3.min_i,but3.max_i,but3.N_i,but3.min_j,but3.max_j,but3.N_j,but3.min_a,but3.max_a,but3.N_a,but3.min_b,but3.max_b,but3.N_b],...
            'callback',{@fermiparameter,but3,fig_hydropower_gui});
        
        function fermiparameter(source,~,but3,fig_hydropower_gui)
            
            min_i=str2double(get(but3.min_i,'string'));
            max_i=str2double(get(but3.max_i,'string'));
            N_i=str2double(get(but3.N_i,'string'));
            min_j=str2double(get(but3.min_j,'string'));
            max_j=str2double(get(but3.max_j,'string'));
            N_j=str2double(get(but3.N_j,'string'));
            min_a=str2double(get(but3.min_a,'string'));
            max_a=str2double(get(but3.max_a,'string'));
            N_a=str2double(get(but3.N_a,'string'));
            min_b=str2double(get(but3.min_b,'string'));
            max_b=str2double(get(but3.max_b,'string'));
            N_b=str2double(get(but3.N_b,'string'));
            
            switch source
                case but3.def_par
                    min_i=0.1;
                    set(but3.min_i,'string',min_i)
                    max_i=0.8;
                    set(but3.max_i,'string',max_i)
                    N_i=8;
                    set(but3.N_i,'string',N_i)
                    min_j=0.1;
                    set(but3.min_j,'string',min_j)
                    max_j=0.8;
                    set(but3.max_j,'string',max_j)
                    N_j=8;
                    set(but3.N_j,'string',N_j)
                    min_a=2;
                    set(but3.min_a,'string',min_a)
                    max_a=8;
                    set(but3.max_a,'string',max_a)
                    N_a=4;
                    set(but3.N_a,'string',N_a)
                    min_b=0;
                    set(but3.min_b,'string',min_b)
                    max_b=1;
                    set(but3.max_b,'string',max_b)
                    N_b=11;
                    set(but3.N_b,'string',N_b)
                    data=get(fig_hydropower_gui, 'UserData');
                    data.min_i=min_i;
                    data.max_i=max_i;
                    data.N_i=N_i;
                    data.min_j=min_j;
                    data.max_j=max_j;
                    data.N_j=N_j;
                    data.min_a=min_a;
                    data.max_a=max_a;
                    data.N_a=N_a;
                    data.min_b=min_b;
                    data.max_b=max_b;
                    data.N_b=N_b;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.min_i
                    min_i=str2double(get(but3.min_i,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.min_i=min_i;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.max_i
                    max_i=str2double(get(but3.max_i,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.max_i=max_i;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.N_i
                    N_i=str2double(get(but3.N_i,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.N_i=N_i;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.min_j
                    min_j=str2double(get(but3.min_j,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.min_j=min_j;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.max_j
                    max_j=str2double(get(but3.max_j,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.max_j=max_j;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.N_j
                    N_j=str2double(get(but3.N_j,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.N_j=N_j;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.min_a
                    min_a=str2double(get(but3.min_a,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.min_a=min_a;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.max_a
                    max_a=str2double(get(but3.max_a,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.max_a=max_a;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.N_a
                    N_a=str2double(get(but3.N_a,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.N_a=N_a;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.min_b
                    min_b=str2double(get(but3.min_b,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.min_b=min_b;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.max_b
                    max_b=str2double(get(but3.max_b,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.max_b=max_b;
                    set(fig_hydropower_gui, 'UserData',data);
                case but3.N_b
                    N_b=str2double(get(but3.N_b,'string'));
                    data=get(fig_hydropower_gui, 'UserData');
                    data.N_b=N_b;
                    set(fig_hydropower_gui, 'UserData',data);
                    
            end
            
            
            data.fermi_i=linspace(min_i,max_i,N_i);
            data.fermi_j=linspace(min_j,max_j,N_j);
            data.fermi_a=linspace(min_a,max_a,N_a);
            data.fermi_b=linspace(min_b,max_b,N_b);
            set(fig_hydropower_gui, 'UserData',data);
            
            data=get(fig_hydropower_gui, 'UserData');
            
            if isfield(data,'min_i')==1 && isfield(data,'max_i')==1 && isfield(data,'N_i')==1 && isfield(data,'min_j')==1 && isfield(data,'max_j')==1 && isfield(data,'N_j')==1  &&    isfield(data,'min_a')==1 && isfield(data,'max_a')==1 && isfield(data,'N_a')==1  &&    isfield(data,'min_b')==1 && isfield(data,'max_b')==1 && isfield(data,'N_b')==1
                set(but3.proc, 'Enable','on','callback',{@proceed})
            end
            function proceed(~,~)
                set(fig_fermi,'visible','off')
            end
            
        end
        
     
        uicontrol('Style','text',...
            'string','The fraction of water given to the environment depends on the value of the incoming flow',...
            'horizontalalignment','left',...
            'units','normalized','Fontsize',10,...
            'position',[0.07    0.46    0.9    0.07],'background',[0.8 0.8 0.8],'ForegroundColor',[1 0 0]);
        
        %visualize the Fermi function
        uicontrol('Style','text',...
            'string','visualize the Fermi function',...
            'horizontalalignment','left',...
            'units','normalized','Fontsize',10,...
            'position',[0.12    0.42    0.4    0.03],'background',[0.8 0.8 0.8]);
        
        plot1 = axes('Units','normalized','Position',[0.1,0.1,0.35,0.3],'Box','on');
        
        par_i=0;
        par_j=0.9;
        par_a=8;
        par_b=0;
        
        A=(exp(-par_a*par_b)+1)/(exp(par_a*(1-par_b))+1);
        M=(-A)/(1-A);
        Y=(1-M)*(exp(-par_a*par_b)+1);
        
        x=linspace(0,1,100);
        Fra_amb=(1-(Y./(exp(par_a*(x-par_b))+1)+M))*(par_j-par_i)+par_i;
        plot(plot1,x,Fra_amb,'LineWidth',2,'color',[0.7 0.7 0.7])
        set(plot1,'Xtick',[0,1],'XTickLabel',{'Q_{min}', 'Q_{max}'})
        set(plot1,'Ytick',[par_i,par_j],'YTickLabel',{'i', 'j'})
        xlabel('River flow rate','FontSize',10)
        ylabel('Fraction left to the river','FontSize',10)
        xlim([-0.1 1.1])
        ylim([-0.1 1.1])
        grid on
        
        %slider i
        uicontrol('Style','text','String','i = ',...
            'horizontalalignment','left',...
            'units','normalized','backgroundcolor',[0.8 0.8 0.8],...
            'position',[0.50    0.35    0.05    0.03]);
        but3.text_i=uicontrol('style','text',...
            'units', 'normalized','backgroundcolor',[0.8 0.8 0.8],...
            'position',[0.53    0.35    0.05    0.03],...
            'string',num2str(par_i));
        but3.sl_i=uicontrol('Style','Slider',...
            'Min',0,'Max',1,'Value',par_i,...
            'SliderStep',[0.02,0.02],...
            'units','normalized',...
            'position',[0.6    0.35    0.3    0.03]);
        
        %slider j
        uicontrol('Style','text','String','j = ',...
            'horizontalalignment','left',...
            'units','normalized','backgroundcolor',[0.8 0.8 0.8],...
            'position',[0.50    0.3    0.05    0.03]);
        but3.text_j=uicontrol('style','text',...
            'units', 'normalized','backgroundcolor',[0.8 0.8 0.8],...
            'position',[0.53    0.3    0.05    0.03],...
            'string',num2str(par_j));
        but3.sl_j=uicontrol('Style','Slider',...
            'Min',0,'Max',1,'Value',par_j,...
            'SliderStep',[0.02,0.02],...
            'units','normalized',...
            'position',[0.6    0.3    0.3    0.03]);
        
        %slider a
        uicontrol('Style','text','String','a = ',...
            'horizontalalignment','left',...
            'units','normalized','backgroundcolor',[0.8 0.8 0.8],...
            'position',[0.50    0.25    0.05    0.03]);
        but3.text_a=uicontrol('style','text',...
            'units', 'normalized','backgroundcolor',[0.8 0.8 0.8],...
            'position',[0.53    0.25    0.05    0.03],...
            'string',num2str(par_a));
        but3.sl_a=uicontrol('Style','Slider',...
            'Min',2,'Max',8,'Value',par_a,...
            'SliderStep',[0.05,0.05],...
            'units','normalized',...
            'position',[0.6    0.25    0.3    0.03]);
        
        %slider b
        uicontrol('Style','text','String','b = ',...
            'horizontalalignment','left',...
            'units','normalized','backgroundcolor',[0.8 0.8 0.8],...
            'position',[0.50    0.2    0.05    0.03]);
        but3.text_b=uicontrol('style','text',...
            'units', 'normalized','backgroundcolor',[0.8 0.8 0.8],...
            'position',[0.53    0.2    0.05    0.03],...
            'string',num2str(par_b));
        but3.sl_b=uicontrol('Style','Slider',...
            'Min',0,'Max',1,'Value',par_b,...
            'SliderStep',[0.02,0.02],...
            'units','normalized',...
            'position',[0.6    0.2    0.3    0.03]);
        
        set([but3.text_i,but3.sl_i,but3.text_j,but3.sl_j,but3.text_a,but3.sl_a,but3.text_b,but3.sl_b],...            Cont.L_slider,Cont.L_edit,Cont.dh_slider,Cont.dh_edit,...
            'callback',{@modifyparam,but3});
        
        function modifyparam(source,~,but3)
            
            i_slid=get(but3.sl_i,'Value');
            j_slid=get(but3.sl_j,'Value');
            a_slid=get(but3.sl_a,'Value');
            b_slid=get(but3.sl_b,'Value');
            
            switch source % Who called?
                case but3.sl_i
%                    par_i=round(i_slid,2);
                    par_i=round(i_slid*100)/100;
                    set(but3.text_i,'string',par_i) % Set edit to current slider.
                    set(but3.sl_i,'value',par_i)
                case but3.sl_j
%                    par_j=round(j_slid,2);
                    par_j=round(j_slid*100)/100;
                    set(but3.text_j,'string',par_j) % Set edit to current slider.
                    set(but3.sl_j,'value',par_j)
                case but3.sl_a
%                    par_a=round(a_slid,2);
                    par_a=round(a_slid*100)/100;
                    set(but3.text_a,'string',par_a) % Set edit to current slider.
                    set(but3.sl_a,'value',par_a)
                case but3.sl_b
%                    par_b=round(b_slid,2);
                    par_b=round(b_slid*100)/100;
                    set(but3.text_b,'string',par_b) % Set edit to current slider.
                    set(but3.sl_b,'value',par_b)
                    
                otherwise
            end
            
            A=(exp(-par_a*par_b)+1)/(exp(par_a*(1-par_b))+1);
            M=(-A)/(1-A);
            Y=(1-M)*(exp(-par_a*par_b)+1);
            
            x=linspace(0,1,100);
            Fra_amb=(1-(Y./(exp(par_a*(x-par_b))+1)+M))*(par_j-par_i)+par_i;
            
            if par_i<par_j
                plot(plot1,x,Fra_amb,'LineWidth',2,'color',[0.7 0.7 0.7])
            elseif par_i>par_j
                plot(plot1,x,Fra_amb,'LineWidth',2,'color',[1 0.7 0.7])
            else par_i==par_j
                plot(plot1,x,Fra_amb,'LineWidth',2,'color',[0 0 0])
            end
            set(plot1,'Xtick',[0,1],'XTickLabel',{'Q_{min}', 'Q_{max}'})
            if par_i<par_j
                set(plot1,'Ytick',[par_i,par_j],'YTickLabel',{'i', 'j'})
            elseif par_i>par_j
                set(plot1,'Ytick',[par_j,par_i],'YTickLabel',{'j', 'i'})
            elseif par_i==par_j
                set(plot1,'Ytick',par_j,'YTickLabel',{'j=i'})
            end
            xlabel('River flow','FontSize',10)
            ylabel('Fraction left to the river','FontSize',10)
            xlim([-0.1 1.1])
            ylim([-0.1 1.1])
            grid on
            
        end
        
        
        
        
    end



end