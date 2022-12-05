cd /app
mkdir -p data
if [[ -p ".tmp" ]]; then
    rm .tmp
fi
mkfifo .tmp
cat .tmp | (dotnet /neo/neo-cli.dll >> run.log 2>&1 && echo > .tmp)

rm -rf .tmpdir
mkdir -p .tmpdir/data
INDEX=`curl https://neoburger.blob.core.windows.net/data/index`
HEX=`printf "%08X\n" $INDEX`
SRC=data/${HEX:0:1}/${HEX:1:1}/${HEX:2:1}/${HEX:3:1}/${HEX:4:1}/${HEX:5:1}/${HEX:6:1}/${HEX:7:1}/${INDEX}.json
while [ -f $SRC ];do echo $SRC && cp $SRC .tmpdir/data/${INDEX}.json && INDEX=$((INDEX+1)); HEX=`printf "%08X\n" $INDEX`;SRC=data/${HEX:0:1}/${HEX:1:1}/${HEX:2:1}/${HEX:3:1}/${HEX:4:1}/${HEX:5:1}/${HEX:6:1}/${HEX:7:1}/${INDEX}.json;done
echo $INDEX > .tmpdir/index

az storage blob upload-batch --max-connections 200 --overwrite true --destination data --source .tmpdir/data --account-name neoburger --account-key $key
az storage blob upload --overwrite true --container-name data --file .tmpdir/index --account-name neoburger --account-key $key