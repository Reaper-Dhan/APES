set ns [new Simulator]

set nf [open exp2.nam w]
$ns namtrace-all $nf

set nt [open exp2.tr w]
$ns trace-all $nt

proc finish {} {
	global ns nf nt
	$ns flush-trace
	close $nf
	close $nt
	exec nam exp2.nam &
	exec awk -f exp2.awk exp2.tr &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n3 $n2 10Mb 10ms DropTail
 
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n3 $n2 orient left

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $usp $null

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb


$ns at 1.0 "$cbr start"
$ns at 2.0 "$cbr stop"

$ns at 5.0 "finish"

$ns run
