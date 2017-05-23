#!/bin/bash

XML_FILES=/opt/testset
XTST_JAR_FILE=/opt/XTST/XTST.jar
XSL_DIR=/opt/si-ubl

usage()
{
    cat << EOF
    usage: $0 options

    OPTIONS:
       -u      SI-UBL version to use (xsl version)
       -t      testset version to use
       -v      verbose output
       -q      Quit on error
       -h      Show this message
EOF
}

#defaults
QUIT='0';
VERBOSE=0;
SI_UBL_VERSION=
TESTSET_SI_UBL_VERSION=

# :v --> : charater indicates a required field
while getopts "qu:t:" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        v)
            VERBOSE=1
            ;;
        q)
            QUIT='1'
            ;;
        t)
            TESTSET_SI_UBL_VERSION=$OPTARG
            ;;
        u)
            SI_UBL_VERSION=$OPTARG
            ;;
        ?)
            usage
            exit
            ;;
    esac
done


if [[ -z $TESTSET_SI_UBL_VERSION ]] ; then
    usage
    exit 1
fi

if [[ -z $SI_UBL_VERSION ]] ; then
    usage
    exit 1
fi



function do_cmd {
    echo $@
    $@
}

function do_check {
if [ $1 -eq 0 ] ; then
    echo "[ok] $2"
else  
    echo "[ERROR] $2"
    if [ $QUIT -eq 1 ] ; then
        echo java -jar $XTST_JAR_FILE -f $i $XSL_DIR/SI-UBL-$SI_UBL_VERSION.xsl /opt/xsd/UBL-Order-2.1.xsd   
        exit 1 
    fi
fi 
}

function do_check_inverse {
if [ $1 -eq 1 ] ; then
    echo "[ok] $2"
else 
    echo "[ERROR] $2"
    if [ $QUIT -eq 1 ] ; then
        echo "This command failed: java -jar $XTST_JAR_FILE -f $i $XSL_FILE /opt/xsd/maindoc/UBL-Invoice-2.1.xsd" 
        exit 1 
    fi
fi 
}


#################################################################
# Scan testset for file with ok,warning and error and process them. 
# if the output contains validation failures this is either nok (for valid SI-UBL documents)
# or ok (for warnings and errors)
# LATER: check weither the exepcted rule is executed or not.

if  [ $TESTSET_SI_UBL_VERSION = 1.1 ]; then
    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-$TESTSET_SI_UBL_VERSION-ok-*.xml; do
        do_cmd java -jar $XTST_JAR_FILE -f $i $XSL_DIR/SI-UBL-INV-$SI_UBL_VERSION.xsl /opt/xsd/maindoc/UBL-Invoice-2.1.xsd  | grep fail
        # grep fails when not found. so 1=ok 0=nok
        do_check_inverse $? $i
    done
    
    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-$TESTSET_SI_UBL_VERSION-warning-*.xml; do
        do_cmd java -jar $XTST_JAR_FILE -f $i $XSL_DIR/SI-UBL-INV-$SI_UBL_VERSION.xsl  | grep flag=\"warnin\"
        # grep fails when not found. so 0=ok 1=nok
        do_check $? $i
    done

    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-$TESTSET_SI_UBL_VERSION-error-*.xml; do
        do_cmd java -jar $XTST_JAR_FILE -f $i $XSL_DIR/SI-UBL-INV-$SI_UBL_VERSION.xsl | grep fail
        # grep fails when not found. so 0=ok 1=nok
       do_check $? $i
    done
fi

if  [ $TESTSET_SI_UBL_VERSION = 1.2 ]; then
    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-INV-$TESTSET_SI_UBL_VERSION-ok-*.xml; do
        do_cmd java -jar $XTST_JAR_FILE -f $i $XSL_DIR/SI-UBL-INV-$SI_UBL_VERSION.xsl /opt/xsd/maindoc/UBL-Invoice-2.1.xsd  | grep fail
        # grep fails when not found. so 1=ok 0=nok
        do_check_inverse $? $i
    done

    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-INV-$TESTSET_SI_UBL_VERSION-error-*.xml; do
        do_cmd java -jar $XTST_JAR_FILE -f $i $XSL_DIR/SI-UBL-INV-$SI_UBL_VERSION.xsl | grep fail
        # grep fails when not found. so 0=ok 1=nok
       do_check $? $i
    done

    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-PO-$TESTSET_SI_UBL_VERSION-ok-*.xml; do
        do_cmd java -jar $XTST_JAR_FILE -f $i $XSL_DIR/SI-UBL-PO-$SI_UBL_VERSION.xsl /opt/xsd/maindoc/UBL-Invoice-2.1.xsd  | grep fail
        # grep fails when not found. so 1=ok 0=nok
        do_check_inverse $? $i
    done

    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-PO-$TESTSET_SI_UBL_VERSION-error-*.xml; do
        do_cmd java -jar $XTST_JAR_FILE -f $i $XSL_DIR/SI-UBL-PO-$SI_UBL_VERSION.xsl | grep fail
        # grep fails when not found. so 0=ok 1=nok
       do_check $? $i
    done
fi


