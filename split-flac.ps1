function split-flac ($dir){
    foreach ($dir in $(dir)) {
        $dir | cd

        write-host "Currently working on $($dir.name)"
        if(test-path ./done){
            cd ..

            write-host "This dir is done. Proceeding to next"
            continue
        }

        $flac = dir *.flac
        $cue = dir *.cue

        $answer = Read-Host "I found $($flac.name) and $($cue.name). Shall I continue? Press 'Y'"
    
        if ($answer -eq 'Y') {
            write-host "Splitting now!"
            shnsplit -f $cue.name -t %n-%t -o flac $flac.name
        }

        else{

            write-host "Skipping this dir"
            continue
        }
    
        write-host "REmoving Original files after splist"
        $flac | Remove-Item -Force
        $cue | Remove-Item -Force
        beet import .

        touch done
        cd ..
    }

}

split-flac -dir ..............................................