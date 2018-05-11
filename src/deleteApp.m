function [] = deleteApp(Obj)

%delete specified folders from path
for Increment=1:length(Obj.Folders)
    rmpath([pwd,Obj.Slash,Obj.Folders{Increment}]);
end
end