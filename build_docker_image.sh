#!/bin/bash

set -e
set -x

tag=goose
mizardir=/root/mizar
mizarbuilddir=$mizardir/etc/docker
slavehosts="./slaves.in"
buildlog="/tmp/build_image.out"
declare -a components=("mizar" "dropletd" "endpointopr")
declare -a dockerfiles=("mizar.Dockerfile" "daemon.Dockerfile" "operator.Dockerfile")

build_image(){
    echo ">>>> building images"
    
    rm -f $buildlog >> $buildlog 2>&1
    pushd $mizardir >> $buildlog 2>&1
    length=${#dockerfiles[@]}
    for (( i=0; i<${length}; i++ ));
    do
        echo building vmizarnet/${components[$i]} using $dockerfilepath 
        dockerfilepath="$mizarbuilddir/${dockerfiles[$i]}"
	image="vmizarnet/${components[$i]}:$tag"
	docker rmi -f $image >> $buildlog 2>&1
	docker image build -t $image -f $dockerfilepath . >> $buildlog 2>&1
    done

    popd 2>&1
}

zip_image(){
    echo ">>>> zipping images"
    length=${#dockerfiles[@]}
    for (( i=0; i<${length}; i++ ));
    do
	image="vmizarnet/${components[$i]}:$tag"
	file="./${components[$i]}.tar"
        echo saving $image to ${components[$i]}.tar 
	rm -f $file
	docker save -o $file $image 
	gzip -f ${file}
    done
}

# ref https://stackoverflow.com/questions/22107610/shell-script-run-function-from-script-over-ssh
slave_reload_fn(){
    slavereloadlog=/tmp/reload.out
    rm -f $slavereloadlog
    gzip -d *.gz >> $slavereloadlog 2>&1
    docker rmi -f vmizarnet/mizar:$tag >> $slavereloadlog 2>&1
    docker rmi -f vmizarnet/dropletd:$tag >> $slavereloadlog 2>&1
    docker rmi -f vmizarnet/endpointopr:$tag >> $slavereloadlog 2>&1
    docker load -i ./dr.tar >> $slavereloadlog 2>&1
    docker load -i ./ep.tar >> $slavereloadlog 2>&1
    docker load -i ./mz.tar >> $slavereloadlog 2>&1
}

send_and_reload(){
    slave=$1
    echo ">>>> reloading images on slave $slave"
    scp *.tar.gz $slave:~
    ssh $slave "$(typeset -f slave_reload_fn); slave_reload_fn"
}

distribute_and_reload_images(){
    echo ">> verifying slave host file exist"
    if [ ! -f "$slavehosts" ]; then
        echo "$slavehosts does not exist."
        echo "put IPs of slave hosts in a file called **slave.in** and try again."
        echo "exited on purpose."
        exit
    fi
    
    while IFS= read -r slave
    do
	send_and_reload $slave &
    done < "$slavehosts"
    wait
}

build_image
zip_image
#distribute_and_reload_images
