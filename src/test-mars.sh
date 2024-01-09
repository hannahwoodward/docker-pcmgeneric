MODEL=gcm_32x32x15_phystd_b32x36_seq.e
PLANET_CONFIG=bench_earlymars_32x32x15_b32x36

# Ensure directory for model runs exists
mkdir -p $HOME/runs

# Compile model
cd $MODELDIR
echo "Compiling PCM"
./makelmdz_fcm -arch local -p std -d 32x32x15 -b 32x36 -j 4 gcm > makelmdz_fcm.out 2>&1

if [ ! -e "bin/$MODEL" ]
    then
        echo "error during compilation" >&2
        exit 1
    fi

cd $HOME/runs
echo "Downloading config $PLANET_CONFIG"
wget -nv --no-check-certificate "https://web.lmd.jussieu.fr/~lmdz/planets/generic/$PLANET_CONFIG.tar.gz"

tar xvzf "$PLANET_CONFIG.tar.gz"

cp "$MODELDIR/bin/$MODEL" "$PLANET_CONFIG/"
cd "$PLANET_CONFIG"

echo "source $MODELDIR/arch.env" > run_gcm.sh
echo "./$MODEL > gcm.out 2>&1" >> run_gcm.sh
chmod u=rwx run_gcm.sh

echo "Running $PLANET_CONFIG with $MODEL"
./run_gcm.sh
