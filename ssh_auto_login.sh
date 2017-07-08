#!/usr/bin/expect
spawn /usr/bin/ssh root@10.10.10.0
expect "*password:"
send "123456\r"
interact
