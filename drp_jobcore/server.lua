local playersJob = {}
---------------------------------------------------------------------------
-- Job Core Events (DO NOT TOUCH!)
---------------------------------------------------------------------------
RegisterServerEvent("DRP_JobCore:StartUp")
AddEventHandler("DRP_JobCore:StartUp", function()
    local src = source
    table.insert(playersJob, {source = src, job = "UNEMPLOYED", jobLabel = "Unemployed"})
end)
---------------------------------------------------------------------------
AddEventHandler("playerDropped", function()
    local src = source
    for a = 1, #playersJob do
        if playersJob[a].source == src then
            table.remove(playersJob, a)
            break
        end
    end
end)
---------------------------------------------------------------------------
-- Job Command
---------------------------------------------------------------------------
RegisterCommand("job", function(source, args, raw)
    local src = source
    local myJob = GetPlayerJob(src)
    TriggerClientEvent("DRP_Core:Info", src, "Job Manager", tostring("Your job is "..myJob.jobLabel..""), 2500, false, "leftCenter")
end, false)
---------------------------------------------------------------------------
-- Add Salary To Character
---------------------------------------------------------------------------
RegisterServerEvent("DRP_JobCore:Salary")
AddEventHandler("DRP_JobCore:Salary", function()
    local src = source
    TriggerEvent("DRP_Bank:AddBankMoney", src, JobsCoreConfig.SalaryAmount)
end)
---------------------------------------------------------------------------
-- Core Functions
---------------------------------------------------------------------------
function GetPlayerJob(player)
    for a = 1, #playersJob do
        if playersJob[a].source == player then
            return playersJob[a]
        end
    end
    return false
end

function RequestJobChange(source, job, label, otherData) -- USE THIS ALL THE TIME
    local currentJob = GetPlayerJob(source)
    local label = label
    if currentJob.job == job then
        TriggerClientEvent("DRP_Core:Error", source, "Job Manager", tostring("You're already working"), 2500, false, "leftCenter")
    else
        if not job and not label and not otherData then
            if currentJob.job == "UNEMPLOYED" then
                TriggerClientEvent("DRP_Core:Error", source, "Job Manager", tostring("You're already not working"), 2500, false, "leftCenter")
            else
                SetPlayerJob(source, "UNEMPLOYED", "Unemployed", false)
                TriggerClientEvent("DRP_Core:Info", source, "Job Manager", tostring("You are now not working"), 2500, false, "leftCenter")
            end
        else
            if DoesJobExist(job) then
                SetPlayerJob(source, job, label, false)
                TriggerClientEvent("DRP_Core:Info", source, "Job Manager", tostring("You are now "..label), 2500, false, "leftCenter")
            else
                print("Job Does Not Exist, Make sure your Server Developer has added job name into drp_jobcore/config.lua")
            end
        end
    end
end
---------------------------------------------------------------------------
function DoesJobExist(job)
    for a = 1, #JobsCoreConfig.Jobs do
        if JobsCoreConfig.Jobs[a] == job then
            return true
        end
    end
    return false
end
---------------------------------------------------------------------------
function SetPlayerJob(player, job, label, otherData)
    for a = 1, #playersJob do
        if playersJob[a].source == player then
            playersJob[a].job = job
            playersJob[a].jobLabel = label
            playersJob[a].otherJobData = otherData
            break
        end
    end
end
---------------------------------------------------------------------------
