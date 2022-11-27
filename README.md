# Laracasts Downloader

> This project is a fork of [github.com/carlosflorencio/laracasts-downloader](carlosflorencio/laracasts-downloader).
The original project is not maintained currently, but I had some issues with it, so I fixed it for myself.

## Features

Downloads new lessons and series from Laracasts if there are updates. Or the whole catalog.

Syncs your local folder with the Laracasts website, when there are new lessons the app downloads them for you.
If your local folder is empty, all lessons and series will be downloaded!

A .skip file is used to prevent downloading deleted lessons for those with space problems. Thanks to @vinicius73

Just call `php makeskips.php` before deleting the lessons.

> You need an active subscription account to use this script.

## Requirements

### For manual installation

- PHP >= 7.3
- php-cURL
- php-xml
- php-json
- Composer
- [FFmpeg](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwio6vX03pT7AhU0X_EDHSx9BMkQFnoECAkQAQ&url=https%3A%2F%2Fffmpeg.org%2F&usg=AOvVaw19lCX0sMAnAOlyM2Pvp5-v) (required if ``DOWNLOAD_SOURCE=vimeo``)

### For containerized, semi-automated installation

- Docker
- Docker Compose
- On Linux GNU Make utility is recommended.

## Installation

1. Clone this repo to your local machine.
2. Make a local copy of the `.env` file:
```sh
$ cp .env.example .env
```
3. Update your Laracasts account credentials (`EMAIL`, `PASSWORD`) in .env
4. Decide whether you want to use **vimeo** or **laracasts** as `DOWNLOAD_SOURCE`.
   By using the Laracasts link you are limited to 30 downloads per day and can't customize video quality.
6. Choose your preferred quality (240p, 360p, 540p, 720p, 1080p, 1440p, 2160p) by changing **VIDEO_QUALITY** in ``.env``.
   (will be ignored if `DOWNLOAD_SOURCE=laracasts`)
7. Choose if you want a local installation or a Docker-based installation, then follow the corresponding steps below.

### Using your local machine
1. Install project dependencies:
```sh
$ composer install
```
2. To run a download of all content, run the following command:
```sh
$ php start.php
```
3. See [downloading specific series or lessons](#downloading-specific-series-or-lessons) for optional flags.

### Docker container, using Makefile (on Linux)

A Makefile is provided for easy installation on Linux with Docker and Docker-Compose. The `make` utility must be installed.

1. Setup container:
```sh
$ make install
```
During the setup, your Linux user account and group ID will be appended to your .env for the Docker container.

2. Edit your `.env` file with your Laracasts account details (user account email and password).

3. Enter the containers shell:
```sh
$ make shell
```

4. Start download in the container:
```sh
$ php ./start.php [empty for all OR provide flags]
```

### Docker container, without using the Makefile

> This information is from the legacy documentation, so handle it with care. You should probably follow the commands
from the Makefile.

1. Build the image:
```sh
$ docker-compose build
```
2. Install project dependencies:
```sh
$ docker-compose run --rm composer
```
3. Then, run the command of your choice as if we were running it locally, but instead against the docker container:
```sh
$ docker-compose run --rm laracastdl php ./start.php [empty for all OR provide flags]
```
4. See [downloading specific series or lessons](#downloading-specific-series-or-lessons) for optional flags.

## Using Laracasts Downloader

- You can download multiple `series` or `lessons`.
- To download, you can specify the `name` or `slug` of the series or the lesson (the slug is preferred).

### Commands to download an entire series

You can either use the Series slug (preferred):
```sh
$ php start.php -s "series-slug-example"
$ php start.php --series-name "series-slug-example"
```
Or the Series name:
```sh
$ php start.php -s "Series name example"
$ php start.php --series-name "Series name example"
```

### Filter to download specific episodes of a series

You can provide episode number(s) separated by comma ```,```:

```sh
$ php start.php -s "lesson-slug-example" -e "12,15"
$ php start.php --series-name "series-slug-example" --series-episodes "12,15"
```

This will only download the episodes which you mentioned in
-e or --series-episodes flag, it will also ignore already downloaded episodes
as usual.

```sh
$ php start.php -s "nuxtjs-from-scratch" -e "12,15" -s "laravel-from-scratch" -e "5"
```

It will download episodes 12 and 15 for "nuxtjs-from-scratch" and episode 5 for "laravel-from-scratch" course.

```sh
$ php start.php -s "nuxtjs-from-scratch" -e "12,15" -s "laravel-from-scratch"
```

It will download episodes 12 and 15 for "nuxtjs-from-scratch" course and all episodes for "laravel-from-scratch" course.

## Troubleshooting

If you have a `cURL error 60: SSL certificate problem: self-signed certificate in certificate chain` or `SLL error: cURL error 35` do this:

- Download [http://curl.haxx.se/ca/cacert.pem](http://curl.haxx.se/ca/cacert.pem)
- Add `curl.cainfo = "PATH_TO/cacert.pem"` to your php.ini

And you are done! If using apache you may need to restart it.

## License

This library is under the MIT License, see the complete license [here](LICENSE)
