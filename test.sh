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

function success_test()
{
    printf "\e[94m[+] [$@] : Executing your program for 180 second, please wait...\e[0m\n"
    ($target $@ >/dev/null)&
    i=1
    error=0
    while [ $i -lt 180 ];do
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
    sleep 1
    if [ $error -eq 0 ];then
        pkill -f $target
        printf "\r$GREEN[+] Test Succeeded %s$RESET \n" "✓ "
    fi
}

function failed_test()
{
    printf "\e[94m[+] [$@] : Executing your program, please wait...\e[0m\n"
    ($target $@ > /dev/null)&
    i=1
    error=0
    while [ $i -lt 180 ];do
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

# SUCCESS TESTS
success_test '1 800 200 200'
success_test '4 410 200 200'
success_test '4 310 200 100'
success_test '5 800 200 200'
success_test '5 800 200 200 7'
success_test '2 400 200 100'
success_test '2 399 200 100'
success_test '10 400 200 100'
success_test '100 400 200 100'

# FAILED TESTS
failed_test '3 410 200 200'
failed_test '4 410 300 200'

echo
rm -f ./philo
