function varargout = egg_annotator_gui(varargin)
% EGG_ANNOTATOR_GUI MATLAB code for egg_annotator_gui.fig
%      EGG_ANNOTATOR_GUI, by itself, creates a new EGG_ANNOTATOR_GUI or raises the existing
%      singleton*.
%
%      H = EGG_ANNOTATOR_GUI returns the handle to a new EGG_ANNOTATOR_GUI or the handle to
%      the existing singleton*.
%
%      EGG_ANNOTATOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EGG_ANNOTATOR_GUI.M with the given input arguments.
%
%      EGG_ANNOTATOR_GUI('Property','Value',...) creates a new EGG_ANNOTATOR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before egg_annotator_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to egg_annotator_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help egg_annotator_gui

% Last Modified by GUIDE v2.5 05-Feb-2020 19:00:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @egg_annotator_gui_OpeningFcn, ...
    'gui_OutputFcn',  @egg_annotator_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
warning('off');

% End initialization code - DO NOT EDIT
end

% --- Executes just before egg_annotator_gui is made visible.
function egg_annotator_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to egg_annotator_gui (see VARARGIN)


warning('off');

handles.centerplainval = -1;
handles.filename = varargin{1};
handles.inputeggs = varargin{2};
handles.list_box_index =1;
if(strcmp(handles.filename((end-3):(end)),'.fmf'))
    % extract header from the appropriate FMF
    [header_size, version, f_height, f_width, bytes_per_chunk, max_n_frames, data_format] = fmf_read_header(handles.filename);
    handles.header_size = header_size;
    handles.version = version;
    handles.f_height = f_height;
    handles.f_width = f_width;
    handles.bytes_per_chunk = bytes_per_chunk;
    handles.max_n_frames = max_n_frames;
    handles.data_format = data_format;
    handles.fp = fopen( handles.filename, 'r' );
    %fseek(handles.fp,handles.header_size,'bof');
    %[data, stamp] = fmf_read_frame( handles.fp, handles.f_height, handles.f_width, handles.bytes_per_chunk, handles.data_format );
    handles.movie_length = max_n_frames;
    handles.isfmf = 1;
end

if(strcmp(handles.filename((end-3):(end)),'ufmf'))
    header = ufmf_read_header(handles.filename);
    handles.header = header;
    handles.movie_length = header.nframes;
    handles.max_n_frames = header.nframes;
    handles.f_height = header.max_width;
    handles.f_width = header.max_height;
    handles.isfmf = 2;
    
end

if(strcmp(handles.filename((end-3):(end)),'.avi') || strcmp(handles.filename((end-3):(end)),'.mp4'))
   % matlab.video.read.UseHardwareAcceleration('off');
   matlab.video.read.UseHardwareAcceleration('on');
    handles.vobj = VideoReader(handles.filename);
    handles.max_n_frames = handles.vobj.NumberOfFrames;
    handles.movie_length = handles.vobj.NumberOfFrames;
    handles.f_height = handles.vobj.Height;
    handles.f_width = handles.vobj.Width;
    handles.isfmf = 0;
    delete(handles.vobj);
        handles.vobj = VideoReader(handles.filename);


end

handles.binaryImage = zeros(handles.f_height,handles.f_width);
handles.egg_list = {};
handles.inputeggs = varargin{2};

fileID = fopen(handles.inputeggs);

C = textscan(fileID,'%q','delimiter','\r');

cnt = 0;
for i = 1:1:length(C{1,1})
    %handles.fly(i) = str2num(C{1,1}{i}(7));
    test = strsplit(char(C{1,1}(i)),{'[','[',',',' '});
    %str2num(test{2}(4))
    if(~strcmp(test{2},'None'))
        cnt = cnt+1;
        handles.fly(cnt) = str2num(test{2}(4));
        handles.time(cnt) = str2num(cell2mat(test(3)));
        handles.positiony(cnt) = str2num(cell2mat(test(7)));
        handles.positionx(cnt) = str2num(cell2mat(test(8)));
        handles.edited(cnt) = 0;
    end
    
end

%sort eggs
[a b] = sort(handles.time,'ascend');
handles.time = handles.time(b);
handles.positionx = handles.positionx(b);
handles.positiony = handles.positiony(b);
handles.fly = handles.fly(b);
handles.edited = handles.edited(b);


    
handles.egg_array = {};
set(handles.listbox1, 'String', handles.egg_array);
handles.scatter_on = 0;
%handles.first_stamp = stamp;

set(handles.t_slider,'Max',handles.movie_length,'Min',1);
set(handles.t_slider,'SliderStep',[1/(handles.movie_length-1) 50/(handles.movie_length-1)]);
set(handles.t_slider, 'Value', 1);

set(handles.cmap_select, 'String', {'gray','parula','jet','hsv','hot','cool'});
handles.cmap_select.Value = 1;
handles.cmap_options  =  {'gray','parula','jet','hsv','hot','cool','gray'};

set(handles.slidermax,'Max',2^8,'Min',0);
set(handles.slidermax,'SliderStep',[1/(2^8-1) 10/(2^8-1)]);
set(handles.slidermax, 'Value', 2^8);

set(handles.slidermin,'Max',2^8,'Min',0);
set(handles.slidermin,'SliderStep',[1/(2^8-1) 10/(2^8-1)]);
set(handles.slidermin, 'Value', 0);


set(handles.current_t_display, 'String', num2str(ceil(handles.t_slider.Value)));


handles.first_run = 1;

% was having some problems with scroll wheel so disabled for the moment
% set(gcf, 'WindowScrollWheelFcn', {@wheel,handles});
% handles.sliderListener = addlistener(handles.t_slider,'ContinuousValueChange', @(hObject, event) t_slider_Callback(hObject, eventdata, handles));

% Choose default command line output for view_tsstack_egg
handles.output = hObject;

% save the changes to handles
guidata(hObject, handles);

% UIWAIT makes egg_annotator_gui wait for user response (see UIRESUME)
end

% --- Outputs from this function are returned to the command line.
function varargout = egg_annotator_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
warning('on');

%delete(handles.figure1);
end



% --- Executes on slider movement.
function t_slider_Callback(hObject, eventdata, handles)
% hObject    handle to t_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.current_t_display, 'String', num2str(ceil(handles.t_slider.Value)));
guidata(hObject, handles);

populate_graphs(hObject);

end

% --- Executes during object creation, after setting all properties.
function t_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

function populate_graphs(hObject)

handles = guidata(hObject);

if(handles.isfmf == 1)
    plot_movie_fmf(hObject);
end


if(handles.isfmf == 2)
    plot_movie_ufmf(hObject);
end


if(handles.isfmf == 0)
    plot_movie_avi(hObject);
end


end



function plot_movie_fmf(hObject)
handles = guidata(hObject);


fseek(handles.fp,handles.header_size+(ceil(handles.t_slider.Value)-1)*handles.bytes_per_chunk,'bof');
[data, stamp] = fmf_read_frame( handles.fp, handles.f_height, handles.f_width, handles.bytes_per_chunk, handles.data_format );

% need to change this to the stamp correcte for abf start
% set(handles.moviestamp, 'String', num2str(stamp-handles.first_stamp));

vidFrame = double(data) + handles.binaryImage.*2^8;

% Commented from reading avi
% handles.recording.movie1.videoobj.CurrentTime = ceil(handles.t_slider.Value)./handles.recording.movie1.videoobj.FrameRate - 1/handles.recording.movie1.videoobj.FrameRate;
% vidFrame = readFrame(handles.recording.movie1.videoobj);

if(handles.first_run)
    axes(handles.axes2); hold on;
    handles.movie_show = imagesc(flipud(vidFrame));
    axis tight;
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    handles.first_run = 0;
    map = colormap(char(handles.cmap_options(handles.cmap_select.Value)));
    colormap(map);
    set(gca, 'CLim', [handles.slidermin.Value, handles.slidermax.Value]);
else
    axes(handles.axes2); hold on;
    set(handles.movie_show ,'cdata',flipud(vidFrame));
    map = colormap(char(handles.cmap_options(handles.cmap_select.Value)));
    colormap(map);
    set(gca, 'CLim', [handles.slidermin.Value, handles.slidermax.Value]);
end

guidata(hObject, handles);
end


function plot_movie_ufmf(hObject)
handles = guidata(hObject);

[im,header,timestamp,bb,mu] = (ufmf_read_frame(handles.header,ceil(handles.t_slider.Value)));


% need to change this to the stamp correcte for abf start
% set(handles.moviestamp, 'String', num2str(stamp-handles.first_stamp));

vidFrame = double(im) + handles.binaryImage.*2^8;
vidFrame = flipud(vidFrame);
% Commented from reading avi
% handles.recording.movie1.videoobj.CurrentTime = ceil(handles.t_slider.Value)./handles.recording.movie1.videoobj.FrameRate - 1/handles.recording.movie1.videoobj.FrameRate;
% vidFrame = readFrame(handles.recording.movie1.videoobj);

if(handles.first_run)
    axes(handles.axes2); hold on;
    handles.movie_show = imagesc(flipud(vidFrame));
    axis tight;
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    handles.first_run = 0;
    map = colormap(char(handles.cmap_options(handles.cmap_select.Value)));
    colormap(map);
    set(gca, 'CLim', [handles.slidermin.Value, handles.slidermax.Value]);
else
    axes(handles.axes2); hold on;
    set(handles.movie_show ,'cdata',flipud(vidFrame));
    map = colormap(char(handles.cmap_options(handles.cmap_select.Value)));
    colormap(map);
    set(gca, 'CLim', [handles.slidermin.Value, handles.slidermax.Value]);
end

guidata(hObject, handles);
end




function plot_movie_avi(hObject)
handles = guidata(hObject);


handles.vobj.CurrentTime = ceil(handles.t_slider.Value)./handles.vobj.FrameRate - 1/handles.vobj.FrameRate;
vidFrame3 = readFrame(handles.vobj);

vidFrame = double(vidFrame3(:,:,1)) + handles.binaryImage.*2^8;
vidFrame = flipud(vidFrame);


if(handles.first_run)
    axes(handles.axes2); hold on;
    handles.movie_show = imagesc(flipud(vidFrame));
    axis tight;
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    handles.first_run = 0;
    map = colormap(char(handles.cmap_options(handles.cmap_select.Value)));
    colormap(map);
    set(gca, 'CLim', [handles.slidermin.Value, handles.slidermax.Value]);
else
    axes(handles.axes2); hold on;
    set(handles.movie_show ,'cdata',flipud(vidFrame));
    map = colormap(char(handles.cmap_options(handles.cmap_select.Value)));
    colormap(map);
    set(gca, 'CLim', [handles.slidermin.Value, handles.slidermax.Value]);
end


guidata(hObject, handles);
end



% --- Executes on button press in zoomin.
function zoomin_Callback(hObject, eventdata, handles)
% hObject    handle to zoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2); hold on;
zoom on;


end


% --- Executes on button press in zoomoff.
function zoomoff_Callback(hObject, eventdata, handles)
% hObject    handle to zoomoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2); hold on;
zoom off;
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stamp = 1:1:((handles.max_n_frames));

mat_out = [];
max_l = 0;
for i = 1:1:max(handles.fly)
[a b] = find(handles.fly ==i);
max_l = max(max_l,length(b));
end
mat_out = zeros(max_l,max(handles.fly));

for i = 1:1:max(handles.fly)
[a b] = find(handles.fly ==i);
mat_out(1:length(b),i) = handles.time(b);
end

modifiedStr = strrep([handles.inputeggs '_GUIout'], '.', '_');
save(modifiedStr,'mat_out');

    matlab.video.read.UseHardwareAcceleration('on');

set(handles.saving, 'String', 'Done Saving');

end

% --- Executes on button press in add_egg.
function add_egg_Callback(hObject, eventdata, handles)
% hObject    handle to add_egg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.time(end+1) = (ceil(handles.t_slider.Value));
handles.fly(end+1) = handles.currentfly;



[mask_tmpx,mask_tmpy]=ginput(1);



handles.positionx(end+1) = [mask_tmpx];
handles.positiony(end+1) = [mask_tmpy];

handles.edited(end+1) = 1;

  [a b] = find(handles.fly == handles.currentfly);
handles.egg_array = handles.time(b);
set(handles.listbox1, 'String', handles.egg_array);
handles.pointer = b;



if(handles.scatter_on == 1)
    delete(findobj(gca,'type', 'scatter'));
    
    [a b] = find(handles.fly == handles.currentfly);
    handles.scatter = scatter(handles.positionx(b),handles.positiony(b),5,'r');
    [a b] = find((handles.fly == handles.currentfly) & (handles.edited ==1));
    
    handles.scatter3 = scatter(handles.positionx((b)),handles.positiony((b)),5,'b');
    
    if(handles.edited(handles.pointer(handles.list_box_index)))
        handles.scatter2 = scatter(handles.positionx(handles.pointer(handles.list_box_index)),handles.positiony(handles.pointer(handles.list_box_index)),5,'m');
    else
        handles.scatter2 = scatter(handles.positionx(handles.pointer(handles.list_box_index)),handles.positiony(handles.pointer(handles.list_box_index)),5,'g');
        
    end
    
end

guidata(hObject, handles);

end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

contents = cellstr(get(hObject,'String'));
handles.current_select = contents{get(hObject,'Value')};

[~, handles.list_box_index] = ismember(str2num(handles.current_select),handles.egg_array);
set(handles.t_slider, 'Value', (str2num((handles.current_select))));
set(handles.current_t_display, 'String', num2str(ceil(handles.t_slider.Value)));

if(handles.scatter_on == 1)
    delete(findobj(gca,'type', 'scatter'));
    
    [a b] = find(handles.fly == handles.currentfly);
    handles.scatter = scatter(handles.positionx(b),handles.positiony(b),5,'r');
    [a b] = find((handles.fly == handles.currentfly) & (handles.edited ==1));
    
    handles.scatter3 = scatter(handles.positionx((b)),handles.positiony((b)),5,'b');
    
    if(handles.edited(handles.pointer(handles.list_box_index)))
        handles.scatter2 = scatter(handles.positionx(handles.pointer(handles.list_box_index)),handles.positiony(handles.pointer(handles.list_box_index)),5,'m');
    else
        handles.scatter2 = scatter(handles.positionx(handles.pointer(handles.list_box_index)),handles.positiony(handles.pointer(handles.list_box_index)),5,'g');
        
    end
    
end


guidata(hObject, handles);
populate_graphs(hObject);


end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in rem_egg.
function rem_egg_Callback(hObject, eventdata, handles)
% hObject    handle to rem_egg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.time(handles.pointer(handles.list_box_index)) = [];
handles.fly(handles.pointer(handles.list_box_index)) = [];
handles.positionx(handles.pointer(handles.list_box_index)) = [];
handles.positiony(handles.pointer(handles.list_box_index)) = [];
handles.edited(handles.pointer(handles.list_box_index)) = [];


[a b] = find(handles.fly == handles.currentfly);
handles.egg_array = handles.time(b);
set(handles.listbox1, 'String', handles.egg_array);
handles.pointer = b;

guidata(hObject, handles);


end


% --- Executes on slider movement.
function slidermax_Callback(hObject, eventdata, handles)
% hObject    handle to slidermax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
guidata(hObject, handles);

populate_graphs(hObject);

end

% --- Executes during object creation, after setting all properties.
function slidermax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slidermax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

end
% --- Executes on slider movement.
function slidermin_Callback(hObject, eventdata, handles)
% hObject    handle to slidermin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
guidata(hObject, handles);

populate_graphs(hObject);

end

% --- Executes during object creation, after setting all properties.
function slidermin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slidermin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end


% --- Executes on selection change in cmap_select.
function cmap_select_Callback(hObject, eventdata, handles)
% hObject    handle to cmap_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cmap_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cmap_select
guidata(hObject, handles);

populate_graphs(hObject);
end

% --- Executes during object creation, after setting all properties.
function cmap_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmap_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function flynum_Callback(hObject, eventdata, handles)
% hObject    handle to flynum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flynum as text
%        str2double(get(hObject,'String')) returns contents of flynum as a double
handles.currentfly = str2double(get(hObject,'String'));

  [a b] = find(handles.fly == handles.currentfly);
handles.egg_array = handles.time(b);
set(handles.listbox1, 'String', handles.egg_array);
handles.pointer = b;

guidata(hObject, handles);

end
% --- Executes during object creation, after setting all properties.
function flynum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flynum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in editegg.
function editegg_Callback(hObject, eventdata, handles)
% hObject    handle to editegg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.time(handles.pointer(handles.list_box_index)) = ceil(handles.t_slider.Value);
handles.edited(handles.pointer(handles.list_box_index)) = 1;

  [a b] = find(handles.fly == handles.currentfly);
handles.egg_array = handles.time(b);
set(handles.listbox1, 'String', handles.egg_array);
handles.pointer = b;

guidata(hObject, handles);


end

% --- Executes on button press in scattereggs.
function scattereggs_Callback(hObject, eventdata, handles)
% hObject    handle to scattereggs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.scatter_on == 0)
    [a b] = find(handles.fly == handles.currentfly);
    handles.scatter = scatter(handles.positionx(b),handles.positiony(b),5,'r');
    
    [a b] = find((handles.fly == handles.currentfly) & (handles.edited ==1));
    handles.scatter3 = scatter(handles.positionx((b)),handles.positiony((b)),5,'b');
       
    if(handles.edited(handles.pointer(handles.list_box_index)))
        handles.scatter2 = scatter(handles.positionx(handles.pointer(handles.list_box_index)),handles.positiony(handles.pointer(handles.list_box_index)),5,'m');
    else
        handles.scatter2 = scatter(handles.positionx(handles.pointer(handles.list_box_index)),handles.positiony(handles.pointer(handles.list_box_index)),5,'g');
        
    end

    handles.scatter_on = 1;
else
delete(findobj(gca,'type', 'scatter'));

    handles.scatter_on = 0;
end
guidata(hObject, handles);
end


% --- Executes on button press in clearaxis.
function clearaxis_Callback(hObject, eventdata, handles)
% hObject    handle to clearaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(findobj(gca,'type', 'scatter'));

end