local tbBulkEntry = GameMain:GetMod("BulkEntry")
local agent = nil

function tbBulkEntry:OnBeforeInit()
    print("BulkEntry BeforeInit")
    
    if agent == nil then
        local mod = CS.ModsMgr.Instance:FindMod("BookSearch", "", true)
        if mod and mod.Path then
            -- 使用平台兼容的路径拼接
            local pathSeparator = package.config:sub(1,1) -- 获取平台路径分隔符
            local dllPath = mod.Path .. pathSeparator .. "Library" .. pathSeparator .. "BulkEntry.dll"
            
            -- iOS兼容性检查
            if SystemInfo.get_platform() == RuntimePlatform.IPhonePlayer then
                -- iOS可能需要不同的加载方式
                dllPath = mod.Path .. "/Library/BulkEntry.dll"
            end
            
            -- 安全检查文件是否存在
            if CS.System.IO.File.Exists(dllPath) then
                local assembly = CS.System.Reflection.Assembly.LoadFrom(dllPath)
                if assembly then
                    local type = assembly:GetType("BulkEntry.Agent")
                    if type then
                        agent = CS.System.Activator.CreateInstance(type)
                        print("BulkEntry load_assembly successfully")
                    else
                        print("BulkEntry type not found")
                    end
                else
                    print("BulkEntry assembly load failed")
                end
            else
                print("BulkEntry DLL not found: " .. dllPath)
            end
        else
            print("BulkEntry mod not found")
        end
    end
end

function tbBulkEntry:OnEnter()
    if agent ~= nil then
        agent:Enter()
    end
end

function tbBulkEntry:OnClick(building, type)
    if agent ~= nil then
        agent:OnClick(building, type)
    end
end
