#!/bin/sh

if [ `id -u` = "0" ]
then
    INSTALLDIR="/usr/local/share/muc"

else
    INSTALLDIR="$HOME/.muc"
fi

GETNAME="grep \"Name: \" .mucfile | sed -e \"s/.*:\s//g\""
GETCMD="grep \"Command: \" .mucfile | sed -e \"s/.*:\s//g\""


if [ "$1" = "install" ]
then
    if [ -z $2 ]
    then
        printf "Usage $0 install package.tar.gz\n"
        exit 1
    else
        if [ ! -d "$INSTALLDIR" ]
        then
            printf "Creating install dir...\n"
            mkdir -p $INSTALLDIR
        fi
        printf "Installing...\n"
        mkdir -p $INSTALLDIR/tmp
        cp $2 $INSTALLDIR/tmp/pkg.tgz
        cd $INSTALLDIR/tmp/
        tar xf pkg.tgz
        rm pkg.tgz
        NAME=`grep "Name: " .mucfile | sed -e "s/.*:\s//g"`
        cd ..
        mv tmp "$NAME"
        printf "Installed $NAME\n"
    fi
elif [ "$1" = "run" ]
then
    if [ -z "$2" ]
    then
        printf "Wrong usage"
    else
        if [ -d "$INSTALLDIR/$2/" ]
        then
            printf "Getting command...\n"
            
            cd "$INSTALLDIR/$2"
            CMD=`grep "Command: " .mucfile | sed -e "s/.*:\s//g"`
            
            if [ `id -u` = "0" ]
            then
                chroot . $CMD
            else
                printf "Prompting sudo...\n"
                sudo chroot . $CMD
            fi
        fi

    fi
elif [ "$1" = "rund" ]
then
    if [ -z "$2" ]
    then
        printf "Wrong usage"
    else
        if [ -d "$INSTALLDIR/$2/" ]
        then
            printf "Getting command...\n"
            
            cd "$INSTALLDIR/$2"
            CMD=`grep "Command: " .mucfile | sed -e "s/.*:\s//g"`
            printf "Running command...\n"
            if [ `id -u` = "0" ]
            then
                setsid chroot . $CMD >/dev/null 2>&1 < /dev/null &
            else
                printf "Prompting sudo...\n"
                sudo setsid chroot . $CMD >/dev/null 2>&1 < /dev/null &
            fi
        fi
    fi
elif [ "$1" = "test" ]
then
    printf "Checking for mucfile: "

    if [ -f ".mucfile" ]
    then
        printf "FOUND\n"
    else
        printf "NOT FOUND\n"
        exit 1
    fi
    
    printf "Checking for name: "
   
    NAME=`grep "Name: " .mucfile | sed -e "s/.*:\s//g"`
    if [  ! -z "$NAME" ]
    then
        printf "FOUND\n"

        printf "Name: '$NAME'\n"
    else
        printf "NOT FOUND\n"
        exit 1
    fi

    printf "Checking for command: "
    
    CMD=`grep "Command: " .mucfile | sed -e "s/.*:\s//g"`
    if [  ! -z "$CMD" ]
    then
        printf "FOUND\n"

        printf "Command: '$CMD'\n"
    else
        printf "NOT FOUND\n"
        exit 1
    fi
    
    printf "Testrunning...\n"

    if [ `id -u` = "0" ]
    then
        chroot . $CMD
    else
        printf "Prompting sudo...\n"
        sudo chroot . $CMD
    fi

elif [ "$1" = "grab" ]
then
    if [ -z $2 ]
    then
        printf "Usage $0 grab [url]\n"
        exit 1
    else
        printf "Grabbing $2..."
        
        mkdir -p $INSTALLDIR/tmp
        wget -O $INSTALLDIR/tmp/pkg.tgz $2
        printf "Installing...\n"

        cd $INSTALLDIR/tmp/
        tar xf pkg.tgz
        rm pkg.tgz
        NAME=`grep "Name: " .mucfile | sed -e "s/.*:\s//g"`
        cd ..
        mv tmp "$NAME"
        printf "Installed $NAME\n"
    fi
fi
