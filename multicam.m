function varargout = multicam(varargin)
% MULTICAM MATLAB code for multicam.fig
%      MULTICAM, by itself, creates a new MULTICAM or raises the existing
%      singleton*.
%
%      H = MULTICAM returns the handle to a new MULTICAM or the handle to
%      the existing singleton*.
%
%      MULTICAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTICAM.M with the given input arguments.
%
%      MULTICAM('Property','Value',...) creates a new MULTICAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multicam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to multicam_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help multicam

% Last Modified by GUIDE v2.5 01-Jun-2016 15:43:46

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 0;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @multicam_OpeningFcn, ...
                       'gui_OutputFcn',  @multicam_OutputFcn, ...
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


% --- Executes just before multicam is made visible.
function multicam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multicam (see VARARGIN)

% Choose default command line output for multicam
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes multicam wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = multicam_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on selection change in cameramenu.
function cameramenu_Callback(hObject, eventdata, handles)
% hObject    handle to cameramenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cameramenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cameramenu
    minstance = MulticamInstance.instanceForFigure(get(hObject, 'parent'));
    fprintf('Multicam Instance #: %d\n', minstance.numID)
end
% --- Executes during object creation, after setting all properties.
function cameramenu_CreateFcn(hObject, ~, ~)
% hObject    handle to cameramenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    cameratypes = 'Select Camera';
    for cam = Cam.listCameras
        c = cam;
        name = c.DeviceName;
        cID = c.DeviceID;
        cameratypes = sprintf('%s\n%s %d', cameratypes, name, cID);
    end
    hObject.String = cameratypes;
    MulticamInstance.instanceForFigure(get(hObject, 'parent'));
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
