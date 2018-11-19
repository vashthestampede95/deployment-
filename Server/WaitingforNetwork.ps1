cd /home/dmrc/VDU/
if[-f /tmp/.hascats.pid];then
function wait-for-network ($tries) {
        while (1) {
		# Get a list of DHCP-enabled interfaces that have a 
		# non-$null DefaultIPGateway property.
                $x = gwmi -class Win32_NetworkAdapterConfiguration `
                        -filter DHCPEnabled=TRUE |
                                where { $_.DefaultIPGateway -ne $null }

		# If there is (at least) one available, exit the loop.
                if ( ($x | measure).count -gt 0 ) {
                        break
                }

		# If $tries > 0 and we have tried $tries times without
		# success, throw an exception.
                if ( $tries -gt 0 -and $try++ -ge $tries ) {
                        throw "Network unavaiable after $try tries."
                }

		# Wait one second.
                start-sleep -s 1
        }
}
else 
{
exit 1
}
fi
