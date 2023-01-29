$apikey='9C87ROI38H4WMLLG77CUHCS79UX9VLEN'

#https://eu.rconsumerelectronics.xyz/

$today=get-date -Format 'yyyy-MM-dd'
$startday=$today
#$startday='2020-03-22'
$month=get-date -UFormat %m
$year=get-date -Uformat %Y
$day=get-date -Uformat %d
$daysinmonth=[datetime]::DaysInMonth($year,$month)


$target_production=@{}
$target_production.add(01,197)
$target_production.add(02,252)
$target_production.add(03,474)
$target_production.add(04,692)
$target_production.add(05,766)
$target_production.add(06,782)
$target_production.add(07,785)
$target_production.add(08,695)
$target_production.add(09,569)
$target_production.add(10,434)
$target_production.add(11,239)
$target_production.add(12,159)

$siteid='1389669'
$target_this_month=$target_production[[int]$month]


$url="https://monitoringapi.solaredge.com/site/$siteid/overview.json?api_key=$apikey"
$res=Invoke-RestMethod $url
$lastupdate=[datetime]$res.overview.lastUpdateTime 
$currpower=$res.overview.currentPower.power
$currpower=[math]::round($currpower)
$dayenergy=$res.overview.lastDayData.energy / 1000
$monthenergy=$res.overview.lastMonthData.energy / 1000
$lifetimeenergy=$res.overview.lifetimedata.energy / 1000
$monthenergy_percent_target=$monthenergy / $target_this_month
$percent_target_today = $day / $daysinmonth

#$dayenergy=[math]::round($dayenergy/1000)


$url="https://monitoringapi.solaredge.com/site/$siteid/timeFrameEnergy?startDate=2022-06-04&endDate=$today&api_key=$apikey"
$res=Invoke-RestMethod $url
$billingperiod=$res.timeFrameEnergy.energy / 1000


#$url="https://monitoringapi.solaredge.com/site/$siteid/energy?timeUnit=MONTH&endDate=2020-03-31&startDate=2019-12-01&api_key=$apikey"
<#
$url="https://monitoringapi.solaredge.com/site/$siteid/energy?timeUnit=QUARTER_OF_AN_HOUR&endDate=$today&startDate=$startday&api_key=$apikey"
$url="https://monitoringapi.solaredge.com/site/$siteid/timeFrameEnergy?startDate=2020-05-01&endDate=2013-05-06&api_key=L4QLVQ1LOKCQX2193VSEICXW61NP6B1O
$res=Invoke-RestMethod $url
$i=0;
foreach ($val in $res.energy.values)
{
    $i++
    if ($val.value) {write-host $i $val.date $val.value}
}

#>
#$res.energy.values | Out-GridView



$strout=  "Power: $lastupdate "+ $currpower.tostring("N0") +"W"
write-host $strout
$strout="Dag: $dayenergy"+"Kwh"
write-host $strout
$strout= "Maand: $monthenergy"+"Kwh from $target_this_month (" + $monthenergy_percent_target.ToString("P") +" at " + $percent_target_today.ToString("P") +" progress in month)"
write-host $strout
$strout=  "BillinperiodEnergy: " +$billingperiod.tostring("N2") + "kW"
write-host $strout
$strout=  "LifetimeEnergy: " +$lifetimeenergy.tostring("N2") + "kW"
write-host $strout


