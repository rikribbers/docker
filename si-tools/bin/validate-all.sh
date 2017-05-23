#!/bin/bash

function do_cmd {
    echo $@
    if [ $1 neq 0 ] ; then
      exit 1
    fi
}

CMD=/opt/si-ubl/validation.sh 
# this is the test matrix

#v1.0
#do_cmd $CMD -q -u 1.0 -t 1.0

#v1.1
do_cmd $CMD -q -u 1.1 -t 1.0
do_cmd $CMD -q -u 1.1 -t 1.1

#v1.2
do_cmd $CMD -q -u 1.2 -t 1.0
do_cmd $CMD -q -u 1.2 -t 1.1
do_cmd $CMD -q -u 1.2 -t 1.1