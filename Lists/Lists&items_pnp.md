**Vous trouverez dans cette page quelques exemples de manipulation des lists et des élements avec Powershell PnP sur les vues**

- [Modifier l'url d'un liste](#modifier-lurl-dun-liste)
- [Requête en dynamique en CAML sur les élements d'une bibliothèque et ajout de permission sur les éléments](#requête-en-dynamique-en-caml-sur-les-élements-dune-bibliothèque-et-ajout-de-permission-sur-les-éléments)
- [Suppression en masse d'élements dans une liste](#suppression-en-masse-délements-dans-une-liste)


# Modifier l'url d'un liste

Il arrive souvent de devoir renommer une liste mais jusqu'à maintenant cela n'avait d'impact que sur le nom d'affichage et ne modifiait par le nom de la bibliothèque ou de la liste au niveau de l'url.

Pour effectuer le renommage au niveau de l'url nous pouvons utiliser les commande suivantes, attention de bien évaluer l'impact du renommage si la liste ou la bibliothèque était déjà en cours d'utilisation :

    #Set variable
    $SiteURL = "YourSharePointOnlineSiteUrL"
    $ListName = "ListName"
    $NewListURL = "ListNewURIPath" # Il s'agit du nouveau nom de la liste ou bibliothèque dans l'url, pas de l'url complète

    #Connect to Tenant and site
    Connect-PnPOnline -url $SiteURL -Interactive

    #Get the List
    $List= Get-PnPList -Identity $ListName -Includes RootFolder
    
    #sharepoint online powershell change list url
    $List.Rootfolder.MoveTo($NewListURL)
    Invoke-PnPQuery

Ces commandes sont issues de l'excellente site SharePoint Diary qui est une vrai bible sur le scripting SharePoint : https://www.sharepointdiary.com/2017/09/sharepoint-online-change-list-document-library-url-using-powershell.html#ixzz6L73Zswqi


# Requête en dynamique en CAML sur les élements d'une bibliothèque et ajout de permission sur les éléments

Dans cette exemple j'avais besoin de sécuriser les fichiers d'une biblitohèque en fonction de la société auquels les documents sont rattachés.

J'ai ici une liste référentiel des sociétés dont j'ai chargé les élements dans une variable $entity.
Le code de référence de chaque société fait partie des propriétés de ce référentiel (Propriété Entity) et nous allons l'utiliser après l'avoir convertie en string pour rechercher les documents dont le nom commencent par ce code (Requète CAML).
Puis pour chaque élements nous réinitialiserons et appliquerons les permissions nécessaires dont celles relatives à la société via le groupe de sécurité portant le code de la société. 

    $entity | Foreach-objet{
        $EntityCode=$_.Entity.toString();
        $ListItems = $null;
        $ListItems = Get-PnPListItem -List "Entities documents"  -Query "<View><Query><Where><BeginsWith><FieldRef Name='FileLeafRef'/><Value Type='text'>$EntityCode</Value></BeginsWith></Where></Query></View>";
        $ListItems | Foreach-Object{
            Set-PnPListItemPermission -List "Entities documents" -Identity $_ -Group "Entity - 38" -AddRole 'Contrôle total' -SystemUpdate -ClearExisting;Set-PnPListItemPermission -List "Entities documents" -Identity $_ -Group "Entity - $EntityCode" -AddRole 'Lecture' -SystemUpdate;
            Set-PnPListItemPermission -List "Entities documents" -Identity $_ -Group "Propriétaires de Entities Groupe" -AddRole 'Contrôle total' -SystemUpdate
            }
        }



# Suppression en masse d'élements dans une liste

Lors de nos tests de développement d'une solution nous devons parfois faire le vide dans une lsite et supprimer tous ces élements.
J'utilise pour cela le script trouvé sur Internet qui permet de bypasser le problème du nombre d'élements affichables dans une vue (5000).

    Get-PnPList -Identity "MyListIdOrName" | Get-PnPListItem -PageSize 100 -ScriptBlock { Param($items) 
    $items.Context.ExecuteQuery() } | Foreach-Objet {$_.DeleteObject()}

Cette méthode est beaucoup plus rapide que l'utilisation classique de la cmdlet Remove-PnPListItem (x7).
Si vous souhaitez quand même utiliser la cmdlet Remove-PnPListItem tout ayant les mêmes performances, il faut alors l'inclure dans un batch (PnP-Batch).

Vous pouvez consulter l'exemple 3 de la documentation Microsoft pour l'utilisation de PnP-Batch : https://docs.microsoft.com/en-us/powershell/module/sharepoint-pnp/remove-pnplistitem?view=sharepoint-ps
