#Set variable
$SiteURL = "YourSharePointOnlineSiteUrL"
$ListName = "ListName"
$NewListURL = "ListNewURIPath"

#Connect to Tenant and site
Connect-PnPOnline -url $SiteURL -Interactive

#Get the List
$List= Get-PnPList -Identity $ListName -Includes RootFolder
 
#sharepoint online powershell change list url
$List.Rootfolder.MoveTo($NewListURL)
Invoke-PnPQuery