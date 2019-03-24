#huangshaopeng@wind-mobi 20180904 begin
#######################################################################################################################
###      编译命令: ./quick_build.sh P118F  r/n     必须得加这两个参数，一个项目名，一个new或remake                 ####
###                                                                                                                ####
###      简单编译: ./quick_build.sh P118F  r/n    (remake/new  默认编译userdebug  默认不copy wind目录，不打开宏控) ####
###      编译user: ./quick_build.sh P118F  n  user    (编userdebug加debug)                                         ####
###     copy wind: ./quick_build.sh P118F  r  fc      (fc为copy wind，nc为不copy wind目录)                         ####
###        完整版: ./quick_build.sh P118F  n  debug  fc                                                            ####
###                                                                                                                ####
###      工厂版本: ./quick_build.sh P118F  n  factory                                                              ####
#######################################################################################################################
CPUCORE=32

########################################
WsRootDir=`pwd`
LOG_PATH=$WsRootDir/build-log

PRODUCT=
PROJECT=
VARIANT=
ACTION=
COPYFILES=
BUILDAPK=
MODULE=
LOG_FILE=build.log
WIND_P118F_FACTORY=

########################## 宏控函数 begin ##########################

#  关闭selinux权限
function Close_SELINUX()
{
    sed -i "s/security_getenforce() == 1/security_getenforce() == 0/" $WsRootDir/system/core/init/init.cpp
    echo "Close_SELINUX finished"
}


########################## 宏控函数 end ##########################

# restore code in same as before
revert_code()
{
    echo -e "\033[33mIt's going to revert your code.\033[0m"
    read -n1 -p  "Are you sure? [Y/N]" answer
    case $answer in
        Y | y )
        echo "";;
        *)
    echo -e "\n"
        exit 0 ;;
    esac
   echo "Start revert Code...."
   echo "repo forall -c \"git clean -df\""
   repo forall -c  "git clean -df"
   echo "repo forall -c \"git co .\""
   repo forall -c "git co ."
   echo "rm -rf $LOG_PATH/*"
   rm -rf $LOG_PATH/*
   echo "rm -rf out"
   rm -rf out
   echo -e "\033[33mComplete revert code.\033[0m"
   exit 0
}

# check variant is or isn't the same as input
function Check_Variant()
{
    buildProp=$WsRootDir/out/target/product/$PRODUCT/system/build.prop
    if [ -f $buildProp ] ; then
        buildType=`grep  ro.build.type $buildProp | cut -d "=" -f 2`
        if [ x$buildType != x"user" ] && [ x$buildType != x"userdebug" ]  && [ x$buildType != x"eng" ] ; then return; fi
        if [ x$VARIANT != x$buildType ]; then
            if [ x$ACTION == x"new" ]  ; then
                if [ x$MODULE == x"k" ] || [ x$MODULE == x"pl" ] || [ x$MODULE == x"lk" ] ; then
                    echo -e "\033[35mCode build type is\033[0m \033[31m$buildType\033[35m, your input type is\033[0m \033[31m$VARIANT\033[0m"
                    echo -e "\033[35mIf not correct, Please enter \033[31mCtrl+C\033[35m to Stop!!!\033[0m"
                    for i in $(seq 9|tac); do
                        echo -e "\033[34m\aLeft seconds:(${i})\033[0m"
                        sleep 1
                    done
                    echo
                fi
            else
                echo -e "\033[35mCode build type is\033[0m \033[31m$buildType\033[35m, your input type is\033[0m \033[31m$VARIANT\033[0m"
                echo -e "\033[35mChange build type to \033[31m$buildType\033[0m"
                echo
                VARIANT=$buildType
            fi
        fi
    else
        return;
    fi
}

function build_version()
{
    #add produce verison
    #############################
    #version number
    #############################
    echo "********remove old version********"
       echo
    if [ -f "./version" ] ;then
       rm version
    fi

    VERSION=$WsRootDir/device/qcom/${PRODUCT}/version
    if [ -f "$VERSION" ] ;then
       echo "***************copy new version***************"
       cp $VERSION .
       echo
    else
       echo "File version not exist!!!!!!!!!"
    fi
    INVER=`awk -F = 'NR==1 {printf $2}' version`
    OUTVER=`awk -F = 'NR==2 {printf $2}' version`
    HARDWAREVER=`awk -F = 'NR==3 {printf $2}' version`
    export VER_INNER=$INVER
    export VER_OUTER=$OUTVER
    export VER_HW=$HARDWAREVER
}

function copy_custom_files()
{
    echo "Start copy custom files..."
    #huagnshaopeng@wind-mobi 20180829 begin
    cp -rf ./wind/custom_files/* .
    #huagnshaopeng@wind-mobi 20180829 end
    echo "Copy custom files finish!"
}

function analyze_args()
{
    ### set PRODUCT
    PROJECT=$1
    case $PROJECT in
        WID016)
        PRODUCT=WID016
        echo "PRODUCT=$PRODUCT"
        ;;
        P118F)
        PRODUCT=P118F
        echo "PRODUCT=$PRODUCT"
        ;;
        S100X)
        #PRODUCT=msm8937_64
        echo "PRODUCT=$PRODUCT"
        ;;
        M100)
        #PRODUCT=msm8953_64
        echo "PRODUCT=$PRODUCT"
        ;;
        X100)
        #PRODUCT=X100
        echo "PRODUCT=$PRODUCT"
        ;;
        S200X)
        #PRODUCT=msm8937_64
        echo "PRODUCT=$PRODUCT"
        ;;
        Y10)
        #PRODUCT=msm8909
        echo "PRODUCT=$PRODUCT"
        ;;
        *)
        echo "PRODUCT name error [$PROJECT]!!!"
        exit 1
        ;;
    esac

    command_array=($2 $3 $4 $5)

    for command in ${command_array[*]}; do
        ### set VARIANT
        if [ x$command == x"user" ] ;then
            if [ x$VARIANT != x"" ];then continue; fi
            VARIANT=user
        elif [ x$command == x"debug" ] ;then
            if [ x$VARIANT != x"" ];then continue; fi
            VARIANT=userdebug
        elif [ x$command == x"eng" ] ;then
            if [ x$VARIANT != x"" ];then continue; fi
            VARIANT=eng
        elif [ x$command == x"userroot" ] ;then
            if [ x$VARIANT != x"" ];then continue; fi
            VARIANT=userroot

        ### set ACTION
        elif [ x$command == x"r" ] || [ x$command == x"remake" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=remake
        elif [ x$command == x"n" ] || [ x$command == x"new" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=new
        elif [ x$command == x"c" ] || [ x$command == x"clean" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=clean
            #RELEASE_PARAM=none
        elif [ x$command == x"m" ] || [ x$command == x"make" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=m
            #RELEASE_PARAM=none
        elif [ x$command == x"revert" ] ;then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=revert
            #RELEASE_PARAM=none
        elif [ x$command == x"mmma" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=mmma
            #RELEASE_PARAM=none
        elif [ x$command == x"mmm" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=mmm
            #RELEASE_PARAM=none
            #COPYFILES=yes
        elif [ x$command == x"api" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=update-api
            #RELEASE_PARAM=none
        elif [ x$command == x"boot" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=bootimage
            #RELEASE_PARAM=boot
        elif [ x$command == x"system" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=systemimage
            #RELEASE_PARAM=system
        elif [ x$command == x"userdata" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=userdataimage
            #RELEASE_PARAM=userdata
        elif [ x$command == x"boot-nodeps" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=bootimage-nodeps
            #RELEASE_PARAM=boot
        elif [ x$command == x"snod" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=snod
            #RELEASE_PARAM=system
        elif [ x$command == x"userdata-nodeps" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=userdataimage-nodeps
            #RELEASE_PARAM=userdata
        elif [ x$command == x"ramdisk-nodeps" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=ramdisk-nodeps
            #RELEASE_PARAM=boot
        elif [ x$command == x"recovery" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=recoveryimage
            #RELEASE_PARAM=recovery
        elif [ x$command == x"cache" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=cacheimage
            #RELEASE_PARAM=none
        elif [ x$command == x"otapackage" ] || [ x$command == x"ota" ] ;then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=otapackage
            #RELEASE_PARAM=ota
        elif [ x$command == x"otadiff" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=otadiff
            #RELEASE_PARAM=none
        elif [ x$command == x"cts" ];then
            if [ x$ACTION != x"" ];then continue; fi
            ACTION=cts
            #RELEASE_PARAM=none

        ### set COPYFILES
        elif [ x$command == x"fc" ];then
            if [ x$COPYFILES != x"" ];then continue; fi
            COPYFILES=yes

        elif [ x$command == x"nc" ];then
            if [ x$COPYFILES != x"yes" ];then continue; fi
            COPYFILES=no
            
        ### set factory
        elif [ x$command == x"factory" ];then
            if [ x$WIND_P118F_FACTORY != x"" ];then continue; fi
            WIND_P118F_FACTORY=yes


        ### set MODULE
        elif [ x$command == x"pl" ];then
            if [ x$MODULE != x"" ];then continue; fi
            MODULE=pl
        elif [ x$command == x"k" ] || [ x$command == x"kernel" ];then
            if [ x$MODULE != x"" ];then continue; fi
            MODULE=k
        elif [ x$command == x"ab" ];then
            if [ x$MODULE != x"" ];then continue; fi
            MODULE=ab
        else
            if [ x$MODULE != x"" ];then continue; fi
            MODULE=$command
        fi
    done

    if [ x$PRODUCT == x"" ];then
        echo "ERROR:not find PRODUCT"
        usage
        exit 1
    fi

    if [ x$ACTION == x"" ];then
        echo "ERROR:not find ACTION"
        usage
        exit 1
    fi

    #huangshaopeng@wind-mobi 20171130 modify acquiescence build userdebug begin
    #if [ x$VARIANT == x"" ];then
    #    echo "ERROR:not find VARIANT"
    #    usage
    #    exit 1
    #fi
    #huangshaopeng@wind-mobi 20171130 modify acquiescence build userdebug begin

    #设置默认值
    if [ x$VARIANT == x"" ];then VARIANT=userdebug; fi
    if [ x$ACTION == x"" ];then ACTION=remake; fi
    if [ x$COPYFILES == x"" ];then COPYFILES=no; fi
    if [ x$WIND_P118F_FACTORY == x"" ];then WIND_P118F_FACTORY=no; fi
    
}

#checkout disk space is gt 30G
function Check_Space()
{
    UserHome=`pwd`
    Space=0
    Temp=`echo ${UserHome#*/}`
    Temp=`echo ${Temp%%/*}`
    ServerSpace=`df -lh $UserHome | grep "$Temp" | awk '{print $4}'`

    if echo $ServerSpace | grep -q 'G'; then
        Space=`echo ${ServerSpace%%G*}`
    elif echo $ServerSpace | grep -q 'T';then
        TSpace=1
    fi

    echo -e "\033[34m Log for Space $UserHome $ServerSpace $Space !!!\033[0m"
    if [ x"$TSpace" != x"1" ] ;then
        if [ "$Space" -le "30" ];then
            echo -e "\033[31m No Space!! Please Check!! \033[0m"
            exit 1
        fi
    fi
}


function main()
{
    ##################################################################
    #Check parameters
    ##################################################################
    if [ ! -d $LOG_PATH ];then
        mkdir $LOG_PATH
    fi


    if [ x"$1" = "x" ] || [ x"$1" = x"-help" ] ;then
        usage
        exit 1
    fi

    analyze_args $1 $2 $3 $4 $5

    #add by cenxingcan@wind-mobi.com __add_record.log__ 2017/05/27 start
    echo "`date +"%F %T"`	./quick_build.sh $1 $2 $3 $4 $5" >> $LOG_PATH/record.log
    #add by cenxingcan@wind-mobi.com __add_record.log__ 2017/05/27  end

    if [ x$ACTION == x"revert" ];then
        revert_code
    fi

    ### Check VARIANT WHEN NOT NEW
    Check_Variant

    echo "PRODUCT=$PRODUCT VARIANT=$VARIANT ACTION=$ACTION MODULE=$MODULE COPYFILES=$COPYFILES ORIGINAL=$ORIGINAL WIND_P118F_FACTORY=$WIND_P118F_FACTORY"
    echo "Log Path $LOG_PATH"

    ##################################################################
    #Prepare
    ##################################################################
    Check_Space

    if [ x$COPYFILES == x"yes" ];then
        copy_custom_files
    fi
    
    #factory
    if [ x$WIND_P118F_FACTORY == x"yes" ];then
        Close_SELINUX
    fi
    
    # build-apk
    #if [ x$BUILDAPK == x"yes" ];then
    #    Build_Apk
    #    Set_Encrypted
    #    #Set_ptp
    #fi
    
    build_version
    
    ###################################################################
    #Start build
    ###################################################################
    echo "Build started `date +%Y%m%d_%H%M%S` ..."
    echo;echo;echo;echo

    source build/envsetup.sh
    #lunch $PRODUCT-$VARIANT
    if [ x$VARIANT == x"userroot" ] ; then
        lunch $PRODUCT-user
    else
        lunch $PRODUCT-$VARIANT
    fi

    OUT_PATH=$WsRootDir/out/target/product/$PRODUCT
    case $ACTION in
        new)
        #copy_custom_files
            make clean
        make -j $CPUCORE 2>&1 | tee $LOG_PATH/$LOG_FILE
        ;;
        remake)
        make -j $CPUCORE 2>&1 | tee $LOG_PATH/$LOG_FILE
        ;;

        mmma | mmm | m)
        $ACTION $MODULE 2>&1 | tee $LOG_PATH/$ACTION.log; result=$?
        ;;

        update-api | bootimage | systemimage | recoveryimage | userdataimage | cacheimage | snod | bootimage-nodeps | userdataimage-nodeps | ramdisk-nodeps | otapackage | otadiff | cts)
        make -j$CPUCORE $ACTION 2>&1 | tee $LOG_PATH/$ACTION.log; result=$?
        ;;
    esac

    echo "Build completed `date +%Y%m%d_%H%M%S` ..."
    echo "If you want to release version , please use release_version.sh"

    #add by cenxingcan@wind-mobi.com 2017/05/27 start
    cd $WsRootDir/prebuilts/sdk/tools
    ./jack-admin kill-server
    cd - > /dev/null
    #add by cenxingcan@wind-mobi.com 2017/05/27 end
}

#set -o errexit

usage() {
cat <<USAGE

Usage:
    bash_path$ $0 [PRODUCT] [ACTION] [VARIANT] [COPYFILES]
    e.g : bash_path$ $0 S100X r debug fc wud

PRODUCT:
    S100X | M100 | Y10 | X100 | S200X

ACTION:
    new | remake | n | r | boot | system | userdata

VARIANT:
    user | debug | eng

COPYFILES:
    nc | fc


用法：
    bash_path$ $0 [PRODUCT] [ACTION] [VARIANT] [COPYFILES]
    示例: bash_path$ $0 S100X r debug fc （remake debug版本 copy wind目录）

PRODUCT:
    S100X | M100 | Y10 | X100

ACTION:
    new | remake | n | r | boot | system | userdata

VARIANT:
    user | debug | eng

COPYFILES:
    nc | fc （不copy wind目录 | copy wind目录）

USAGE
}

main $1 $2 $3 $4 $5
#huangshaopeng@wind-mobi 20180904 end
