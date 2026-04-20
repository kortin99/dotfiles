function kill-port
    if test -z "$argv[1]"
        echo "Usage: kill-port <port>"
        return 1
    end
    set port $argv[1]
    set pid (lsof -t -i:$port)
    if test -z "$pid"
        echo "No process found listening on port $port"
        return 1
    end
    echo "Killing process $pid on port $port"
    kill -9 $pid
end
