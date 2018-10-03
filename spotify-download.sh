#!/bin/bash
spotify_directory=~/spotify
run_spotdl="pipenv run spotdl"

usage() {
    echo "Usage: $(basename $0) <Url_to_spotify_song_or_playlist>"
}

download_playlist() {
    ${run_spotdl} --playlist $1
    local playlist_name=$(ls *.txt)
    ${run_spotdl} --list ${playlist_name}
    rm ${playlist_name}
}

download_song() {
    ${run_spotdl} --song $1
}

download_spotify() {
    [ -x pip ] && sudo -H pip install -U pipenv python3-distutils
    mkdir -p ${spotify_directory}
    cd ${spotify_directory}
    pipenv --python 3.6 install spotdl
}

main() {
    [ -d "${spotify_directory}" ] || download_spotify
    cd ${spotify_directory}
    if [[ $1 = *"playlist"* ]]; then
        download_playlist $1
    elif [[ $1 = *"track"* ]]; then
        download_song $1
    else
        echo "Given URL does not contain playlists or track, exiting."
        exit 1
    fi
    exit 0
}

if [ "$#" -ne 1 ]; then
   usage
   exit 1
else
    main $1
fi

