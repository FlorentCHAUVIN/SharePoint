#Set variable
$ListName = "ListName"
$NewListURL = "ListNewURIPath"

#Get the List
$List= Get-PnPList -Identity $ListName -Includes RootFolder
 
#sharepoint online powershell change list url
$List.Rootfolder.MoveTo($NewListURL)
Invoke-PnPQuery