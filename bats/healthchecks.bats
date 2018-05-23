#!/usr/bin/env bats

@test "[INFRA-6245] [nutcracker] Check nutcracker configuration" {
    /usr/sbin/nutcracker --test-conf -c /opt/nutcracker.yml
}

@test "[INFRA-6245] [nc] Test memcache port" {
    run nc -zv localhost 11211
    [ "$status" -eq 0 ]
    [[ "$output"  == *"open"* ]]
}

@test "[INFRA-6245] [nutcracker] Check nutcracker version" {
    run /usr/sbin/nutcracker --version
    [ "$status" -eq 0 ]
    [[ "$output"  == *"This is nutcracker-0.4.1"* ]]
}

