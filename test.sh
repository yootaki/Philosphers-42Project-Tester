# PHILOSOPHER-TESTER

RESET="\033[0m"
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"

BOLDBLACK="\033[1m\033[30m"
BOLDRED="\033[1m\033[31m"
BOLDGREEN="\033[1m\033[32m"
BOLDYELLOW="\033[1m\033[33m"
BOLDBLUE="\033[1m\033[34m"
BOLDMAGENTA="\033[1m\033[35m"
BOLDCYAN="\033[1m\033[36m"
BOLDWHITE="\033[1m\033[37m"

printf "\n$BOLDMAGENTA _____ _   _ _                 _                  _____        _\n"
printf "|  _  | |_|_| |___ ___ ___ ___| |_ ___ ___ ___   |_   _|__ ___| |_ ___ ___\n"
printf "|   __|   | | | . |_ -| . | . |   | -_|  _|_ -|    | || -_|_ -|  _| -_|  _|\n"
printf "|__|  |_|_|_|_|___|___|___|  _|_|_|___|_| |___|    |_||___|___|_| |___|_|\n"
printf "                          |_|                                              $RESET\n\n"

if [ "$#" -ne 0 ]; then
    printf "$BOLDRED Error: Wrong Arguments $RESET\n"
    printf " Usage: [$ sh test.sh] or [./test.sh]\n"
    exit
fi

# Compile and set executable rights
make -C ../ > /dev/null
cp ../philo .
chmod 755 philo

target="./philo"
testtime="42"

function argument_test()
{
    printf "\e[94m[+] [$@] : Executing your program, please wait...\e[0m\n"
    ($target $@ > /dev/null)&
    i=1
    error=0
    while [ $i -lt $testtime ];do
        printf "\r[%d...]" $i
        pgrep -f $target > /dev/null
        if [ "$?" -ne 0 ];then
            printf "\r$GREEN[+] Test Succeeded %s$RESET \n" "✓ "
            error=1
            break
        fi
        sleep 1
        i=$(( $i + 1 ))
    done
    sleep 1
    if [ $error -eq 0 ];then
        pkill -f $target
        printf "\r$RED[+] Test Failed$RESET\n"
    fi
}

function success_test()
{
    printf "\e[94m[+] [$@] : Executing your program for $testtime second, please wait...\e[0m\n"
    ($target $@ >/dev/null)&
    i=1
    error=0
    while [ $i -lt $testtime ];do
        printf "\r[%d...]" $i
        pgrep -f $target > /dev/null
        if [ "$?" -ne 0 ];then
            printf "\r$RED[+] Test Failed$RESET\n"
            error=1
            break
        fi
        sleep 1
        i=$(( $i + 1 ))
    done
    sleep 42
    if [ $error -eq 0 ];then
        pkill -f $target
        printf "\r$GREEN[+] Test Succeeded %s$RESET \n" "✓ "
    fi
}

function faile_test()
{
    printf "\e[94m[+] [$@] : Executing your program, please wait...\e[0m\n"
    ($target $@ > /dev/null)&
    i=1
    error=0
    while [ $i -lt $testtime ];do
        printf "\r[%d...]" $i
        pgrep -f $target > /dev/null
        if [ "$?" -ne 0 ];then
            printf "\r$GREEN[+] Test Succeeded %s$RESET \n" "✓ "
            error=1
            break
        fi
        sleep 1
        i=$(( $i + 1 ))
    done
    sleep 1
    if [ $error -eq 0 ];then
        pkill -f $target
        printf "\r$RED[+] Test Failed$RESET\n"
    fi
}

# ARGUMENT TESTS
printf "\e[94m[+] [=====[Argument Test]=====]\e[0m\n"
argument_test '\0'
argument_test '4 600 100'
argument_test '4 600 100 100 100 100'
argument_test '0 600 100 100'
argument_test '4 -600 100 100'
argument_test '4 600 2147483648 100'
argument_test '4 600 "" 100'
argument_test '4 test 100 100'
argument_test '4 6x0 1x0 1x0'

# SUCCESS TESTS
printf "\e[94m[+] [=====[Success Test]=====]\e[0m\n"
success_test '2 410 200 200'
success_test '3 610 200 200'
success_test '4 410 200 200'
success_test '5 610 200 200'
success_test '6 410 200 200'
success_test '10 410 200 200'
success_test '50 410 200 200'
success_test '100 410 200 200'

# FAILE TESTS
printf "\e[94m[+] [=====[Faile Test]=====]\e[0m\n"
faile_test '1 600 100 100'
faile_test '2 399 200 100'
faile_test '3 410 200 200'
faile_test '4 310 200 100'
faile_test '4 410 300 200'

echo
rm -f ./philo
