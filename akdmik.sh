#! /bin/bash

input=$1
output=$2
default=$3

if [ -z "$input" ] || [ -z "$output" ]
then
    echo 'Argumentos inválidos, los argumentos son: input, output y (opt) default'
    exit 0
fi

pandoc_dir=~/.local/share/pandoc
dir=$(pwd)

CP() {
	d="$1"
	shift
    mkdir -p "$d"
	for source_file in $@; do
		# cp "$source_file" "$d"
		install -D -m 644 $source_file $d/$source_file
	done
}

# Leer el YAML
if [ -n "$default" ]
then
    css=$(yq '.css' $pandoc_dir/defaults/$3.yaml)
    js=$(yq '.variables.javascript' $pandoc_dir/defaults/$3.yaml)
fi


if [ -n "$css" ]
then
    cd $pandoc_dir
	CP $dir ${css//-/}
    cd $dir
fi

if [ -n "$js" ]
then
    cd $pandoc_dir
	CP $dir ${js//-/}
    cd $dir 
fi


if [ -n "$input" ] && [ -n "$output" ]
then
    if [ -n "$default" ]
    then
        pandoc $input -d $default -s -o $output
	else
    	pandoc $input -s -o $output
	fi
fi
