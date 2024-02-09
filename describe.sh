for filename in ch*
    do
        echo $filename
        identify -units PixelsPerInch -format '%x, %y\n' $filename
        identify -format "%[fx:w] x %[fx:h]\n" $filename
        identify -format '%[fx:w/300]" x %[fx:h/300]"\n\n' $filename
    done
