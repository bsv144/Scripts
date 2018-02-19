workflow wftest_connection 
{
    param(
        [string[]]$COMPUTERNAME
    )
    foreach -parallel ($pc in $list_pc)
    {
        $tc = Test-Connection -ComputerName $pc -Quiet
        InlineScript
        {
            Write-Host "$Using:pc -> $Using:tc"
        }
    }
}