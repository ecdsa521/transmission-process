@destination = "/data/media/seeds/by-tracker"
@remove_files = false
@url = "http://127.0.0.1:9091/transmission/rpc"

#tracker => label map
@labels = {
    "TV"        => [/tv.tracker/],
    "Movies"    => [/movie.tracker/],
    "Music"     => [/music.tracker/]
}