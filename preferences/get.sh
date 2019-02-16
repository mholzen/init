file=$1

if [ ! -r $file ]; then
  echo "cannot find $file"
fi

cp src/$file .
