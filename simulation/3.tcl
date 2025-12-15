# Create simulator
set ns [new Simulator]

# Trace files
set tf [open out.tr w]
$ns trace-all $tf

# Number of LAN nodes
set n 6

# Create nodes
for {set i 0} {$i < $n} {incr i} {
    set node($i) [$ns node]
}

# Create Ethernet LAN
set lan [$ns make-lan \
    "$node(0) $node(1) $node(2) $node(3) $node(4) $node(5)" \
    10Mb 10ms LL Queue/DropTail Mac/802_3]

# ---------------- TCP FLOW 1 ----------------
set tcp1 [new Agent/TCP]
$tcp1 set class_ 1
$ns attach-agent $node(0) $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $node(3) $sink1

$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

# Trace cwnd for flow 1
set cwnd1 [open cwnd1.tr w]
$tcp1 trace cwnd_
$tcp1 attach $cwnd1

# ---------------- TCP FLOW 2 ----------------
set tcp2 [new Agent/TCP]
$tcp2 set class_ 2
$ns attach-agent $node(1) $tcp2

set sink2 [new Agent/TCPSink]
$ns attach-agent $node(4) $sink2

$ns connect $tcp2 $sink2

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

# Trace cwnd for flow 2
set cwnd2 [open cwnd2.tr w]
$tcp2 trace cwnd_
$tcp2 attach $cwnd2

# Start and stop traffic
$ns at 1.0 "$ftp1 start"
$ns at 2.0 "$ftp2 start"

$ns at 8.0 "$ftp1 stop"
$ns at 8.0 "$ftp2 stop"

# Finish procedure
proc finish {} {
    global ns tf cwnd1 cwnd2
    $ns flush-trace
    close $tf
    close $cwnd1
    close $cwnd2
    exit 0
}

$ns at 9.0 "finish"

# Run simulation
$ns run
