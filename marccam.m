 function varargout = marccam(varargin)
% MARCCAM is a program written by Marc Davis inspired by EDCAM by Edward
% Marti.  My email is marc.davis@berkeley.edu.


% MARCCAM MATLAB code for marccam.fig
%      MARCCAM, by itself, creates a new MARCCAM instance.
%
%      H = MARCCAM returns the handle to a new MARCCAM instance.
%
%      MARCCAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MARCCAM.M with the given input arguments.
%
%      MARCCAM('Property','Value',...) creates a new MARCCAM.  Starting 
%      from the left, property value pairs are
%      applied to the GUI before marccam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to marccam_OpeningFcn via varargin.
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help marccam

% Last Modified by GUIDE v2.5 13-Jul-2016 14:58:19

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 0;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @marccam_OpeningFcn, ...
                       'gui_OutputFcn',  @marccam_OutputFcn, ...
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
    % End initialization code - DO NOT EDIT
 end

% Suppress "Function unused" warnings.  GUIDE callback code often has these
% warning.
%#ok<*DEFNU>

% --- Executes just before marccam is made visible.
function marccam_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to marccam (see VARARGIN)

% Choose default command line output for marccam
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes marccam wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = marccam_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on selection change in cameramenu.
function cameramenu_Callback(hObject, ~, handles)
% hObject    handle to cameramenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cameramenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cameramenu
    minstance = MarcCamInstance.instanceForFigure(get(hObject, 'parent'));
    if isempty(minstance.mainDisplayAxes)
       minstance.mainDisplayAxes = handles.mainDisplay;
       minstance.fitXAxes = handles.fitX;
       minstance.fitYAxes = handles.fitY;
    end
    i = get(hObject, 'Value');
    if i == 1
        % The default "Select Camera" is selected (no camera is selected)
        minstance.switchCamera(Cam.nullCam);
        handles.statusText.String = 'No Camera';
    else
        minstance.statusText = handles.statusText;
        minstance.switchCamera(minstance.cameras{i - 1});
    end
    minstance.updateImageOutput();
    disp(minstance.currentCamera)
end

% --- Executes during object creation, after setting all properties.
function cameramenu_CreateFcn(hObject, ~, ~)
% hObject    handle to cameramenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    cameratypes = {'Select Camera'};
    minstance = MarcCamInstance.instanceForFigure(get(hObject, 'parent'));
    for cam = minstance.cameras
        c = cam{1};
        name = c.DeviceName;
        cID = c.serialNumber;
        %cameratypes = sprintf('%s\n%s %d', cameratypes, name, cID);
        cameratypes = [cameratypes sprintf('%s %d', name, cID)];
    end
    hObject.String = cameratypes;
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)'
    MarcCamInstance.removeInstance(hObject);
end


% --- Executes on button press in takePictureButton.
function takePictureButton_Callback(hObject, ~, ~)
% hObject    handle to takePictureButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    figg = get(hObject, 'parent');
    minstance = MarcCamInstance.instanceForFigure(figg);
    minstance.updateImageOutput();
end


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, ~, ~)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    figg = get(hObject, 'parent');
    minstance = MarcCamInstance.instanceForFigure(figg);
    minstance.currentCamera.startRecording();
    %camear = minstance.
end

% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, ~, ~)
% hObject    handle to stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    figg = get(hObject, 'parent');
    minstance = MarcCamInstance.instanceForFigure(figg);
    minstance.currentCamera.stopRecording();
end


% --- Executes on selection change in fittype.
function fittype_Callback(hObject, ~, ~)
% hObject    handle to fittype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fittype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fittype
    figg = get(hObject, 'parent');
    minstance = MarcCamInstance.instanceForFigure(figg);
    i = get(hObject, 'Value');
    contents = cellstr(get(hObject, 'String'));
    minstance.changeFitType(contents{i});
    minstance.redrawPlots();
end
% --- Executes during object creation, after setting all properties.
function fittype_CreateFcn(hObject, ~, ~)
% hObject    handle to fittype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on selection change in numouts.
function numouts_Callback(hObject, ~, ~)
% hObject    handle to numouts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns numouts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from numouts
    %items = get(hObject,'String');
    index_selected = get(hObject,'Value');
    %item_selected = items{index_selected};
    %display(item_selected);
    
    figg = get(hObject, 'parent');
    minstance = MarcCamInstance.instanceForFigure(figg);
    minstance.changeSelectedData(index_selected);
end
% --- Executes during object creation, after setting all properties.
function numouts_CreateFcn(hObject, ~, ~)
% hObject    handle to numouts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    figg = get(hObject, 'parent');
    minstance = MarcCamInstance.instanceForFigure(figg);
    minstance.numouts = hObject;
end


% --- Executes on selection change in detailOutput.
function detailOutput_Callback(~, ~, ~)
% hObject    handle to detailOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns detailOutput contents as cell array
%        contents{get(hObject,'Value')} returns selected item from detailOutput

end
% --- Executes during object creation, after setting all properties.
function detailOutput_CreateFcn(hObject, ~, ~)
% hObject    handle to detailOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    figg = get(hObject, 'parent');
    minstance = MarcCamInstance.instanceForFigure(figg);
    minstance.detailouts = hObject;
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(~, ~, ~)
    % hObject    handle to figure1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
end


% --- Executes on selection change in vidmenu.
function vidmenu_Callback(hObject, ~, ~)
    % hObject    handle to vidmenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns vidmenu contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from vidmenu
    figg = get(hObject, 'parent');
    minstance = MarcCamInstance.instanceForFigure(figg);
    i = get(hObject, 'Value');
    contents = cellstr(get(hObject, 'String'));
    minstance.changeVidType(contents{i});
end

% --- Executes during object creation, after setting all properties.
function vidmenu_CreateFcn(hObject, ~, ~)
    % hObject    handle to vidmenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
