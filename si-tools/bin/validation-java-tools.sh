#!/bin/bash

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
        echo "This command failed."
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
        echo "This command failed."
        exit 1 
    fi
fi 
}

QUIT=1
TESTSET_SI_UBL_VERSION=1.1
SI_UBL_VERSION=1.1
XML_FILES=/opt/testset
XSL_DIR=/opt/si-ubl

if  [ $TESTSET_SI_UBL_VERSION = 1.1 ]; then
    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-$TESTSET_SI_UBL_VERSION-ok-*.xml; do
        do_cmd java -cp /opt/java-tools/en16931-xml-validator.jar eu.cen.en16931.xmlvalidator.XMLValidator \
         -xml $i -xslt $XSL_DIR/SI-UBL-INV-$SI_UBL_VERSION.xsl
         cat result.svrl  | grep fail
        # grep fails when not found. so 1=ok 0=nok
        do_check_inverse $? $i
    done
    
    # for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-$TESTSET_SI_UBL_VERSION-warning-*.xml; do
    #     do_cmd java -cp /opt/java-tools/en16931-xml-validator.jar eu.cen.en16931.xmlvalidator.XMLValidator \
    #      -xml $i -xslt $XSL_DIR/SI-UBL-INV-$SI_UBL_VERSION.xsl
    #     cat result.svrl  | grep flag=\"warnin\"
    #     # grep fails when not found. so 0=ok 1=nok
    #     do_check $? $i
    # done

    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-$TESTSET_SI_UBL_VERSION-error-*.xml; do
        do_cmd java -cp /opt/java-tools/en16931-xml-validator.jar eu.cen.en16931.xmlvalidator.XMLValidator \
         -xml $i -xslt $XSL_DIR/SI-UBL-INV-$SI_UBL_VERSION.xsl
         cat result.svrl  | grep fail
        # grep fails when not found. so 0=ok 1=nok
       do_check $? $i
    done
fi

if  [ $TESTSET_SI_UBL_VERSION = 1.2 ]; then
    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-INV-$TESTSET_SI_UBL_VERSION-ok-*.xml; do
        do_cmd java -cp /opt/java-tools/en16931-xml-validator.jar eu.cen.en16931.xmlvalidator.XMLValidator \
         -xml $i -xslt $XSL_DIR/SI-UBL-INV-$SI_UBL_VERSION.xsl
         cat result.svrl  | grep fail
        # grep fails when not found. so 1=ok 0=nok
        do_check_inverse $? $i
    done

    for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-INV-$TESTSET_SI_UBL_VERSION-error-*.xml; do
        do_cmd java -cp /opt/java-tools/en16931-xml-validator.jar eu.cen.en16931.xmlvalidator.XMLValidator \
         -xml $i -xslt $XSL_DIR/SI-UBL-INV-$SI_UBL_VERSION.xsl
         cat result.svrl  | grep fail
              # grep fails when not found. so 0=ok 1=nok
       do_check $? $i
    done

    # for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-PO-$TESTSET_SI_UBL_VERSION-ok-*.xml; do
    #     do_cmd java -jar $XTST_JAR_FILE -f $i $XSL_DIR/SI-UBL-PO-$SI_UBL_VERSION.xsl /opt/xsd/maindoc/UBL-Invoice-2.1.xsd  | grep fail
    #     # grep fails when not found. so 1=ok 0=nok
    #     do_check_inverse $? $i
    # done

    # for i in $XML_FILES/SI-UBL-$TESTSET_SI_UBL_VERSION/SI-UBL-PO-$TESTSET_SI_UBL_VERSION-error-*.xml; do
    #     do_cmd java -jar $XTST_JAR_FILE -f $i $XSL_DIR/SI-UBL-PO-$SI_UBL_VERSION.xsl | grep fail
    #     # grep fails when not found. so 0=ok 1=nok
    #    do_check $? $i
    # done
fi


