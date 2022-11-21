
alias accounts='ls /home'
export Q2=~/class/h03/q02
export WEB=~/public_html

function extract() {
        X=$1
        in="a0$X.tar.gz"
        out="t$X.txt"
        tar -xvf $in > $out
}

function cleanup() {
        X="$1"
        ax="a$X"          
        out="t$X.txt"

        if [ -e $out ]                     
        then
                rm $out                   
        fi

        if [ -e $ax ]                   
        then
                rm -r $ax
        fi        
}
